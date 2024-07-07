import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


class WeatherService {
  final String apiKey = 'c221a78b93c5138467cbe505f4c4c02f';
  final Dio _dio = Dio();

  WeatherService();

  Future<Response> getWeatherDetails({required String lat, required String lon}) async {
    _dio.options.baseUrl = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=${apiKey}';
    try {
      final Response response = await _dio.get('');
      if(kDebugMode) {
        print(response.data);
      }
      return response;
    }
    catch (e) {
      print(e);
      throw Exception('Failed to load Weather Data');
    }

  }
}