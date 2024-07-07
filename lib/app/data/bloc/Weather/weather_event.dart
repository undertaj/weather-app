part of 'Weather_bloc.dart';

// @immutable
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class WeatherLoad extends WeatherEvent {
  final String lat;
  final String lon;

  const WeatherLoad({required this.lat, required this.lon});

  @override
  // TODO: implement props
  List<Object?> get props => [lat,lon];
}

