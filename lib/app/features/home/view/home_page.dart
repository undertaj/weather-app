import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/location.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

import '../../../data/bloc/location/location_bloc.dart';
import '../../../utils/color.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final LocationBloc bloc;
  late String? lastSearched, lat, lon;
  late SharedPreferences prefs;

  @override
  void initState() {
    lastSearched = null;
    lat = null; lon = null;
    init();
    getLastSearched();
    bloc = LocationBloc();
    // TODO: implement initState
    super.initState();
  }

  void init() async {
    prefs = await SharedPreferences.getInstance();
  }


  void getLastSearched() async {
    prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('last-searched-city')) {
      String? ls = lastSearched;
      lastSearched = prefs.getString('last-searched-city');
      lat = prefs.getString('last-searched-lat');
      lon = prefs.getString('last-searched-lon');
      if(kDebugMode) {
        print('LAST SEARCHED: $lastSearched');
        if(ls == null) {
          bloc.add(LocationInitialize());
        }
      }
    }
    else {
      lastSearched = null;
      lat = null;
      lon = null;
    }
  }

  void setLastSearched(String city, String lat, String lon) async {
    if (kDebugMode) {
      print('SETTING TO: $city');
    }
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('last-searched-city', city);
    await prefs.setString('last-searched-lat', lat);
    await prefs.setString('last-searched-lon', lon);
    if (kDebugMode) {
      print('SETTING TO: ${prefs.getString('last-searched-city')}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff252144),
        appBar: AppBar(
          backgroundColor: Color(0xff252144),
          title: const Text(
              'Weather App', style: TextStyle(color: AppColor.accentColor)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xff3C366B),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xff252144),
                    offset: const Offset(0, 10),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  // BlocProvider.of<LocationBloc>(context).add(LocationLoad(value));
                  if(value == '') {
                    // bloc.emit(LocationInitial());
                    bloc.add(const LocationInitialize());
                  }
                  else {
                    bloc.add(LocationLoad(value));
                  }
                  // context.read<LocationBloc>().add(LocationLoad(value));
                  // print(value);
                },
                style: const TextStyle(color: Color(0xff928794)),
                decoration: const InputDecoration(
                  hintText: 'Search for a city',
                  hintStyle: TextStyle(color: Color(0xff928794)),
                  focusColor: Color(0xff928794),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Color(0xff928794),
                  ),
                ),
              ),
            ),

            BlocBuilder<LocationBloc, LocationState>(
              bloc: bloc,
              builder: (context, state) {

                getLastSearched();
                if(kDebugMode) {
                  print('BUILT');
                  print(lastSearched);
                }
                return InkWell(
                  onTap: () {
                    if(lastSearched != null) {
                      context.push('/details',
                          extra: {
                            'lat': lat ?? '0',
                            'lon': lon ?? '0',
                          }
                      );
                    }
                  },
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white70
                    ),
                    padding: EdgeInsets.all(10),
                    child: FittedBox(
                      child: Text(
                        lastSearched ?? 'No city searched yet',
                        style: TextStyle(
                          color: AppColor.primaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            BlocBuilder<LocationBloc, LocationState>(
              bloc: bloc,
                builder: (context, state) {
                  if (state is LocationLoaded) {
                    List<Location> list = state.locations;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.separated(
                          itemCount: list.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 20);
                          },
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                setLastSearched(list[index].name!, list[index].lat.toString(), list[index].lon.toString());
                                context.push('/details',
                                    extra: {
                                      'lat': list[index].lat.toString(),
                                      'lon': list[index].lon.toString()
                                    }
                                );
                              },
                              child: Container(
                                height: 40,
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: AppColor.secondaryColor.withOpacity(0.3),
                                ),
                                child: Center(
                                  child: Text(
                                    '${list[index].name ?? ''}, ${list[index]
                                        .state ?? ''}, ${list[index]
                                        .country ?? ''}',
                                    style: const TextStyle(
                                        color: AppColor.accentColor
                                    ),),
                                ),
                              )

                            );
                          },
                        ),
                      ),
                    );
                  }
                  else if (state is LocationLoading) {
                    return const Expanded(
                      child: Center (
                        child: CircularProgressIndicator(
                          color: AppColor.accentColor,
                        ),
                      ),
                    );
                  }
                  else if (state is LocationError) {
                    return const Expanded(
                      child: Center (
                        child: Text(
                          'Error while loading locations !!',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                }

            ),
          ],
        ),
      ),
    );
  }
}
