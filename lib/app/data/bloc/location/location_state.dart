part of 'location_bloc.dart';

// @immutable
class LocationState extends Equatable {
  const LocationState();
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final List<Location> locations;
  const LocationLoaded({required this.locations});

  LocationLoaded copyWith({List<Location>? locations}) {
      return LocationLoaded(
        locations: locations ?? this.locations,
      );
  }

  @override
  List<Object> get props => [locations];
}

class LocationError extends LocationState {}
