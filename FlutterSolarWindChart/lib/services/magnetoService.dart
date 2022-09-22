import 'package:chart/helpers/apiHelper.dart';
import 'package:chart/models/magnetoModel.dart';
import 'package:flutter/material.dart';

class MagnetoService extends ChangeNotifier {

  List<MagnetoModel> _goes16Series = [];
  List<MagnetoModel> _goes17Series = [];
  bool loading = true;
  static final List<String> scripts = [
    "https://code.highcharts.com/8.0.0/highcharts.js",
    "https://code.highcharts.com/8.0.0/modules/accessibility.js",
    "https://code.highcharts.com/8.0.0/modules/annotations.js",
  ];

  initData() async {
    _goes16Series = await ApiHelper.getMagneto16Series();
    _goes17Series = await ApiHelper.getMagneto17Series();
    loading = false;
    notifyListeners();
  }

  String magnetoChartString(height) {

    List<List> _data16 = [];
    List<List> _data17 = [];

    int _arcjetStart16 = 0;
    int _arcjetEnd16 = 0;
    int _arcjetStart17 = 0;
    int _arcjetEnd17 = 0;

    double _arcjetStartVal16 = 0;
    double _arcjetEndVal16 = 0;
    double _arcjetStartVal17 = 0;
    double _arcjetEndVal17 = 0;

    bool _arcjetStartChecker16 = true;
    bool _arcjetStartChecker17 = true;

    for(var item in _goes16Series) {
      _data16.add([item.time.millisecondsSinceEpoch, item.hp]);
      if(item.arcjetFlag) {
        if(_arcjetStartChecker16) {
          _arcjetStart16 = item.time.millisecondsSinceEpoch;
          _arcjetStartVal16 = item.hp;
          _arcjetStartChecker16 = false;
        }
        _arcjetEnd16 = item.time.millisecondsSinceEpoch;
        _arcjetEndVal16 = item.hp;
      }

    }

    for(var item in _goes17Series) {
      _data17.add([item.time.millisecondsSinceEpoch, item.hp]);
      if(item.arcjetFlag) {
        if(_arcjetStartChecker17) {
          _arcjetStart17 = item.time.millisecondsSinceEpoch;
          _arcjetStartVal17 = item.hp;
          _arcjetStartChecker17 = false;
        }
        _arcjetEnd17 = item.time.millisecondsSinceEpoch;
        _arcjetEndVal17 = item.hp;
      }
    }


    return '''
      {
            chart: {
                height: $height,
                type: 'line'
            },
            title: {
              text: ''
            },
            tooltip: {
                valueDecimals: 2,
                xDateFormat: '%Y-%m-%d %H:%M',
                shared: true,
                crosshairs: [true]
            },
            
            xAxis: {
                type: 'datetime',
            },
            yAxis: {
                title: {
                    text: 'NanoTesla (nT)'
                }
            },
            legend: {
                enabled: true,
            },
            annotations: [{
              labelOptions: {
                backgroundColor: '#ffff00',
                borderWidth: 1,
                borderColor: 'green'
              },
              labels: [
                {
                  point: {
                    xAxis: 0,
                    yAxis: 0,
                    x: $_arcjetStart16,
                    y: $_arcjetStartVal16
                  },
                  text: 'Arcjet Start'
                },
                {
                  point: {
                    xAxis: 0,
                    yAxis: 0,
                    x: $_arcjetEnd16,
                    y: $_arcjetEndVal16
                  },
                  text: 'Arcjet End'
                },
                {
                  point: {
                    xAxis: 0,
                    yAxis: 0,
                    x: $_arcjetStart17,
                    y: $_arcjetStartVal17
                  },
                  text: 'Arcjet Start'
                },
                {
                  point: {
                    xAxis: 0,
                    yAxis: 0,
                    x: $_arcjetEnd17,
                    y: $_arcjetEndVal17
                  },
                  text: 'Arcjet End'
                },
                
              ]
            }],
            
            series: [{
                type: 'line',
                name: 'GOES-16 Hp',
                zoneAxis: 'x',
                  zones: [
                    {
                        value: $_arcjetStart16,
                        color: 'red'
                    },
                    {
                        value: $_arcjetEnd16,
                        color: '#ffff00',
                        dashStyle: 'line'
                    },
                    {
                        color: 'red'
                    }
                  ],
                color: 'red',
                lineWidth: 1,
                data: $_data16
            },{
                type: 'line',
                name: 'GOES-17 Hp',
                color: 'blue',
                zoneAxis: 'x',
                  zones: [
                    {
                        value: $_arcjetStart17,
                        color: 'blue'
                    },
                    {
                        value: $_arcjetEnd17,
                        color: '#ffff00',
                        dashStyle: 'line'
                    },
                    {
                        color: 'blue'
                    }
                  ],
                lineWidth: 1,
                data: $_data17
            },]
        }
      ''';
  }

}