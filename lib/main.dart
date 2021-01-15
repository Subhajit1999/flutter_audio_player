import 'package:flutter/material.dart';
import 'package:flutter_audio_player/configs/size_config.dart';
import 'package:flutter_audio_player/routes.dart';
import 'package:flutter_audio_player/theme/styles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          return OrientationBuilder(
              builder: (context, orientation) {
                SizeConfig().init(constraints, orientation); // SizeConfig initialization

                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  initialRoute: '/',
                  onGenerateRoute: AppRoutes.generateRoute,
                );
              }
          );
        }
    );
  }
}