import 'package:flutter/material.dart';
import 'package:flutter_audio_player/screens/main/ui/main_page.dart';

// App navigation routes
class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var arg = settings.arguments;

    switch(settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MainPage());
    }
  }
}