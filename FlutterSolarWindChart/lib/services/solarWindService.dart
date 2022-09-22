import 'package:chart/helpers/apiHelper.dart';
import 'package:chart/models/solarMagModel.dart';
import 'package:chart/models/solarWindModel.dart';
import 'package:flutter/material.dart';

class SolarWindService extends ChangeNotifier {

  List<SolarMagSeries> _magSeries = [];
  List<SolarWindSeries> _windSeries = [];
  bool loading = true;
  static final List<String> scripts = [
    "https://code.highcharts.com/8.0.0/highcharts.js",
    "https://code.highcharts.com/8.0.0/modules/accessibility.js"
  ];

  initData() async {
    _magSeries = await ApiHelper.getMagSeries();
    _windSeries = await ApiHelper.getWindSeries();
    loading = false;
    notifyListeners();
  }

  String btBzMagChartString() {

    List<List> _dataBt = [];
    List<List> _dataBz = [];

    for(var item in _magSeries) {
      _dataBt.add([item.particalTime.millisecondsSinceEpoch, item.bt]);
      _dataBz.add([item.particalTime.millisecondsSinceEpoch, item.bz]);
    }


    return '''
      {
            chart: {
                height: 250,
                type: 'line'
            },
            title: {
              text: ''
            },
            tooltip: {
                valueDecimals: 2,
                xDateFormat: '%Y-%m-%d %H:%M'
            },
            
            xAxis: {
                type: 'datetime',
            },
            yAxis: {
                title: {
                    text: 'Bt Bz GSM (nT)'
                }
            },
            legend: {
                enabled: true,
                layout: 'vertical',
                align: 'left',
                verticalAlign: 'middle'
            },
            series: [{
                type: 'line',
                name: 'Bz',
                color: 'red',
                lineWidth: 0.5,

                data: $_dataBz
            }, {
                type: 'line',
                name: 'Bt',
                color: 'black',
                lineWidth: 0.5,

                data: $_dataBt
            }]
        }
      ''';
  }

  String phiChartString() {

    List<List> _dataPhi = [];

    for(var item in _magSeries) {
      _dataPhi.add([item.particalTime.millisecondsSinceEpoch, item.phi]);
    }


    return '''
      {
            chart: {
                
                height: 250,
                type: 'line'
            },
            title: {
              text: ''
            },
            tooltip: {
                valueDecimals: 2,
                xDateFormat: '%Y-%m-%d %H:%M'
            },
            
            xAxis: {
                type: 'datetime',
            },
            yAxis: {
                title: {
                    text: 'Phi GSM (deg)'
                }
            },
            legend: {
                enabled: true,
                layout: 'vertical',
                align: 'left',
                verticalAlign: 'middle'
            },
            series: [{
                type: 'line',
                name: 'Phi',
                color: 'blue',
                lineWidth: 0.5,

                data: $_dataPhi
            }]
        }
      ''';
  }

  String densityChartString() {

    List<List> _data = [];

    for(var item in _windSeries) {
      _data.add([item.windTime.millisecondsSinceEpoch, item.protonDensity]);
    }


    return '''
      {
            chart: {
                
                height: 250,
                type: 'line'
            },
            title: {
              text: ''
            },
            tooltip: {
                valueDecimals: 2,
                xDateFormat: '%Y-%m-%d %H:%M'
            },
            
            xAxis: {
                type: 'datetime',
            },
            yAxis: {
                title: {
                    text: 'Density (1/cm³)'
                }
            },
            legend: {
                enabled: true,
                layout: 'vertical',
                align: 'left',
                verticalAlign: 'middle'
            },
            series: [{
                type: 'line',
                name: 'Density',
                color: 'orange',
                lineWidth: 0.5,

                data: $_data
            }]
        }
      ''';
  }

  String speedChartString() {

    List<List> _data = [];

    for(var item in _windSeries) {
      _data.add([item.windTime.millisecondsSinceEpoch, item.protonSpeed]);
    }


    return '''
      {
            chart: {
                
                height: 250,
                type: 'line'
            },
            title: {
              text: ''
            },
            tooltip: {
                valueDecimals: 2,
                xDateFormat: '%Y-%m-%d %H:%M'
            },
            
            xAxis: {
                type: 'datetime',
            },
            yAxis: {
                title: {
                    text: 'Speed (km/s)'
                }
            },
            legend: {
                enabled: true,
                layout: 'vertical',
                align: 'left',
                verticalAlign: 'middle'
            },
            series: [{
                type: 'line',
                name: 'Speed',
                color: 'purple',
                lineWidth: 0.5,

                data: $_data
            }]
        }
      ''';
  }
  
  String tempChartString() {

    List<List> _data = [];

    for(var item in _windSeries) {
      _data.add([item.windTime.millisecondsSinceEpoch, item.protonTemp]);
    }


    return '''
      {
            chart: {
                height: 250,
                type: 'line'
            },
            title: {
              text: ''
            },
            tooltip: {
                valueDecimals: 2,
                xDateFormat: '%Y-%m-%d %H:%M'
            },
            
            xAxis: {
                type: 'datetime',
            },
            yAxis: {
                title: {
                    text: 'Temp (⁰K)'
                }
            },
            legend: {
                enabled: true,
                layout: 'vertical',
                align: 'left',
                verticalAlign: 'middle'
            },
            series: [{
                type: 'line',
                name: 'Temp',
                lineWidth: 0.5,
                color: 'green',
                data: $_data
            }]
        }
      ''';
  }

}