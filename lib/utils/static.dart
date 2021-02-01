import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_player/utils/audio_metadata.dart';
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
  // AudioService stat ic essentials
  static bool serviceStarted = false;
  static MediaItem mediaItem;
  static PlaybackState playbackState;
  static AudioMetadata metadata = AudioMetadata();

  // Static functions
  static String getTimeStamp(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if(duration.inHours>0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}