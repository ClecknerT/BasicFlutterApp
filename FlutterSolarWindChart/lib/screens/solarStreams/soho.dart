import 'package:flutter/material.dart';

import 'imageNetwork.dart';

class SOHOStream extends StatefulWidget {
  const SOHOStream({Key? key}) : super(key: key);

  @override
  State<SOHOStream> createState() => _SOHOStreamState();
}

class _SOHOStreamState extends State<SOHOStream> {
  List sohoEit = ['171', '195', '284', '304'];
  String sohoDropdownValue = '284';
  String sohoVidUrl =
      'https://soho.nascom.nasa.gov/data/LATEST/current_eit_284.mp4';
  String sohoPicUrl =
      'https://soho.nascom.nasa.gov/data/LATEST/current_eit_284.jpg';
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
            const Text('SOHO'),
            const SizedBox(width: 10),
            DropdownButton<String>(
              value: sohoDropdownValue,
              underline: Container(
                height: 0,
              ),
              dropdownColor: Colors.blueGrey,
              items: <String>[
                '171',
                '195',
                '284',
                '304',
                'igr',
                'mag',
                'c2',
                'c3',
                'c2_combo',
                'c3_combo',
              ].map<DropdownMenuItem<String>>((String sovalue) {
                return DropdownMenuItem<String>(
                  value: sovalue,
                  child: Text(
                    sovalue,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (String? sonewValue) {
                setState(() {
                  sohoDropdownValue = sonewValue!;
                  if (['171', '195', '284', '304'].contains(sonewValue)) {
                    sohoVidUrl =
                        'https://soho.nascom.nasa.gov/data/LATEST/current_eit_$sonewValue.mp4'; //https://soho.nascom.nasa.gov/data/LATEST/current_eit_195.mp4
                    sohoPicUrl =
                        'https://soho.nascom.nasa.gov/data/LATEST/tinyeit_$sonewValue.jpg';//https://soho.nascom.nasa.gov/data/LATEST/tinyeit_171.jpg
                  } else if (sonewValue == 'igr') {
                    sohoVidUrl =
                        'https://soho.nascom.nasa.gov/data/LATEST/current_hmi_igr.mp4';
                    sohoPicUrl =
                        'https://soho.nascom.nasa.gov/data/LATEST/tinyhmi_igr.jpg';//https://soho.nascom.nasa.gov/data/LATEST/tinyhmi_igr.jpg
                  } else if (sonewValue == 'mag') {
                    sohoVidUrl =
                        'https://soho.nascom.nasa.gov/data/LATEST/current_hmi_mag.mp4';
                    sohoPicUrl =
                        'https://soho.nascom.nasa.gov/data/LATEST/tinyhmi_mag.jpg';
                  } else if (sonewValue == 'c2' || sonewValue == 'c3') {
                    sohoVidUrl =
                        'https://soho.nascom.nasa.gov/data/LATEST/current_$sonewValue.mp4';
                    sohoPicUrl =
                        'https://soho.nascom.nasa.gov/data/LATEST/tiny$sonewValue.gif';//https://soho.nascom.nasa.gov/data/LATEST/current_c2_combo.jpg
                  } else {
                    sohoVidUrl =
                        'https://soho.nascom.nasa.gov/data/LATEST/current_$sonewValue.mp4';
                    sohoPicUrl =
                        'https://soho.nascom.nasa.gov/data/LATEST/current_$sonewValue.jpg';
                  }
                });
              },
            )
          ],
        ),
        ImageNetworkWidget(
          imageUrl: sohoPicUrl,
          videoUrl: sohoVidUrl,
          speed: .25
        ),
      ],
    );
  }
}
