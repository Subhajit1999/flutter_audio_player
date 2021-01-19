import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  final PermissionHandler _permissionHandler = PermissionHandler();

  Future<int> _requestPermission(PermissionGroup permission) async {  // Generic method for requesting permissions
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return 1;
    } else if(result[permission] == PermissionStatus.restricted || result[permission] == PermissionStatus.disabled) {
      return 2;
    } else if(result[permission] == PermissionStatus.denied) {
      return 0;
    }
    return 3;
  }

  Future<bool> hasPermission(PermissionGroup permission) async {   // Generic method for checking if permissions has already
    var permissionStatus =
      await _permissionHandler.checkPermissionStatus(permission);
    return permissionStatus == PermissionStatus.granted;
  }

  /// Requests the users permission to read their storage.
  Future<bool> requestStoragePermission({Function onPermissionDenied}) async {
    var granted = await _requestPermission(PermissionGroup.storage);
    if (granted == 0) {
      onPermissionDenied();
    } else if(granted == 2) {
      PermissionHandler().openAppSettings();
    }
    return granted == 1;
  }

  Future<bool> hasStoragePermission() async {
    return hasPermission(PermissionGroup.storage);
  }
}