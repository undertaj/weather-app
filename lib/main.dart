import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather/app/data/bloc/weather/Weather_bloc.dart';
import 'package:weather/app/features/splash/view/splash_page.dart';

import 'app/data/bloc/location/location_bloc.dart';
import 'app/features/details/view/details_page.dart';
import 'app/features/home/view/home_page.dart';
import 'app/utils/color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(


      providers: [
        BlocProvider<LocationBloc>(
          create: (BuildContext context) => LocationBloc(),
        ),
        BlocProvider<WeatherBloc>(
          create: (BuildContext context) => WeatherBloc(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => SplashScreen(),
            ),
            GoRoute(
              path: '/home',
              builder: (context, state) => HomePage(),
            ),
            GoRoute(
              path: '/details',
              builder: (context, state) {
                Map<String,String> mp = state.extra as Map<String,String> ;
                return DetailsPage(lat: mp['lat'] ?? '', lon: mp['lon'] ?? '');
                },
              // onExit: (BuildContext context) {Navigator.of(context).pop(true);}
            ),
          ],
          initialLocation: '/'
        ),

        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

          textTheme: const TextTheme(
            bodyText1: TextStyle(),
            bodyText2: TextStyle(),
          ).apply(
            bodyColor: AppColor.accentColor,
            displayColor: AppColor.accentColor,
          ),
          iconTheme: const IconThemeData(
            color: AppColor.accentColor,
          ),

          useMaterial3: true,
        ),
      ),
    );
  }
}

