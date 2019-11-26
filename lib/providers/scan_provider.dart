import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:validators/validators.dart';

class ScanProvider extends ChangeNotifier {
  bool isPermissionGranted = false;
  String url = '';

  ScanProvider() {
    _permissions = <PermissionGroup>[
//      PermissionGroup.photos,
      PermissionGroup.camera,
//      PermissionGroup.storage
    ];
  }

  List<PermissionGroup> _permissions;

  Future<bool> requestPermission() async {
    Map<PermissionGroup, PermissionStatus> permissionResult =
        <PermissionGroup, PermissionStatus>{};
    assert(_permissions.isNotEmpty);
    permissionResult =
        await PermissionHandler().requestPermissions(_permissions);
    if (permissionResult.isNotEmpty) {
      permissionResult.removeWhere(
          (PermissionGroup permission, PermissionStatus status) =>
              status == PermissionStatus.granted);
      return permissionResult.isEmpty;
    } else {
      return false;
    }
  }

  Future<void> scanQRCode() async{
    final SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.reload();
    _sharedPreferences.setBool("permission_allowed", true);
    isPermissionGranted = true;
    notifyListeners();
  }

  Future<bool> checkForPermission() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.reload();
    bool status = sharedPreferences.getBool("permission_allowed");
    if(status != null && status) {
      isPermissionGranted = true;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> openQRScanner() async{
    String qrCodeScanRes;
    try {
      qrCodeScanRes =
          await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true);
    } on PlatformException {
      qrCodeScanRes = 'Failed to get platform version.';
    }

//    if (!mounted) {
//      return;
//    }
    if (qrCodeScanRes.isNotEmpty && qrCodeScanRes != null) {
      bool isUrl = isURL(qrCodeScanRes, requireTld:  false);
      if(isUrl) {
        //open webview
        url = qrCodeScanRes;
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
