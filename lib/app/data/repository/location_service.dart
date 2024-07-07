import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


class LocationService {
  final String apiKey = 'c221a78b93c5138467cbe505f4c4c02f';
  final Dio _dio = Dio();

  LocationService();

  Future<Response> getLocations({required String city, int limit = 10}) async {
    _dio.options.baseUrl = 'http://api.openweathermap.org/geo/1.0/direct?q=$city&limit=$limit&appid=$apiKey';
    try {
      final Response response = await _dio.get('');
      if(kDebugMode) {
        print(response.data);
      }
      return response;
    }
    catch (e) {
      print(e);
      throw Exception('Failed to load locations');
    }

  }
}