part of 'Weather_bloc.dart';

// @immutable
class WeatherState extends Equatable {
  const WeatherState();
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  const WeatherLoaded({required this.weather});

  WeatherLoaded copyWith({Weather? weather}) {
    return WeatherLoaded(
      weather: weather ?? this.weather,
    );
  }

  @override
  List<Object> get props => [weather];
}

class WeatherError extends WeatherState {}
