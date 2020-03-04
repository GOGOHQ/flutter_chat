import 'dart:io';

import 'package:device_info/device_info.dart';

class ImeiUtil {
  static getImei() async {
    String imeiT;
    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      imeiT = iosInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      var andInfo = await DeviceInfoPlugin().androidInfo;
      imeiT = andInfo.androidId;
    }
    return imeiT;
  }
}
