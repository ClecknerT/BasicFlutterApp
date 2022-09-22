import 'package:intl/intl.dart';

class XRayModel {
  late DateTime time;
  late String satellite;
  late String energy;
  late double flux;

  XRayModel({
    required this.time,
    required this.satellite,
    required this.energy,
    required this.flux,
  });


  Map toMap(XRayModel xRayData) {
    var data = <String, dynamic>{};
    data["time_tag"] = xRayData.time;
    data["satellite"] = xRayData.satellite;
    data["energy"] = xRayData.energy;
    data["flux"] = xRayData.flux;
    return data;
  }

  XRayModel.fromMap(Map<String, dynamic> mapData) {
    time = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(mapData["time_tag"]);
    satellite = mapData["satellite"].toString();
    energy = mapData["energy"].toString();
    flux = mapData["flux"];
  }
}