import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';

class AdMobManager {
  //TODO: change the ids for Production release
  // Application Id
  static final String _APP_ID = 'ca-app-pub-3940256099942544~3347511713';
  // Ad units Ids
  static final String _BANNER_ID = 'ca-app-pub-3940256099942544/6300978111';
  static final String _INTERSTITIAL_ID = 'ca-app-pub-3940256099942544/1033173712';

  static String getAppId() {
    if (Platform.isAndroid) {
      return _APP_ID;
    }
    return null;
  }

  static String getBannerAdUnitId() {
    if (Platform.isAndroid) {
      return _BANNER_ID;
    }
    return null;
  }

  static String getInterstitialAdUnitId() {
    if (Platform.isAndroid) {
      return _INTERSTITIAL_ID;
    }
    return null;
  }

  static AdmobBanner buildBannerAd(AdmobBannerSize bannerSize) {
    return AdmobBanner(
        adUnitId: getBannerAdUnitId(),
        adSize: bannerSize,
        listener: (AdmobAdEvent event,
            Map<String, dynamic> args) {
          print('event: $event');
        },
    );
  }

  static AdmobInterstitial buildInterstitialAd(Function eventCallback) {
    return AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
            eventCallback(event);
        },
    );
  }
}