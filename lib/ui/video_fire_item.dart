import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

import '../my_vide_fire_bloc/video_fire_model.dart';
import 'mvf_player.dart';
import 'utils.dart';

class VideoFireItem extends StatelessWidget {
  final VFModel video;
  final double dim;

  const VideoFireItem({Key? key, required this.video, required this.dim})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: dim,
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MVFPlayer(
                  key: UniqueKey(),
                  controller: VideoPlayerController.network(video.url),
                  videoSize: Size(
                    MediaQuery.of(context).size.width * (0.5),
                    MediaQuery.of(context).size.height * (0.5),
                  ),
                ),
              ),
            );
          },
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2,color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
          leading: const Icon(
            Icons.video_collection,
            color: Colors.blue,
            size: 40,
          ),
          title: Text(
            video.name,
            style: UIUtils.cardStyle(),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 2,
          ),
          subtitle: Text(
            "${UIUtils.getDateOfUpload(video.uploadTime)}, ${UIUtils.getTimeOfUpload(video.uploadTime)}",
            style: UIUtils.subtitleStyle(),
          ),
        ),
      ),
    );
  }
}
