import 'package:flutter_chat/Pages/chatDetail/chatDetail.dart';
import 'package:flutter_chat/Pages/login/loginPage.dart';
import 'package:flutter_chat/Pages/mainPage.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Routes {
  static String root = "/home";
  static String chatDetail = "chat_detail";
  static String login = "/login";
  static Router configureRoutes() {
    Router router = Router();

    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return MainPage();
    });
    router.define(root, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return MainPage();
    }));
    router.define(login, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return LoginPage();
    }));
    router.define(chatDetail, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return DetailPage();
    }));

    return router;
  }
}
