import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_audio_player/utils/static.dart';

class SizeConfig {
  static double screenWidth;
  static double screenHeight;
  static double _blockWidth = 0;
  static double _blockHeight = 0;

  static double textMultiplier;
  static double imageSizeMultiplier;
  static double heightMultiplier;
  static double widthMultiplier;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {  // Portrait mode
      screenWidth = constraints.maxWidth;
      screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {                                    // Landscape mode
      screenWidth = constraints.maxHeight;
      screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    // Block calculate
    _blockWidth = screenWidth / 100;
    _blockHeight = screenHeight / 100;

    textMultiplier = _blockHeight;
    imageSizeMultiplier = _blockWidth;
    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;

    print(_blockWidth);
    print(_blockHeight);

    // Banner Ad Size measurement
    if(SizeConfig.screenWidth<468) {
      Statics.bannerSize = AdmobBannerSize.BANNER;
      Statics.adContainerHeight = 50;
    }else if(SizeConfig.screenWidth>=468 && SizeConfig.screenWidth<728) {
      Statics.bannerSize = AdmobBannerSize.FULL_BANNER;
      Statics.adContainerHeight = 60;
    }else{
      Statics.bannerSize = AdmobBannerSize.LEADERBOARD;
      Statics.adContainerHeight = 90;
    }
    Statics.adContainerHeight += 10;
  }
}