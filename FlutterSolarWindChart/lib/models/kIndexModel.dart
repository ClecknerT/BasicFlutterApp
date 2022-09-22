import 'package:intl/intl.dart';

class KIndexModel {
  late DateTime time;
  late int kp;
  late double kpFraction;
  late int aRunning;
  late int stationCount;

  KIndexModel({
    required this.time,
    required this.kp,
    required this.kpFraction,
    required this.aRunning,
    required this.stationCount,
  });

  KIndexModel.fromList(List listData) {
    time = DateFormat("yyyy-MM-dd HH:mm:ss").parse(listData[0].replaceAll('.000', ''));
    kp = int.parse(listData[1]);
    kpFraction = double.parse(listData[2]);
    aRunning = int.parse(listData[3]);
    stationCount = int.parse(listData[4]);
  }
}