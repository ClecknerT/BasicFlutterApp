import 'dart:convert';

import 'package:chart/models/kIndexModel.dart';
import 'package:chart/models/magnetoModel.dart';
import 'package:chart/models/solarMagModel.dart';
import 'package:chart/models/solarWindModel.dart';
import 'package:chart/models/xRayModel.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class ApiHelper {

  static Future<List<SolarMagSeries>> getMagSeries() async {
    List<SolarMagSeries> magSeries = [];

    final result = await _getHttpRequest('https://services.swpc.noaa.gov/json/rtsw/rtsw_mag_1m.json');

    for(var item in result) {
      magSeries.add(SolarMagSeries.fromMap(item));
    }

    return magSeries;
  }

  static Future<List<SolarWindSeries>> getWindSeries() async {
    List<SolarWindSeries> windSeries = [];

    final result = await _getHttpRequest('https://services.swpc.noaa.gov/json/rtsw/rtsw_wind_1m.json');

    for(var item in result) {
      windSeries.add(SolarWindSeries.fromMap(item));
    }

    return windSeries;
  }

  static Future<List<XRayModel>> getXRay16Series() async {
    List<XRayModel> series = [];

    final result = await _getRequest('https://services.swpc.noaa.gov/json/goes/primary/xrays-3-day.json');

    for(var item in result) {
      series.add(XRayModel.fromMap(item));
    }

    return series;
  }

  static Future<List<XRayModel>> getXRay17Series() async {
    List<XRayModel> series = [];

    final result = await _getRequest('https://services.swpc.noaa.gov/json/goes/secondary/xrays-3-day.json');

    for(var item in result) {
      series.add(XRayModel.fromMap(item));
    }

    return series;
  }

  static Future<List<MagnetoModel>> getMagneto16Series() async {
    List<MagnetoModel> series = [];

    final result = await _getRequest('https://services.swpc.noaa.gov/json/goes/primary/magnetometers-3-day.json');

    for(var item in result) {
      series.add(MagnetoModel.fromMap(item));
    }

    return series;
  }

  static Future<List<MagnetoModel>> getMagneto17Series() async {
    List<MagnetoModel> series = [];

    final result = await _getRequest('https://services.swpc.noaa.gov/json/goes/secondary/magnetometers-3-day.json');

    for(var item in result) {
      series.add(MagnetoModel.fromMap(item));
    }

    return series;
  }

  static Future<List<KIndexModel>> getKpSeries() async {
    List<KIndexModel> series = [];

    final result = await _getRequest('https://services.swpc.noaa.gov/products/noaa-planetary-k-index.json');

    int i = 0;
    for(var item in result) {
      if(i > 0) {
        series.add(KIndexModel.fromList(item));
      }
      i++;
    }

    return series;
  }

  static Future<List> _getRequest(String url) async {
    try {
      var dio = Dio();
      var response = await dio.get(url);
      return response.data;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<List> _getHttpRequest(String url) async {
    try {
      var client = http.Client();
      var response = await client.get(Uri.parse(url));
      return json.decode(response.body);
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}