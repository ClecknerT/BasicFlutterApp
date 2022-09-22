import 'package:intl/intl.dart';

class MagnetoModel {
  late DateTime time;
  late String satellite;
  late bool arcjetFlag;
  late double he;
  late double hn;
  late double hp;
  late double total;

  MagnetoModel({
    required this.time,
    required this.satellite,
    required this.arcjetFlag,
    required this.he,
    required this.hn,
    required this.hp,
    required this.total,
  });

  MagnetoModel.fromMap(Map<String, dynamic> mapData) {
    time = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(mapData["time_tag"]);
    satellite = mapData["satellite"].toString();
    arcjetFlag = mapData["arcjet_flag"];
    he = mapData["He"];
    hn = mapData["Hn"];
    hp = mapData["Hp"];
    total = mapData["total"];
  }
}