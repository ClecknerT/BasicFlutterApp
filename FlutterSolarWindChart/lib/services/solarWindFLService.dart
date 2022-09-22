import 'package:chart/helpers/apiHelper.dart';
import 'package:chart/models/solarMagModel.dart';
import 'package:chart/models/solarWindModel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SolarWindFlService extends ChangeNotifier {

  List<SolarMagSeries> _magSeries = [];
  List<SolarWindSeries> _windSeries = [];

  List<ShowingTooltipIndicators> _windIndicators = [];
  List<FlSpot> _speedChartsData = [];

  List<ShowingTooltipIndicators> _tempIndicators = [];
  List<FlSpot> _tempChartsData = [];

  List<ShowingTooltipIndicators> _densityIndicators = [];
  List<FlSpot> _densityChartsData = [];

  List<ShowingTooltipIndicators> _phiIndicators = [];
  List<FlSpot> _phiChartsData = [];

  List<ShowingTooltipIndicators> _btzIndicators = [];
  List<FlSpot> _btChartsData = [];
  List<FlSpot> _bzChartsData = [];
  bool loading = true;

  String magSatellite = "";
  String windSatellite = "";

  initData() async {
    _magSeries = await ApiHelper.getMagSeries();
    _windSeries = await ApiHelper.getWindSeries();

    for(var item in _windSeries) {
      if(item.protonSpeed != null) {
        _speedChartsData.add(FlSpot(
          item.windTime.millisecondsSinceEpoch.toDouble(),
          item.protonSpeed??0,
        ));
      }

      if(item.protonTemp != null) {
        _tempChartsData.add(FlSpot(
          item.windTime.millisecondsSinceEpoch.toDouble(),
          item.protonTemp??0,
        ));
      }

      if(item.protonDensity != null) {
        _densityChartsData.add(FlSpot(
          item.windTime.millisecondsSinceEpoch.toDouble(),
          item.protonDensity??0,
        ));
      }
    }

    for(var item in _magSeries) {
      _phiChartsData.add(FlSpot(
        item.particalTime.millisecondsSinceEpoch.toDouble(),
        item.phi,
      ));

      _btChartsData.add(FlSpot(
        item.particalTime.millisecondsSinceEpoch.toDouble(),
        item.bt,
      ));

      _bzChartsData.add(FlSpot(
        item.particalTime.millisecondsSinceEpoch.toDouble(),
        item.bz,
      ));
    }

    loading = false;
    notifyListeners();
  }

  /// btz charts start ******************************************
  LineChartData btzData() {
    return LineChartData(
      showingTooltipIndicators: _btzIndicators,
      lineTouchData: _btzTouchData(),
      gridData: _gridData,
      titlesData: _btzTitlesData,
      borderData: _borderData,
      lineBarsData: [
        _btLineChartData,
        _bzLineChartData,
      ],
      // minX: _mh
    );
  }

  LineTouchData _btzTouchData() {
    return LineTouchData(
        handleBuiltInTouches: true,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(color: Colors.black, strokeWidth: 1),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                      radius: 2,
                      color: Colors.black,
                      strokeWidth: 1,
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
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              TextAlign textAlign = TextAlign.center;
              return [
                LineTooltipItem(
                'Bt: ${touchedBarSpots[0].y.toInt()}',
                const TextStyle(
                  color: Colors.black,
                ),
                textAlign: textAlign,
              ),
                LineTooltipItem(
                'Bz: ${touchedBarSpots[1].y.toInt()} \n',
                const TextStyle(
                  color: Colors.red,
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
                textAlign: textAlign,
              )
              ];
            }),
        touchCallback: _drawIndicators);
  }

  FlTitlesData get _btzTitlesData => FlTitlesData(
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
        axisNameWidget: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Bt',
                style: TextStyle(
                  color: Colors.black
                )
              ),
              TextSpan(
                  text: ' Bz GSM(nT)',
                  style: TextStyle(
                      color: Colors.red
                  )
              ),
            ]
          ),
        ),
        sideTitles: SideTitles(
          getTitlesWidget: _btzLeftTitleWidgets,
          showTitles: true,
          interval: 30,
          reservedSize: 30,
        )
    ),
  );

  Widget _btzLeftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text = value.toInt().toString();

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  LineChartBarData get _btLineChartData => LineChartBarData(
      isCurved: false,
      color: Colors.black,
      barWidth: .5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: _btChartsData);

  LineChartBarData get _bzLineChartData => LineChartBarData(
      isCurved: false,
      color: Colors.red,
      barWidth: .5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: _bzChartsData);
  /// btz charts end *********************************************

  /// phi charts start ******************************************
  LineChartData phiData() {
    return LineChartData(
      showingTooltipIndicators: _phiIndicators,
      lineTouchData: _phiTouchData(),
      gridData: _gridData,
      titlesData: _phiTitlesData,
      borderData: _borderData,
      lineBarsData: [
        _phiLineChartData
      ],
      // minX: _mh
    );
  }

  LineTouchData _phiTouchData() {
    return LineTouchData(
        handleBuiltInTouches: true,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(color: Colors.blue, strokeWidth: 1),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                      radius: 2,
                      color: Colors.blue,
                      strokeWidth: 1,
                      strokeColor: Colors.blue);
                },
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.grey[200],
            tooltipBorder: const BorderSide(color: Colors.black, width: 1),
            tooltipPadding: const EdgeInsets.all(5),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                if (flSpot.x == 0 || flSpot.x == 6) {
                  return null;
                }

                TextAlign textAlign = TextAlign.center;

                return LineTooltipItem(
                  '${flSpot.y.toInt()} deg\n',
                  const TextStyle(
                    color: Colors.blue,
                  ),
                  children: [
                    TextSpan(
                      text: DateFormat.Md().add_Hm().format(DateTime.fromMillisecondsSinceEpoch(flSpot.x.toInt())),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                  textAlign: textAlign,
                );
              }).toList();
            }),
        touchCallback: _drawIndicators);
  }

  FlTitlesData get _phiTitlesData => FlTitlesData(
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
          'Phi GSM(deg)',
          style: TextStyle(color: Colors.blue),
        ),
        sideTitles: SideTitles(
          getTitlesWidget: _phiLeftTitleWidgets,
          showTitles: true,
          interval: 200,
          reservedSize: 30,
        )
    ),
  );

  Widget _phiLeftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text = value.toInt().toString();

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  LineChartBarData get _phiLineChartData => LineChartBarData(
      isCurved: false,
      color: Colors.blue,
      barWidth: .5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: _phiChartsData);
  /// phi charts end *********************************************

  /// density charts start ******************************************
  LineChartData densityData() {
    return LineChartData(
      showingTooltipIndicators: _densityIndicators,
      lineTouchData: _densityTouchData(),
      gridData: _gridData,
      titlesData: _densityTitlesData,
      borderData: _borderData,
      lineBarsData: [
        _densityLineChartData
      ],
      // minX: _mh
    );
  }

  LineTouchData _densityTouchData() {
    return LineTouchData(
        handleBuiltInTouches: true,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(color: Colors.orange, strokeWidth: 1),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                      radius: 2,
                      color: Colors.orange,
                      strokeWidth: 1,
                      strokeColor: Colors.orange);
                },
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.grey[200],
            tooltipBorder: const BorderSide(color: Colors.black, width: 1),
            tooltipPadding: const EdgeInsets.all(5),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                if (flSpot.x == 0 || flSpot.x == 6) {
                  return null;
                }

                TextAlign textAlign = TextAlign.center;

                return LineTooltipItem(
                  '${flSpot.y.toStringAsFixed(2)} 1/cm³\n',
                  const TextStyle(
                    color: Colors.orange,
                  ),
                  children: [
                    TextSpan(
                      text: DateFormat.Md().add_Hm().format(DateTime.fromMillisecondsSinceEpoch(flSpot.x.toInt())),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                  textAlign: textAlign,
                );
              }).toList();
            }),
        touchCallback: _drawIndicators);
  }

  FlTitlesData get _densityTitlesData => FlTitlesData(
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
          'Density(1/cm³)',
          style: TextStyle(color: Colors.orange),
        ),
        sideTitles: SideTitles(
          getTitlesWidget: _densityLeftTitleWidgets,
          showTitles: true,
          interval: 100,
          reservedSize: 30,
        )
    ),
  );

  Widget _densityLeftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text = value.toInt().toString();

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  LineChartBarData get _densityLineChartData => LineChartBarData(
      isCurved: false,
      color: Colors.orange,
      barWidth: .5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: _densityChartsData);
  /// density charts end *********************************************

  /// speed charts start ******************************************
  LineChartData speedData() {
    return LineChartData(
      showingTooltipIndicators: _windIndicators,
      lineTouchData: _speedTouchData(),
      gridData: _gridData,
      titlesData: _speedTitlesData,
      borderData: _borderData,
      lineBarsData: [
        _speedLineChartData
      ],
      // minX: _mh
    );
  }

  LineTouchData _speedTouchData() {
    return LineTouchData(
        handleBuiltInTouches: true,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(color: Colors.purple, strokeWidth: 1),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                      radius: 2,
                      color: Colors.purple,
                      strokeWidth: 1,
                      strokeColor: Colors.purple);
                },
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.grey[200],
            tooltipPadding: const EdgeInsets.all(5),
            tooltipBorder: const BorderSide(color: Colors.black, width: 1),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                if (flSpot.x == 0 || flSpot.x == 6) {
                  return null;
                }

                TextAlign textAlign = TextAlign.center;

                return LineTooltipItem(
                  '${flSpot.y.toString()} km/s \n',
                  const TextStyle(
                    color: Colors.purple,
                  ),
                  children: [
                    TextSpan(
                      text: DateFormat.Md().add_Hm().format(DateTime.fromMillisecondsSinceEpoch(flSpot.x.toInt())),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                  textAlign: textAlign,
                );
              }).toList();
            }),
        touchCallback: _drawIndicators);
  }

  FlTitlesData get _speedTitlesData => FlTitlesData(
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
        'Speed(km/s)',
        style: TextStyle(color: Colors.purple),
      ),
      sideTitles: SideTitles(
        getTitlesWidget: _speedLeftTitleWidgets,
        showTitles: true,
        interval: 300,
        reservedSize: 30,
      )
    ),
  );

  Widget _speedLeftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text = value.toInt().toString();
    return Text(text, style: style, textAlign: TextAlign.center);
  }

  LineChartBarData get _speedLineChartData => LineChartBarData(
      isCurved: false,
      color: Colors.purple,
      barWidth: .5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: _speedChartsData);
  /// speed charts end *********************************************

  /// temp charts start ******************************************
  LineChartData tempData() {
    return LineChartData(
      showingTooltipIndicators: _tempIndicators,
      lineTouchData: _tempTouchData(),
      gridData: _gridData,
      titlesData: _tempTitlesData,
      borderData: _borderData,
      lineBarsData: [
        _tempLineChartData
      ],
      // minX: _mh
    );
  }

  LineTouchData _tempTouchData() {
    return LineTouchData(
        handleBuiltInTouches: true,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(color: Colors.green, strokeWidth: 1),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                      radius: 2,
                      color: Colors.green,
                      strokeWidth: 1,
                      strokeColor: Colors.green);
                },
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.grey[200],
            tooltipBorder: const BorderSide(color: Colors.black, width: 1),
            tooltipPadding: const EdgeInsets.all(5),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                if (flSpot.x == 0 || flSpot.x == 6) {
                  return null;
                }

                TextAlign textAlign = TextAlign.center;

                return LineTooltipItem(
                  '${flSpot.y.toStringAsExponential(2)} ⁰K \n',
                  const TextStyle(
                    color: Colors.green,
                  ),
                  children: [
                    TextSpan(
                      text: DateFormat.Md().add_Hm().format(DateTime.fromMillisecondsSinceEpoch(flSpot.x.toInt())),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                  textAlign: textAlign,
                );
              }).toList();
            }),
        touchCallback: _drawIndicators);
  }

  FlTitlesData get _tempTitlesData => FlTitlesData(
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
          'Temperature(⁰K)',
          style: TextStyle(color: Colors.green),
        ),
        sideTitles: SideTitles(
          getTitlesWidget: _tempLeftTitleWidgets,
          showTitles: true,
          interval: 2500000,
          reservedSize: 30,
        )
    ),
  );

  Widget _tempLeftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text = value.toStringAsExponential(0).toString();

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  LineChartBarData get _tempLineChartData => LineChartBarData(
      isCurved: false,
      color: Colors.green,
      barWidth: .5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: _tempChartsData);
  /// temp charts end *********************************************


  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontSize: 12,
    );
    Widget text = Text(
        DateFormat.Hm()
            .format(DateTime.fromMillisecondsSinceEpoch(value.toInt())),
        style: style);

    if(value >= _speedChartsData.first.x || value == _speedChartsData.last.x) {
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
      _windIndicators = [];
      _tempIndicators = [];
      _densityIndicators = [];
      _phiIndicators = [];
      _btzIndicators = [];
      magSatellite = "";
      windSatellite = "";
      notifyListeners();
      return;
    }
    final value = lineTouch.lineBarSpots![0].x;

    // _windIndicators = [ShowingTooltipIndicators(lineTouch.lineBarSpots!)];

    double _tempY = 0;
    double _speedY = 0;
    double _densityY = 0;
    double _phiY = 0;
    double _btY = 0;
    double _bzY = 0;

    for(var item in _windSeries) {
      if(item.windTime.millisecondsSinceEpoch == value.toInt()) {
        _tempY = item.protonTemp??0;
        _speedY = item.protonSpeed??0;
        _densityY = item.protonDensity??0;
        windSatellite = item.windSource;
        break;
      }
    }

    for(var item in _magSeries) {
      if(item.particalTime.millisecondsSinceEpoch == value.toInt()) {
        _phiY = item.phi;
        _btY = item.bt;
        _bzY = item.bz;
        magSatellite = item.particalSource;
        break;
      }
    }

    _windIndicators = [ShowingTooltipIndicators([
      LineBarSpot(_speedLineChartData, 0, FlSpot(value, _speedY))
    ])];
    _tempIndicators = [ShowingTooltipIndicators([
      LineBarSpot(_tempLineChartData, 0, FlSpot(value, _tempY))
    ])];
    _densityIndicators = [ShowingTooltipIndicators([
      LineBarSpot(_densityLineChartData, 0, FlSpot(value, _densityY))
    ])];
    _phiIndicators = [ShowingTooltipIndicators([
      LineBarSpot(_phiLineChartData, 0, FlSpot(value, _phiY))
    ])];
    _btzIndicators = [
      ShowingTooltipIndicators([
        LineBarSpot(_btLineChartData, 0, FlSpot(value, _btY)), LineBarSpot(_bzLineChartData, 1, FlSpot(value, _bzY))
      ]),
    ];
    notifyListeners();
  }

}