import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/Pages/mainPage.dart';
import 'package:flutter_chat/Provider/signalRProvider.dart';
import 'package:flutter_chat/Router/fade_router.dart';
import 'package:flutter_chat/Utils/imeiUtil.dart';
import 'package:flutter_chat/Utils/sqliteHelper.dart';
import 'package:flutter_chat/http/API.dart';
import 'package:flutter_chat/http/http_request.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends State<StatefulWidget>
    with ChangeNotifier, TickerProviderStateMixin {
  AnimationController bgAnimationController;
  double showPicOpacity = 1.0;
  double toChangePicOpacity = 0.0;
  Animation<double> opacityAnimation;
  TextEditingController userNameController = TextEditingController();
  bool ifValidUserName = false;
  bool ifStartRequest = false;
  Timer timer;
  String imei;
  String userName;

  SqliteHelper sqliteHelper;
  int curLoginWidget; //0 quick 1 normal
  List<String> backgrounds = [
    "images/login/background0.jpg",
    "images/login/background1.jpg",
    "images/login/background2.jpg",
    "images/login/background3.jpg",
    "images/login/background4.jpg",
  ];
  int showIndex = 0;
  int toChangeIndex = 1;
  LoginProvider() {
    curLoginWidget = 0;
    userNameController.addListener(() {
      userName = userNameController.text;
      ifValidUserName = checkValidUserName(userName);
      notifyListeners();
    });
    initBackGroundAnimation();
    timer = Timer.periodic(Duration(seconds: 3), (callback) {
      bgAnimationController.forward(from: 0);
    });
  }
  ifUserExistsByTelNo(BuildContext context) async {
    ifStartRequest = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 1));
    imei = await ImeiUtil.getImei();
    print("imei$imei");
    var result = await API.ifUserExistsByTelNo("18296998548", imei);
    ifStartRequest = false;
    notifyListeners();
    if (result["result"] == true) {
      sqliteHelper = SqliteHelper();
      await sqliteHelper.delCurLoginRecord();
      String loginId = result["userId"];
      await sqliteHelper.addNewLogin(loginId, imei);
      Navigator.of(context).pushAndRemoveUntil(
          FadeRoute(page: MainPage()), ModalRoute.withName("/home"));
    } else {
      BotToast.showText(
          text: "当前手机号未注册",
          textStyle: TextStyle(fontSize: 12, color: Colors.white));
    }
  }

  @override
  void dispose() {
    bgAnimationController?.dispose();
    timer?.cancel();
    super.dispose();
  }

  changeLoginBox() {
    curLoginWidget = curLoginWidget == 0 ? 1 : 0;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }

  addNewUser() async {
    final result = await API.addNewUser(userName);
    // print(result.data);
  }

  initBackGroundAnimation() {
    bgAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1300));
    opacityAnimation =
        Tween(begin: 0.0, end: 1.0).animate(bgAnimationController)
          ..addListener(() {
            showPicOpacity = 1 - opacityAnimation.value;
            toChangePicOpacity = opacityAnimation.value;
            notifyListeners();
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              showIndex = (++showIndex) % backgrounds.length;
              toChangeIndex = (++toChangeIndex) % backgrounds.length;
              showPicOpacity = 1;
              toChangePicOpacity = 0;
              notifyListeners();
            }
          });
  }

  bool checkValidUserName(String userName) {
    bool ifMatch = RegExp("[^A-Za-z0-9]+").hasMatch(userName);
    return ifMatch;
  }
}
