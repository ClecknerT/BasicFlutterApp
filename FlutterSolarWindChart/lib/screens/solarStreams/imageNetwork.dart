import 'package:chart/screens/solarStreams/videoDialog.dart';
import 'package:flutter/material.dart';

class ImageNetworkWidget extends StatelessWidget {
  ImageNetworkWidget(
      {Key? key,
      required this.imageUrl,
      required this.videoUrl,
      required this.speed})
      : super(key: key);
  String imageUrl = '';
  String videoUrl = '';
  double speed = 1;


  @override
  Widget build(BuildContext context) {
    print('3333333333333333333 ImageNetworkWidget imageUrl ${imageUrl}');
    print('3333333333333333333 ImageNetworkWidget videoUrl ${videoUrl}');
    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double deviceWidth = isLandscape
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width;
    return IconButton(
            iconSize: deviceWidth / 3,
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (_) {
                    return VideoDialog(
                      videoUrl: videoUrl,
                      speed: speed,
                    );
                  } //SDOVideo()
                  );
            },
            icon: Image.network(imageUrl));
  }
}
