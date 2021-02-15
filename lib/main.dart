import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_player/configs/size_config.dart';
import 'package:flutter_audio_player/data/storage_scanner.dart';
import 'package:flutter_audio_player/routes.dart';
import 'package:flutter_audio_player/screens/main/bloc/scanner_bloc.dart';
import 'package:flutter_audio_player/services/ad_manager.dart';
import 'package:flutter_audio_player/theme/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
  Admob.initialize(AdMobManager.getAppId());
}

class MyApp extends StatelessWidget {
  //Repositories init
  final StorageFileScanner _fileScanner = StorageFileScanner();

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: blocProviders(),

      child: LayoutBuilder(
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
      ),
    );
  }

  List<BlocProvider> blocProviders() {
    return [
      BlocProvider<FileScannerBloc>(  // UserAuthCheck BlocProvider
          create: (context) =>
              FileScannerBloc(scannerRepository: _fileScanner)),
    ];
  }
}