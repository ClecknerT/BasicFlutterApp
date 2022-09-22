import 'package:chart/helpers/apiHelper.dart';
import 'package:chart/models/xRayModel.dart';
import 'package:flutter/material.dart';

class XrayService extends ChangeNotifier {

  List<XRayModel> _goes16Series = [];
  List<XRayModel> _goes17Series = [];
  bool loading = true;
  static final List<String> scripts = [
    "https://code.highcharts.com/8.0.0/highcharts.js",
    "https://code.highcharts.com/modules/accessibility.js"
  ];

  initData() async {
    _goes16Series = await ApiHelper.getXRay16Series();
    _goes17Series = await ApiHelper.getXRay17Series();
    loading = false;
    notifyListeners();
  }

  String xRayChartString(height) {

    List<List> _data16Long = [];
    List<List> _data16Short = [];
    List<List> _data17Long = [];
    List<List> _data17Short = [];

    for(var item in _goes16Series) {
      if (item.energy == '0.05-0.4nm') {
        _data16Short.add([item.time.millisecondsSinceEpoch, item.flux]);
      } else if (item.energy == '0.1-0.8nm') {
        _data16Long.add([item.time.millisecondsSinceEpoch, item.flux]);
      }
    }

    for(var item in _goes17Series) {
      if (item.energy == '0.05-0.4nm') {
        _data17Short.add([item.time.millisecondsSinceEpoch, item.flux]);
      } else if (item.energy == '0.1-0.8nm') {
        _data17Long.add([item.time.millisecondsSinceEpoch, item.flux]);
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
                valueDecimals: 9,
                xDateFormat: '%Y-%m-%d %H:%M',
                pointFormatter: function(){
                  var point = this,
                  series = point.series;
                  return '<span style="color:' + point.color + '">●</span> ' + series.name + ': <b>' + point.y.toExponential(2) + '</b><br/>';
                },
                shared: true,
                crosshairs: [true]
            },
            
            xAxis: {
                type: 'datetime',
            },
            yAxis: {
                title: {
                    text: 'Watts ∙ m^-2'
                },
                labels: {
                    formatter: function () {
                      return this.value.toExponential(2);
                    }
                },
            },
            legend: {
                enabled: true,
            },
            series: [{
                type: 'line',
                name: 'GOES-16 Long',
                color: 'red',
                lineWidth: 0.5,
                data: $_data16Long
            },{
                type: 'line',
                name: 'GOES-16 Short',
                color: 'blue',
                lineWidth: 0.5,
                data: $_data16Short
            },{
                type: 'line',
                name: 'GOES-17 Long',
                color: 'orange',
                lineWidth: 0.5,
                data: $_data17Long
            },{
                type: 'line',
                name: 'GOES-17 Short',
                color: 'purple',
                lineWidth: 0.5,
                data: $_data17Short
            },]
        }
      ''';
  }

}