import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat/http/API.dart';

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
  String userName;
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
    userNameController.addListener(() {
      userName = userNameController.text;
      ifValidUserName = checkValidUserName(userName);
      notifyListeners();
    });
    initBackGroundAnimation();
    timer = Timer.periodic(Duration(seconds: 4), (callback) {
      bgAnimationController.forward(from: 0);
    });
  }
  @override
  void dispose() {
    bgAnimationController?.dispose();
    super.dispose();
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
