import 'package:intl/intl.dart';

class SolarWindSeries {
  late DateTime windTime;
  late String windSource;
  double? protonDensity;
  double? protonSpeed;
  double? protonTemp;

  SolarWindSeries({
    required this.windTime, 
    required this.windSource, 
    this.protonDensity, 
    this.protonSpeed,
    this.protonTemp, 
  });


  Map toMap(SolarWindSeries winddata) {
    var data = <String, dynamic>{};
    data["time_tag"] = winddata.windTime;
    data["source"] = winddata.windSource;
    data["proton_density"] = winddata.protonDensity;
    data["proton_speed"] = winddata.protonSpeed;
    data["proton_temperature"] = winddata.protonTemp;
    return data;
  }

  SolarWindSeries.fromMap(Map<String, dynamic> mapData) {
    windTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(mapData["time_tag"]);
    windSource = mapData["source"];
    if(mapData["proton_density"] != null) {
      protonDensity = (mapData["proton_density"] ?? 0) * 1.0;
    }

    if(mapData["proton_speed"] != null) {
      protonSpeed = (mapData["proton_speed"] ?? 0) * 1.0;
    }

    if(mapData["proton_temperature"] != null) {
      protonTemp = (mapData["proton_temperature"] ?? 0) * 1.0;
    }
  }
}