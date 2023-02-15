import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'video_fire_model.dart';

class MVFBloc {
  ValueNotifier<List<VFModel>> videoNotifier = ValueNotifier([]);
  final Reference storageRef = FirebaseStorage.instance.ref();
  ValueNotifier<bool> isUploadInProgress = ValueNotifier(false);

  updateVideos(VFModel vfModel) {
    List<VFModel> _vids = [];
    _vids.addAll(videoNotifier.value);
    _vids.add(vfModel);
    videoNotifier.value = _vids;
  }

  void pickFile() async {
    try {
      isUploadInProgress.value = true;
      FilePickerResult? filePickerResult = (await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
      ));
      if (filePickerResult == null && filePickerResult!.files.isEmpty) {
        isUploadInProgress.value = false;
        return;
      }

      PlatformFile file = filePickerResult.files.first;

     await _uploadToFirebase(file);

    } catch (e) {
      print(e);
    }

    isUploadInProgress.value = false;
  }

  Future<void> _uploadToFirebase(PlatformFile file) async {
    try {

      // This line changed
      final fileBytes = file.bytes;

      if (kIsWeb) {
        // running on the web!
        await storageRef.child(file.name).putData(fileBytes!).then((p0) async {
         await _onUploadComplete(p0, file);
        });
      } else {
        // NOT running on the web! You can check for additional platforms here.
        await storageRef.child(file.name).putFile(File(file.path!)).then((p0) async {
          await _onUploadComplete(p0, file);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onUploadComplete(TaskSnapshot p0,PlatformFile file) async {
    int uploadTime = DateTime.now().millisecondsSinceEpoch;
    if (p0.state == TaskState.success) {
      String url = await storageRef.child(file.name).getDownloadURL();
      VFModel vfModel =
      VFModel(name: file.name, uploadTime: uploadTime, url: url);
      // TODO : upload this model to real time data.

      final urlrtdb = Uri.https(
        'videoplayerfirebase-bbd42-default-rtdb.firebaseio.com',
        '/Videos.json',
      );
      await http.post(
        urlrtdb,
        body: json.encode(
          {
            'name': vfModel.name,
            'uploadTime': vfModel.uploadTime,
            'url': vfModel.url,
          },
        ),
      );
      updateVideos(vfModel);
    }
  }

  void getExistingData() async {
    try {
      final urlrtdb = Uri.https(
        'videoplayerfirebase-bbd42-default-rtdb.firebaseio.com',
        '/Videos.json',
      );
      final response = await http.get(urlrtdb);
      Map<String, dynamic>? data = jsonDecode(response.body);
      data?.forEach((key, _data) {
        try {
          VFModel vfModel = VFModel.fromMap(_data as Map<String, dynamic>);
          updateVideos(vfModel);
        } catch (e) {
          log("ERROR!!! UNABLE TO PARSE VIDEO - $e");
        }
      });
    } catch (e) {
      log("ERROR!!!!! WHILE FETCHING --  $e");
    }
  }
}
