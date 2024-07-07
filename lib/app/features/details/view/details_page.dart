import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import '../../../data/bloc/weather/Weather_bloc.dart';
import '../../../data/models/weather.dart';
import '../../../utils/color.dart';

class DetailsPage extends StatefulWidget {
  final String lat,lon;
  const DetailsPage({super.key, required this.lat, required this.lon});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late String? city;

  @override
  void initState() {
    // TODO: implement initState
    city = null;
    context.read<WeatherBloc>().add(WeatherLoad(lat: widget.lat, lon: widget.lon));
    super.initState();
  }

  String getDirection(int degree) {
    List<String> dir = ["N","NNE","NE","ENE","E","ESE","SE","SSE","S","SSW","SW","WSW","W","WNW","NW","NNW","N"];
    int x = ((degree%360)/22.5).round()+1;
    return dir[x-1];

  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) {
        context.pop();
      },
      child: Scaffold(
        backgroundColor: Color(0xff252144),
        appBar: AppBar(
          title: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if(state is WeatherLoaded) {
                return Text('${state.weather.name}');
              }
              return const Text('');
            },
          ),
          foregroundColor: AppColor.secondaryColor,
          surfaceTintColor: AppColor.secondaryColor,
          titleTextStyle: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            color: AppColor.accentColor
          ),
          toolbarHeight: 50,
          backgroundColor: const Color(0xff252144),
          centerTitle: true,
        ),
        body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if(state is WeatherLoaded) {
            Weather weather = state.weather;
            city = weather.name!;
            return Padding(
              padding: const EdgeInsets.all(13.0),
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<WeatherBloc>().add(WeatherLoad(lat: widget.lat, lon: widget.lon));
                },
                child: ListView(

                  children: [
                    // SizedBox(height: 50,),
                    Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.4,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            // color: AppColor.secondaryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 125,
                          width: 159,
                          child: Stack(
                            children: [
                              Text(
                                '${weather.main?.temp?.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Positioned(
                                top: 65,
                                child: Row(
                                  children: [
                                    Text(
                                      '${weather.weather[0].main}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    Text('${weather.main?.tempMax?.toStringAsFixed(0)}°/ ${weather.main?.tempMin?.toStringAsFixed(0)}°',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Positioned(
                                left: 51,
                                  top: 7,
                                  child: Text(
                                    '°C',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                              ),
                              Positioned(
                                  right: 1,
                                  top: 7,
                                  child: Image.asset(
                                      'assets/icons/${weather.weather[0].icon}.png',
                                    height: 50,
                                    width: 50,
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 95,
                              width: (MediaQuery.of(context).size.width-36)/2,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColor.secondaryColor.withOpacity(0.3),
                              ),
                              child: Column(
                                children: [
                                  Text('${weather.wind?.speed} m/s'),
                                  SizedBox(height: 5,),
                                  Text(getDirection(weather.wind!.deg!)),
                                ],
                              )
                            ),
                            SizedBox(height: 10,),
                            Container(
                                height: 95,
                                width: (MediaQuery.of(context).size.width-36)/2,
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColor.secondaryColor.withOpacity(0.3),
                                ),
                                child: Column(
                                  children: [
                                    Text('${DateFormat("h:mma").format(DateTime.parse(weather.sys!.sunrise.toString()))} Sunrise'),
                                    SizedBox(height: 5,),
                                    Text('${DateFormat("h:mma").format(DateTime.parse(weather.sys!.sunset.toString()))} Sunset'),
                                  ],
                                )
                            ),
                          ],
                        ),
                        SizedBox(width: 10,),
                        Container(
                            height: 200,
                            width: (MediaQuery.of(context).size.width-36)/2,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColor.secondaryColor.withOpacity(0.3),
                            ),
                            child: ListView(
                              children: [
                                ListTile(
                                  titleTextStyle: TextStyle(
                                    color: AppColor.accentColor,
                                    fontSize: 13
                                  ),
                                  textColor: AppColor.accentColor,
                                  title: Text('Humidity'),
                                  trailing: Text('${weather.main?.humidity}%'),
                                ),
                                ListTile(
                                  titleTextStyle: TextStyle(
                                      color: AppColor.accentColor,
                                      fontSize: 13
                                  ),
                                  leadingAndTrailingTextStyle: TextStyle(
                                    fontSize: 10
                                  ),
                                  textColor: AppColor.accentColor,
                                  title: Text('Real feel'),
                                  trailing: Text('${weather.main!.feelsLike?.toStringAsFixed(0) ?? ''}°C'),
                                ),
                                ListTile(
                                  titleTextStyle: TextStyle(
                                      color: AppColor.accentColor,
                                      fontSize: 13
                                  ),
                                  textColor: AppColor.accentColor,
                                  title: Text('Pressure'),
                                  trailing: Text('${weather.main?.pressure}hPa'),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColor.secondaryColor.withOpacity(0.3),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_month),
                                  SizedBox(width: 5,),
                                  Text('5-day forecast',),
                                ],
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Row(
                                  children: [
                                    Text('More details'),
                                    SizedBox(width: 4,),
                                    Icon(Icons.arrow_right),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_month),
                                  SizedBox(width: 5,),
                                  Text('5-day forecast',),
                                ],
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Row(
                                  children: [
                                    Text('Mode details'),
                                    SizedBox(width: 4,),
                                    Icon(Icons.arrow_right),
                                  ],
                                ),

                              )
                            ],
                          ),
                          ElevatedButton(

                              onPressed: () {},
                              child: Text('5-day Forecast')
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: FittedBox(
                          // height: 30,
                          // width: 250,
                          child: Row(
                            children: [
                              Text('Data Provided in part by '),
                              SvgPicture.asset(
                                'assets/icons/openweather.svg',
                                height: 25,
                                width: 25,
                                color: Colors.orange,
                              ),
                              Text(' OpenWeather'),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          else if (state is WeatherLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.accentColor,
              ),
            );
          }
          else if (state is WeatherError) {
            return const Center(
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
        },
      ),
      ),
    );
  }
}
