part of 'location_bloc.dart';

// @immutable
abstract class LocationEvent extends Equatable {
  const LocationEvent();
}

final class LocationLoad extends LocationEvent {
  final String city;

  const LocationLoad(this.city);

  @override
  // TODO: implement props
  List<Object?> get props => [city];
}

