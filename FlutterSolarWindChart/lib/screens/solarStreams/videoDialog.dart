import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDialog extends StatefulWidget {

  VideoDialog(
      {Key? key,
        required this.videoUrl,
        required this.speed})
      : super(key: key);
  String imageUrl = '';
  String videoUrl = '';
  double speed = 1;

  @override
  State<VideoDialog> createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog> {

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _controller.setPlaybackSpeed(widget.speed);
    _controller.setLooping(true);
    _controller.initialize().then((value) {
      setState(() {});
      _controller.play();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double deviceWidth = isLandscape
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width;


    return Dialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          width: deviceWidth,
          height: deviceWidth - 60,
          child: _controller.value.isInitialized
              ? VideoPlayer(_controller)
              : const Center(
                  child: CircularProgressIndicator()),
        ));
  }
}
