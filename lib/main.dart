import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:videoplayerfirebase/ui/index.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'my_vide_fire_bloc/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // running on the web!
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCKoKiuDCqhArixozmMZc2Y2i_nyLYxCOs",
            appId: "1:202009261421:web:bc9256974fd591354c9664",
            messagingSenderId: "202009261421",
            storageBucket: "videoplayerfirebase-bbd42.appspot.com",
            projectId: "videoplayerfirebase-bbd42"));
  } else {
    // NOT running on the web! You can check for additional platforms here.
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: kHomePageTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MVFBloc mvfBloc = MVFBloc();

  @override
  void initState() {
    mvfBloc.getExistingData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ValueListenableBuilder<List<VFModel>>(
        valueListenable: mvfBloc.videoNotifier,
        builder: (context, videos, _) {
          if (videos.isEmpty) {
            return const Center(
              child: Text(kNoVideosAvailable),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Wrap(
              children: _generateChildren(context, videos),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!mvfBloc.isUploadInProgress.value) {
            mvfBloc.pickFile();
          }
        },
        backgroundColor: Colors.blue,
        child: ValueListenableBuilder<bool>(
          valueListenable: mvfBloc.isUploadInProgress,
          builder: (context, isUploadInProgress,_) {
            if (isUploadInProgress) {
              return const CircularProgressIndicator(color: Colors.white10,);
            }
            return const Icon(
              Icons.add,
            );
          }
        ),
      ),
    );
  }

  List<Widget> _generateChildren(BuildContext context, List<VFModel> videos) {
    List<Widget> items = [];

    double tileDim = MediaQuery.of(context).size.width*(0.4);
    for (int i = 0; i < videos.length; i++) {
      items.add(
        _generateItem(tileDim, videos[i]),
      );
    }

    return items;
  }

  Widget _generateItem(double dim, VFModel video) {
    return VideoFireItem(
      key: UniqueKey(),
      video: video,
      dim: dim,
    );
  }
}
