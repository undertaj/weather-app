import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
// import 'package:meta/meta.dart';
import 'package:weather/app/data/repository/location_service.dart';
import '../../models/location.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<LocationLoad>(_onLocationLoad);
    on<LocationInitialize>(_onLocationInitialize);

  }
  void _onLocationInitialize(LocationInitialize event, Emitter<LocationState> emit) async {
    emit(LocationInit());
    emit(LocationInitial());
  }
  void _onLocationLoad(LocationLoad event, Emitter<LocationState> emit) async {
    emit(LocationLoading());

    try {
      final Response response = await LocationService().getLocations(city: event.city);
      List<Location> locations = [];
      for( Map<String, dynamic> item in response.data) {
        Location l = Location.fromJson(item);
        locations.add(l);
      }
      // List<Location> locations = response.data.map((json) => Location.fromJson(json)).toList();
      //How to extract locations from resoonse
      // if(kDebugMode) {
      //   print(locations);
      //   print(locations.length);
      // }
      emit(LocationLoaded( locations: locations));
    }
    catch (e) {
      emit(LocationError());
    }
  }
}
