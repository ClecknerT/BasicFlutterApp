import 'package:chart/services/xRayFLService.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class XRayChartPage extends StatefulWidget {

  XRayChartPage({Key? key}) : super(key: key);

  @override
  State<XRayChartPage> createState() => _XRayChartPageState();
}

class _XRayChartPageState extends State<XRayChartPage> {

  late XrayFLService _XrayFLService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _XrayFLService = Provider.of<XrayFLService>(context, listen: false);
    _XrayFLService.initData();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<XrayFLService>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "GOES X-Ray Flux (1-minute data)"
        ),
      ),
      body:
      _XrayFLService.loading?
      const Center(
        child: CircularProgressIndicator(),
      ):
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 10,
                right: 10,
              ),child :LineChart(_XrayFLService.xrayData()),
            ),
          )
        ],
      )
    );
  }

}
