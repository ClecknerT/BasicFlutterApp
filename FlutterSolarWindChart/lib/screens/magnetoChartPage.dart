import 'package:chart/services/magnetoFLService.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MagnetoChartPage extends StatefulWidget {

  const MagnetoChartPage({Key? key}) : super(key: key);

  @override
  State<MagnetoChartPage> createState() => _MagnetoChartPageState();
}

class _MagnetoChartPageState extends State<MagnetoChartPage> {

  late MagnetoFLService _MagnetoFLService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _MagnetoFLService = Provider.of<MagnetoFLService>(context, listen: false);
    _MagnetoFLService.initData();

  }

  @override
  Widget build(BuildContext context) {
    Provider.of<MagnetoFLService>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "GOES Magnetometers (1-minute data)"
        ),
      ),
      body:
      _MagnetoFLService.loading?
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
              ),child :LineChart(_MagnetoFLService.magData()),
            ),
          )
        ],
      )
    );
  }

}
