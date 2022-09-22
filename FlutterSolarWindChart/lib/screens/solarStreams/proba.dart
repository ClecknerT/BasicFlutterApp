import 'package:flutter/material.dart';

import 'imageNetwork.dart';

class PROBAtream extends StatefulWidget {
  PROBAtream({Key? key}) : super(key: key);

  @override
  State<PROBAtream> createState() => _PROBAtreamState();
}

class _PROBAtreamState extends State<PROBAtream> {

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('PROBA2/SAP 174'),
          ],
        ),
                ImageNetworkWidget(
                  imageUrl:
                      'https://proba2.sidc.be/swap/data/qlviewer/SWAPlatest.png',
                  videoUrl:
                      'https://proba2.oma.be/swap/data/mpg/movies/latest_swap_movie.mp4',
                  speed: 2.5
                ),
      ],
    );
  }
}
