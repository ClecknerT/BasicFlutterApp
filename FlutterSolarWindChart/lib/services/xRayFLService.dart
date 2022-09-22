import 'package:chart/helpers/apiHelper.dart';
import 'package:chart/models/xRayModel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class XrayFLService extends ChangeNotifier {

  List<XRayModel> _goes16Series = [];
  List<XRayModel> _goes17Series = [];

  List<ShowingTooltipIndicators> _xrayIndicators = [];
  List<FlSpot> _data16Long = [];
  List<FlSpot> _data16Short = [];
  List<FlSpot> _data17Long = [];
  List<FlSpot> _data17Short = [];

  bool loading = true;

  initData() async {
    _goes16Series = await ApiHelper.getXRay16Series();
    _goes17Series = await ApiHelper.getXRay17Series();
    loading = false;

    for(var item in _goes16Series) {
      if (item.energy == '0.05-0.4nm') {
        _data16Short.add(FlSpot(item.time.millisecondsSinceEpoch.toDouble(), item.flux));
      } else if (item.energy == '0.1-0.8nm') {
        _data16Long.add(FlSpot(item.time.millisecondsSinceEpoch.toDouble(), item.flux));
      }
    }

    for(var item in _goes17Series) {
      if (item.energy == '0.05-0.4nm') {
        _data17Short.add(FlSpot(item.time.millisecondsSinceEpoch.toDouble(), item.flux));
      } else if (item.energy == '0.1-0.8nm') {
        _data17Long.add(FlSpot(item.time.millisecondsSinceEpoch.toDouble(), item.flux));
      }
    }

    notifyListeners();
  }


  /// xray charts start ******************************************
  LineChartData xrayData() {
    return LineChartData(
      showingTooltipIndicators: _xrayIndicators,
      lineTouchData: _xrayTouchData(),
      gridData: _gridData,
      titlesData: _xrayTitlesData,
      borderData: _borderData,
      lineBarsData: [
        _data16LongChartData,
        _data16ShortChartData,
        _data17LongChartData,
        _data17ShortChartData,
      ],
      // minX: _mh
    );
  }

  LineTouchData _xrayTouchData() {
    return LineTouchData(
        handleBuiltInTouches: true,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(color: Colors.black, strokeWidth: 0.5),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                      radius: 2,
                      color: Colors.black,
                      strokeWidth: 0.5,
                      strokeColor: Colors.black);
                },
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.grey[200],
            tooltipBorder: const BorderSide(color: Colors.black, width: 1),
            tooltipPadding: const EdgeInsets.all(5),
            maxContentWidth: 200,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return [
                LineTooltipItem(
                  'GOES-16 Long: ${touchedBarSpots[0].y.toStringAsExponential(2)}',
                  const TextStyle(
                    color: Colors.red,
                  ),
                ),
                LineTooltipItem(
                  'GOES-16 Short: ${touchedBarSpots[1].y.toStringAsExponential(2)}',
                  const TextStyle(
                    color: Colors.blue,
                  ),
                ),
                LineTooltipItem(
                  'GOES-17 Long: ${touchedBarSpots[2].y.toStringAsExponential(2)}',
                  const TextStyle(
                    color: Colors.orange,
                  ),
                ),
                LineTooltipItem(
                  'GOES-17 Short: ${touchedBarSpots[3].y.toStringAsExponential(2)} \n',
                  const TextStyle(
                    color: Colors.purple,
                  ),
                  children: [
                    TextSpan(
                      text:
                      DateFormat.Md().add_Hm()
                          .format(
                          DateTime
                              .fromMillisecondsSinceEpoch(touchedBarSpots[0].x.toInt())
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              ];
            }),
        touchCallback: _drawIndicators);
  }

  FlTitlesData get _xrayTitlesData => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        interval: 3600 * 1000 * 12,
        getTitlesWidget: _bottomTitleWidgets,
      ),
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
        axisNameSize: 15,
        axisNameWidget: const Text(
          'Watts ∙ (m ^ -2)',
          style: TextStyle(color: Colors.black),
        ),
        sideTitles: SideTitles(
          getTitlesWidget: _xrayLeftTitleWidgets,
          showTitles: true,
          interval: 0.05,
          reservedSize: 30,
        )
    ),
  );

  Widget _xrayLeftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text = value.toStringAsExponential(0).toString();

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  LineChartBarData get _data16LongChartData => LineChartBarData(
      isCurved: false,
      color: Colors.red,
      barWidth: .5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: _data16Long);

  LineChartBarData get _data16ShortChartData => LineChartBarData(
      isCurved: false,
      color: Colors.blue,
      barWidth: .5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: _data16Short);

  LineChartBarData get _data17LongChartData => LineChartBarData(
      isCurved: false,
      color: Colors.orange,
      barWidth: .5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: _data17Long);

  LineChartBarData get _data17ShortChartData => LineChartBarData(
      isCurved: false,
      color: Colors.purple,
      barWidth: .5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: _data17Short);
  /// xray charts end *********************************************


  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontSize: 12,
    );
    Widget text = Text(
        DateFormat.Md().add_H()
            .format(DateTime.fromMillisecondsSinceEpoch(value.toInt())),
        style: style);

    if(value >= _data16Short.last.x || value <= _data16Short.first.x) {
      text = const Text("");
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  FlGridData get _gridData => FlGridData(
    show: true,
    drawVerticalLine: false,
    getDrawingHorizontalLine: (value) {
      return FlLine(
        color: Colors.grey[400],
        strokeWidth: 0.5,
      );
    },
  );

  FlBorderData get _borderData => FlBorderData(
    show: true,
    border: const Border(
      bottom: BorderSide(color: Color(0xff4e4965), width: 1),
      left: BorderSide(color: Color(0xff4e4965), width: 1),
      right: BorderSide(color: Color(0xff4e4965), width: 1),
      top: BorderSide(color: Color(0xff4e4965), width: 1),
    ),
  );

  _drawIndicators(FlTouchEvent event, LineTouchResponse? lineTouch)  {

    if (!event.isInterestedForInteractions ||
        lineTouch == null ||
        lineTouch.lineBarSpots == null) {
      _xrayIndicators = [];
      notifyListeners();
      return;
    }

    final value = lineTouch.lineBarSpots![0].x;

    double _16LongY = 0;
    double _16ShortY = 0;
    double _17LongY = 0;
    double _17ShortY = 0;

    for(var item in _data16Long) {
      if(item.x == value) {
        print(item.x);
        print(item.y);
        _16LongY = item.y;
        break;
      }
    }

    for(var item in _data16Short) {
      if(item.x == value) {
        _16ShortY = item.y;
        break;
      }
    }

    for(var item in _data17Long) {
      if(item.x == value) {
        _17LongY = item.y;
        break;
      }
    }

    for(var item in _data17Short) {
      if(item.x == value) {
        _17ShortY = item.y;
        break;
      }
    }

    _xrayIndicators = [
      ShowingTooltipIndicators([
        LineBarSpot(_data16LongChartData, 0, FlSpot(value, _16LongY)),
        LineBarSpot(_data16ShortChartData, 1, FlSpot(value, _16ShortY)),
        LineBarSpot(_data17LongChartData, 2, FlSpot(value, _17LongY)),
        LineBarSpot(_data17ShortChartData, 3, FlSpot(value, _17ShortY)),
      ]),
    ];
    notifyListeners();
  }

}