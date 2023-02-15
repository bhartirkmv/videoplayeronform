import 'dart:async';

import 'package:flutter/material.dart';
import 'package:videoplayerfirebase/ui/utils.dart';
import 'package:video_player/video_player.dart';

class MVFPlayer extends StatefulWidget {
  final Size videoSize;
  final VideoPlayerController controller;

  const MVFPlayer({
    required super.key,
    required this.videoSize,
    required this.controller,
  });

  @override
  State<MVFPlayer> createState() => _MVFPlayerState();
}

class _MVFPlayerState extends State<MVFPlayer> {
  @override
  void initState() {
    loadVideoPlayer();
    super.initState();
  }

  @override
  dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
  }

  loadVideoPlayer() {
    widget.controller.addListener(() {
      setState(() {});
    });
    widget.controller.initialize().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        SizedBox(
          height: widget.videoSize.height,
          width: widget.videoSize.width,
          child: VideoPlayer(widget.controller),
        ),
        VideoProgressIndicator(widget.controller,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              backgroundColor: Colors.redAccent,
              playedColor: Colors.green,
              bufferedColor: Colors.purple,
            )),
        Row(
          children: [
            IconButton(
                onPressed: () {
                  if (widget.controller.value.isPlaying) {
                    widget.controller.pause();
                  } else {
                    widget.controller.play();
                  }

                  setState(() {});
                },
                icon: Icon(widget.controller.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow)),
            IconButton(
                onPressed: () {
                  widget.controller.seekTo(Duration(seconds: 0));
                  setState(() {});
                },
                icon: const Icon(Icons.stop)),
            Text(
                "Duration: ${UIUtils.durationToString(widget.controller.value.duration)}"),
          ],
        ),
      ]),
    );
  }
}
