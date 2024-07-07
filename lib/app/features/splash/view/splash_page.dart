import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _width = 100;
  double _height = 100;

  void inc () {
    setState(() {
      _width += 50;
      _height += 50;
     });
  }

  @override
  void initState() {
    inc();
    Future.delayed(const Duration(seconds: 4), () {
      context.go('/home');
    });
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Lottie.asset(
                'assets/lottie/weather.json',
              backgroundLoading: true,
            ),
            // Positioned(
            //   top: 70,
            //   left: 25,
            //   child: SvgPicture.asset(
            //     'assets/images/cloud.svg',
            //     height: 60,
            //     width: 60,
            //
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
