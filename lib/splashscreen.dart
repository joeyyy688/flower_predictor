// ignore_for_file: file_names

import 'package:flower_predictor/home.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplash extends StatefulWidget {
  const MySplash({Key? key}) : super(key: key);

  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen.timer(
      seconds: 2,
      navigateAfterSeconds: const HomePage(),
      title: const Text(
        'Flower Predictor',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: Colors.white,
        ),
      ),
      image: Image.asset('assets/images/flower.png'),
      photoSize: 50.0,
      gradientBackground: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.004, 1],
        colors: [
          Color(0xFFa8e063),
          Color(0xFF56ab2f),
        ],
      ),
      loaderColor: Colors.white,
    );
  }
}
