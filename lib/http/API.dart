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
  static checkIfSameIMEI(String loginId,String iMEI){
    Map<String,dynamic> querys ={"loginId":loginId,"IMEI":iMEI};
    
  }
}
