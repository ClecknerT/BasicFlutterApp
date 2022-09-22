import 'package:chart/services/solarWindFLService.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SolarWindChartPage extends StatefulWidget {

  const SolarWindChartPage({Key? key}) : super(key: key);

  @override
  State<SolarWindChartPage> createState() => _SolarWindChartPageState();
}

class _SolarWindChartPageState extends State<SolarWindChartPage> {

  late SolarWindFlService _SolarWindFlService;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _SolarWindFlService = Provider.of<SolarWindFlService>(context, listen: false);
    _SolarWindFlService.initData();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<SolarWindFlService>(context);
    // TODO: implement build
    return Scaffold(
      body:
      _SolarWindFlService.loading?
      const Center(
        child: CircularProgressIndicator(),
      ):
      Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 10,
                    right: 10,
                  ),child :LineChart(_SolarWindFlService.btzData()),
                ),
                Positioned(
                  bottom: 0,
                  left: 30,
                  child: Text(
                    _SolarWindFlService.magSatellite
                  ),
                )
              ],
            )
          ),
          Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 10,
                      right: 10,
                    ),child :LineChart(_SolarWindFlService.phiData()),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 30,
                    child: Text(
                        _SolarWindFlService.magSatellite
                    ),
                  )
                ],
              )
          ),
          Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 10,
                      right: 10,
                    ),child :LineChart(_SolarWindFlService.densityData()),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 30,
                    child: Text(
                        _SolarWindFlService.windSatellite
                    ),
                  )
                ],
              )
          ),
          Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 10,
                      right: 10,
                    ),child :LineChart(_SolarWindFlService.speedData()),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 30,
                    child: Text(
                        _SolarWindFlService.windSatellite
                    ),
                  )
                ],
              )
          ),
          Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 10,
                      right: 10,
                    ),child :LineChart(_SolarWindFlService.tempData()),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 30,
                    child: Text(
                        _SolarWindFlService.windSatellite
                    ),
                  )
                ],
              )
          ),
        ],
      )
    );
  }

}
