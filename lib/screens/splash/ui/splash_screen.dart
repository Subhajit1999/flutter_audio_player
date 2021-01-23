import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_audio_player/utils/media.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int SPLASH_TIMEOUT = 2;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: SPLASH_TIMEOUT), () {
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Image.asset(AssetMedia.splash_logo, scale: 2,),
        ),
      ),
    );
  }
}
