// for managing the video player of the video message
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late CachedVideoPlayerController videoController;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    // create videController based on url, we will tell videoController what to play
    videoController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize() // 2 dots for cascading operator where we dont have to care about future async/await, search it
          .then((value) => videoController.setVolume(1));
    // late because no point of creating them before initState which means before this widget is built
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose(); // dispose when need over
  }

  @override
  Widget build(BuildContext context) {
    // return the video of size 16:9
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: GestureDetector(
          onTap: () {
            if (isPlaying) {
              videoController.pause();
            } else {
              videoController.play();
            }
            setState(() {
              isPlaying = !isPlaying; // reverse the value of isPlaying
            });
          },
          child: Stack(
            // stack so that we can add the video player and the play button
            children: [
              CachedVideoPlayer(videoController),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 7, 7, 0),
                child: Align(
                    alignment: Alignment.topRight,
                    child: isPlaying ? const Icon(Icons.pause) : const Icon(Icons.play_circle_fill_rounded)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
