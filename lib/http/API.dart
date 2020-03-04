import 'http_request.dart';
import 'dart:io';

class API {
  static addNewUser(String userName) async {
    Map<String, dynamic> querys = {"userName": userName};
    Map<String, dynamic> data = {"urlPath": "www.google.com"};
    final result =
        await HttpRequest.post("/user/addNewUser", data, querys: querys);
    return result;
  }

  static ifUserExistsByTelNo(String telNo, String imei) async {
    Map<String, dynamic> querys = {"telNo": telNo, "imei": imei};
    final result = await HttpRequest.get("/user/ifUserExistsByTelNo",
        queryParameters: querys);
    return result;
  }

  static Future<bool> checkIfSameIMEI(String loginId, String iMEI) async {
    Map<String, dynamic> querys = {"loginId": loginId, "IMEI": iMEI};
    final result =
        await HttpRequest.get("/user/ifSameIMEI", queryParameters: querys);
    if (result['ifSame'] == true) {
      return true;
    }
    return false;
  }
}
