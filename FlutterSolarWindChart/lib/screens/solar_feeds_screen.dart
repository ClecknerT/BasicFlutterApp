import 'package:chart/screens/solarStreams/proba.dart';
import 'package:chart/screens/solarStreams/sdo.dart';
import 'package:chart/screens/solarStreams/soho.dart';
import 'package:flutter/material.dart';



class SolarFeedsScreen extends StatefulWidget {
  static const routeName = '/solar-feeds';
  const SolarFeedsScreen({Key? key}) : super(key: key);

  @override
  State<SolarFeedsScreen> createState() => _SolarFeedsScreenState();
}

class _SolarFeedsScreenState extends State<SolarFeedsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solar Streams'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.orange,
      ),
      // drawer: AppDrawer(isSubscriber: true,),
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SDOStream(),
                const SOHOStream(),
                PROBAtream(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
