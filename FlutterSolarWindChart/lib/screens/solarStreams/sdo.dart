import 'package:flutter/material.dart';

import 'imageNetwork.dart';

class SDOStream extends StatefulWidget {
  SDOStream({Key? key}) : super(key: key);

  @override
  State<SDOStream> createState() => _SDOStreamState();
}

class _SDOStreamState extends State<SDOStream> {
  List sdoSynoptic = ['0131', '0171', '0193', '0211', '0304'];
  String sdoDropdownValue = '0193';
  String sdoVideoUrl = '0193_synoptic.mp4';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('SDO'),
            const SizedBox(width: 10),
            DropdownButton<String>(
              value: sdoDropdownValue,
              underline: Container(
                height: 0,
              ),
              dropdownColor: Colors.blueGrey,
              items: <String>[
                '0094',
                '0131',
                '0171',
                '0193',
                '0211',
                '0304',
                '0335',
                '1600',
                '1700',
                '4500',
                '211193171',
                'HMIB',
                'HMIBC',
                'HMID',
                'HMII',
                'HMIIC',
                'HMIIF'
              ].map<DropdownMenuItem<String>>((String svalue) {
                return DropdownMenuItem<String>(
                  value: svalue,
                  child: Text(
                    svalue,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (String? snewValue) {
                setState(() {
                  sdoDropdownValue = snewValue!;
                  if (['0131', '0171', '0193', '0211', '0304']
                      .contains(snewValue)) {
                    sdoVideoUrl = '$snewValue' '_synoptic.mp4';
                  } else {
                    sdoVideoUrl = '$snewValue.mp4';
                  }
                });
              },
            )
          ],
        ),
        ImageNetworkWidget(
          imageUrl:
              'https://sdo.gsfc.nasa.gov/assets/img/latest/latest_256_$sdoDropdownValue.jpg',
          videoUrl:
              'https://sdo.gsfc.nasa.gov/assets/img/latest/mpeg/latest_512_$sdoVideoUrl',
          speed: 1
        ),
      ],
    );
  }
}
