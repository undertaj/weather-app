import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../models/weather.dart';
import '../../repository/weather_service.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {

  WeatherBloc() : super(WeatherInitial()) {
    on<WeatherLoad>(_onWeatherLoad);
  }

  void _onWeatherLoad(WeatherLoad event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());

    try {
      final Response response = await WeatherService().getWeatherDetails(lat: event.lat, lon: event.lon);
      Weather weather = Weather.fromJson(response.data);

      if(kDebugMode) {
        print(weather);
      }
      emit(WeatherLoaded(weather: weather));
    }
    catch (e) {
      emit(WeatherError());
    }
  }
}
