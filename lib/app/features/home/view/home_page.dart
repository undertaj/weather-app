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
  late final String? lastSearched;
  late final SharedPreferences prefs;

  @override
  void initState() {
    lastSearched = null;
    getLastSearched();
    bloc = LocationBloc();
    // TODO: implement initState
    super.initState();
  }



  void getLastSearched() async {
    prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('last-searched-city')) {
      lastSearched = prefs.getString('last-searched-city');
      if(kDebugMode) {
        print('LAST SEARCHED: $lastSearched');
      }
    }
    else {
      lastSearched = null;
    }
  }

  void setLastSearched(String city) async {
    if (kDebugMode) {
      print('SETTING TO: $city');
    }
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('last-searched-city', city);
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
                  bloc.add(LocationLoad(value));
                  // context.read<LocationBloc>().add(LocationLoad(value));
                  print(value);
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
                return Container(
                  height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white70
                  ),
                  padding: EdgeInsets.all(7),
                  child: FittedBox(
                    child: Text(
                      lastSearched ?? 'No city searched yet',
                      style: TextStyle(
                        color: AppColor.primaryColor,
                        fontSize: 14,
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
                                setLastSearched(list[index].name!);
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
                              // child: Stack(
                              //   children: [
                              //     SvgPicture.asset(
                              //       'assets/images/list_item.svg',
                              //       width: double.infinity,
                              //       height: 180,
                              //     ),
                              //     Positioned(
                              //       top: 70,
                              //       left: 20,
                              //       child: Text(
                              //         '${list[index].name ?? ''}, ${list[index]
                              //             .state ?? ''}, ${list[index]
                              //             .country ?? ''}',
                              //         style: const TextStyle(
                              //             color: AppColor.accentColor
                              //         ),),
                              //     )
                              //   ],
                              // ),
                            );
                            // title: Text('City $index'),
                            // onTap: () {
                            //   // Navigator.of(context).pushNamed('/details');
                            //   context.go('/details', extra: {'city': 'City $index'});
                            // },
                            // );
                          },
                        ),
                      ),
                    );
                  }
                  else if (state is LocationLoading) {
                    return const Center (
                      child: CircularProgressIndicator(
                        color: AppColor.accentColor,
                      ),
                    );
                  }
                  else if (state is LocationError) {
                    return const Center (
                      child: Text(
                        'Error while loading locations !!',
                        style: TextStyle(
                          color: AppColor.accentColor,
                          fontSize: 16,
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

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      math.pi * 2,
      math.pi * 2,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}