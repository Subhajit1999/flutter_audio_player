import 'package:flutter/material.dart';
import 'package:flutter_audio_player/models/storage_file_system.dart';
import 'package:flutter_audio_player/screens/audio_list/ui/audio_list_page.dart';
import 'package:flutter_audio_player/screens/main/ui/main_page.dart';
import 'package:flutter_audio_player/screens/splash/ui/splash_screen.dart';

// App navigation routes
class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var arg = settings.arguments;

    switch(settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => MainPage());
      case '/files_list':
        AudioDirectory args = arg;
        return MaterialPageRoute(builder: (_) => AudioListPage(args));
    }
  }
}