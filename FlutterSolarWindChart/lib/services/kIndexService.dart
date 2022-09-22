import 'package:chart/helpers/apiHelper.dart';
import 'package:chart/models/kIndexModel.dart';
import 'package:chart/models/xRayModel.dart';
import 'package:flutter/material.dart';

class KIndexService extends ChangeNotifier {

  List<KIndexModel> _series = [];
  bool loading = true;
  static final List<String> scripts = [
    "https://code.highcharts.com/8.0.0/highcharts.js",
    "https://code.highcharts.com/8.0.0/modules/accessibility.js"
  ];

  initData() async {
    _series = await ApiHelper.getKpSeries();
    loading = false;
    notifyListeners();
  }

  String xRayChartString(height) {

    List<List> _data = [];

    for(var item in _series) {
      _data.add([item.time.millisecondsSinceEpoch, item.kp]);
    }

    return '''
      {
            chart: {
                height: $height,
                type: 'column'
            },
            title: {
              text: ''
            },
            tooltip: {
                xDateFormat: '%Y-%m-%d %H:%M',
                shared: true,
                crosshairs: [true]
            },
            xAxis: {
                type: 'datetime',
                title: {
                  text: 'Universal Time'
                }
            },
            yAxis: {
                title: {
                    text: 'Kp index'
                },
            },
            legend: {
                enabled: false,
            },
            series: [{
                name: 'Kp',
                zoneAxis: 'y',
                zones: [
                  {
                      value: 4,
                      color: 'green'
                  },
                  {
                      value: 5,
                      color: 'yellow',
                  },
                  {
                      color: 'red',
                   }
                ],
                data: $_data
            }]
        }
      ''';
  }

}