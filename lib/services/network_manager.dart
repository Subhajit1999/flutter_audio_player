import 'package:connectivity/connectivity.dart';

class NetworkManager {
  static const String networkErrorMsg = "Unable to connect. Please Check Internet Connection";

  static Future<bool> isNetworkConnected() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }
}