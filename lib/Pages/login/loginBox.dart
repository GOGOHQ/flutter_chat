import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_chat/Provider/loginProvider.dart';
import 'package:flutter_chat/Provider/themeProvider.dart';
import 'package:flutter_chat/Router/fade_router.dart';
import 'package:flutter_chat/Utils/navigatorUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../mainPage.dart';

class LoginBox extends StatelessWidget {
  const LoginBox({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController pwdController = TextEditingController();
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    TextEditingController accountController = TextEditingController();

    return BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: ScreenUtil().setWidth(3), sigmaY: ScreenUtil().setWidth(4)),
        child: Container(
            width: ScreenUtil.screenWidth,
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(20),
                vertical: ScreenUtil().setHeight(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(30),
                      vertical: ScreenUtil().setWidth(20)),
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().setWidth(20)),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: ScreenUtil().setWidth(20),
                            color: Colors.black54,
                            offset: Offset(ScreenUtil().setWidth(20),
                                ScreenUtil().setWidth(20)))
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),
                      buildUserNameInput(loginProvider),
                      buildPassWordInput(pwdController),
                      buildHelpRow(),
                      buildLoginButton(loginProvider, context),
                      buildLocalLogin()
                    ],
                  ),
                ),
              ],
            )));
  }

  Widget buildPassWordInput(TextEditingController pwdController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LoginTitle(
          text: "密码",
        ),
        LoginTextField(
          controller: pwdController,
          obsecure: true,
          width: ScreenUtil().setWidth(660),
          correct: true,
          icon: Icon(
            Icons.lock,
            size: ScreenUtil().setWidth(40),
          ),
          hintText: "请输入您的密码",
        ),
      ],
    );
  }

  Widget buildUserNameInput(LoginProvider loginProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LoginTitle(
          text: "账号/手机号",
        ),
        LoginTextField(
          controller: loginProvider.userNameController,
          obsecure: false,
          width: ScreenUtil().setWidth(660),
          icon: Icon(
            Icons.face,
            size: ScreenUtil().setWidth(40),
          ),
          correct: !loginProvider.ifValidUserName,
          hintText: "请输入您的账号/手机号",
        ),
      ],
    );
  }

  Widget buildLocalLogin() {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
      child: Center(
          child: FlatButton(
        onPressed: () {
          // loginProvider.changeLoginBox();
        },
        child: Text(
          "本机一键登录",
          style: TextStyle(
              fontSize: ScreenUtil().setSp(33),
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: Colors.grey),
        ),
      )),
    );
  }

  Widget buildHelpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FlatButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Text(
            "注册账号",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () {},
        ),
        FlatButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Text(
            "忘记密码？",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () {},
        )
      ],
    );
  }

  Widget buildLoginButton(LoginProvider loginProvider, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20))),
            height: ScreenUtil().setWidth(90),
            // width: 750*rpx-2*margin,
            padding: EdgeInsets.all(0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(ScreenUtil().setWidth(20))),
              color: Colors.green[500],
              child: Text(
                "登录",
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(35)),
              ),
              onPressed: () {
                loginProvider.addNewUser();
                NavigatorUtil.navigateTo(context, "/home");
              },
            ),
          ))
        ],
      ),
    );
  }
}

class LoginTitle extends StatelessWidget {
  const LoginTitle({Key key, @required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style:
            TextStyle(fontFamily: "Pangmen", fontSize: ScreenUtil().setSp(48)),
      ),
    );
  }
}

class LoginTextField extends StatelessWidget {
  const LoginTextField(
      {Key key,
      @required this.controller,
      @required this.obsecure,
      @required this.icon,
      @required this.width,
      @required this.hintText,
      @required this.correct})
      : super(key: key);
  final TextEditingController controller;
  final bool obsecure;
  final Icon icon;
  final double width;
  final String hintText;
  final bool correct;
  @override
  Widget build(BuildContext context) {
    double iconWidth = ScreenUtil().setWidth(40);
    return Container(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(25)),
      width: width,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
            width: width - iconWidth - ScreenUtil().setWidth(220),
            child: TextField(
              controller: controller,
              obscureText: obsecure,
              decoration: InputDecoration(
                  border: InputBorder.none, icon: icon, hintText: hintText),
              style: TextStyle(fontSize: ScreenUtil().setSp(32)),
            )),
        AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: correct ? 0 : 1,
          child: Container(
              child: Row(
            children: <Widget>[
              Icon(
                Icons.error_outline,
                size: iconWidth,
                color: Colors.redAccent,
              ),
              SizedBox(width: ScreenUtil().setWidth(5)),
              Text("不正确",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(26.0),
                      color: Colors.black))
            ],
          )),
        )
      ]),
    );
  }
}

class QuickLoginBox extends StatelessWidget {
  const QuickLoginBox({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginProvider provider = Provider.of<LoginProvider>(context);

    double margin = ScreenUtil().setWidth(45);
    return BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: ScreenUtil().setWidth(10),
            sigmaY: ScreenUtil().setWidth(10)),
        child: Container(
            width: ScreenUtil().setWidth(750) - 2 * margin,
            margin: EdgeInsets.symmetric(horizontal: margin),
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(20),
                vertical: ScreenUtil().setWidth(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(30),
                        vertical: ScreenUtil().setWidth(20)),
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(20)),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: ScreenUtil().setWidth(20),
                              color: Colors.black54,
                              offset: Offset(ScreenUtil().setWidth(20),
                                  ScreenUtil().setWidth(20)))
                        ]),
                    child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setWidth(30)),
                              child: Text("登录解锁更多玩法",
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(40)))),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setWidth(140)),
                              child: Text(
                                "186 **** 0612",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(50),
                                    fontFamily: "Pangmen"),
                              )),
                          Container(
                            margin:
                                EdgeInsets.only(top: ScreenUtil().setWidth(70)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                    child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setWidth(20))),
                                  height: ScreenUtil().setWidth(90),
                                  // width: 750*rpx-2*margin,
                                  padding: EdgeInsets.all(0),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setWidth(20))),
                                    color: Colors.green[500],
                                    child: provider.ifStartRequest
                                        ? Padding(
                                            padding: EdgeInsets.all(
                                                ScreenUtil().setWidth(8)),
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Colors.white),
                                            ))
                                        : Text(
                                            "本机一键登录",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    ScreenUtil().setSp(35)),
                                          ),
                                    onPressed: () {
                                      // provider.ifUserExistsByTelNo(context);
                                    },
                                  ),
                                ))
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: ScreenUtil().setWidth(20)),
                            child: Center(
                                child: FlatButton(
                              onPressed: () {
                                // provider.changeLoginBox();
                              },
                              child: Text(
                                "其他登录方式",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(35),
                                    decoration: TextDecoration.underline),
                              ),
                            )),
                          )
                        ])),
              ],
            )));
  }
}
