import 'package:flutter/material.dart';
import 'package:flutter_audio_player/theme/colors.dart';
import 'package:flutter_audio_player/utils/sizes.dart';

// Default/Light theme
class AppTheme {
  AppTheme._();

  // App Light Theme
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundColor,
    primaryColor: AppColors.primaryColor,
    accentColor: AppColors.accentColor,
    brightness: Brightness.light,
    backgroundColor: AppColors.backgroundColor,
    textTheme: lightTextTheme,
    primaryIconTheme: _mainIconThemeLight,
    bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.black.withOpacity(0)),
  );

  static final TextTheme lightTextTheme = TextTheme(
    headline4: _largeHeadLineLight,
    headline5: _appBarTitleLight,
    bodyText1: _bodyTextSemiBoldLight,
    bodyText2: _bodyTextRegularLight,
    button: _buttonTextLight,
  );

  // Text Styles (Light)
  static final TextStyle _largeHeadLineLight = TextStyle(
    color: AppColors.secondaryColor,
    fontSize: Sizes.largeHeadlineSize,
    // fontFamily: Sizes.secondaryFont,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle _appBarTitleLight = TextStyle(
    color: AppColors.secondaryColor,
    // fontFamily: Sizes.defaultFont,
    fontSize: Sizes.appbarTitleSize,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle _bodyTextSemiBoldLight = TextStyle(
    color: AppColors.secondaryColor,
    fontSize: Sizes.semiboldTitleSize,
    // fontFamily: Sizes.secondaryFontSemiBold,
  );

  static final TextStyle _bodyTextRegularLight = TextStyle(
    color: Colors.blueGrey,
    // fontFamily: Sizes.secondaryFont,
    fontSize: Sizes.regularSubtitleSize,
  );

  static final TextStyle _buttonTextLight = TextStyle(
    color: Colors.white,
    fontSize: Sizes.buttonTextSize,
    // fontFamily: Sizes.defaultFont,
    letterSpacing: 1,
  );

  static final IconThemeData _mainIconThemeLight = IconThemeData(
    color: AppColors.secondaryColor,
  );
}