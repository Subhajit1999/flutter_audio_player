import 'package:flutter/material.dart';
import 'package:path_provider_ex/path_provider_ex.dart';

class Statics {

  static List<MaterialAccentColor> ColorsList = [
    Colors.lightBlueAccent,
    Colors.blueAccent,
    Colors.indigoAccent,
    Colors.greenAccent,
    Colors.amberAccent,
    Colors.orangeAccent,
    Colors.deepOrangeAccent,
    Colors.redAccent,
    Colors.purpleAccent,
    Colors.deepPurpleAccent,
  ];

  static List<StorageInfo> availableStorage = [];
  static PersistentBottomSheetController controller;
}