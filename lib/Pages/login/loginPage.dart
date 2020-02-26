import 'package:flutter/material.dart';
import 'package:flutter_chat/Provider/loginProvider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'loginBox.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginProvider provider = Provider.of<LoginProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(fit: StackFit.expand, children: [
        PhotoOnShow(
          backgroundUrl: provider.backgrounds[provider.showIndex],
          opacity: provider.showPicOpacity,
        ),
        PhotoToChange(
          backgroundUrl: provider.backgrounds[provider.toChangeIndex],
          opacity: provider.toChangePicOpacity,
        ),
        Positioned(
          left: ScreenUtil().setWidth(45.0),
          right: ScreenUtil().setWidth(45.0),
          top: ScreenUtil().setHeight(250),
          child: LoginBox(),
        ),
        Positioned(
            bottom: ScreenUtil().setHeight(230),
            left: ScreenUtil().setWidth(40),
            right: ScreenUtil().setWidth(40),
            child: buildOtherWayTip()),
        buildOtherLogin()
      ]),
    );
  }

  Container buildOtherWayTip() {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            width: ScreenUtil().setWidth(220),
            height: ScreenUtil().setWidth(2),
            color: Color(0xffEEEEEE)),
        Container(
          margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(28)),
          child: Text("其它登录方式",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(26.0),
                  color: Color(0xffCCCCCC))),
        ),
        Container(
            width: ScreenUtil().setWidth(220),
            height: ScreenUtil().setWidth(2),
            color: Color(0xffEEEEEE)),
      ]),
    );
  }

  Widget buildOtherLogin() {
    return Positioned(
      bottom: ScreenUtil().setHeight(100),
      left: 0,
      child: Container(
        width: ScreenUtil().setWidth(750),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              Icons.face,
              size: 50,
              color: Colors.white70,
            ),
            Icon(
              Icons.face,
              size: 50,
              color: Colors.white70,
            ),
            Icon(
              Icons.face,
              size: 50,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}

class PhotoOnShow extends StatelessWidget {
  final String backgroundUrl;
  final double opacity;
  PhotoOnShow({this.backgroundUrl, this.opacity});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Opacity(
        opacity: opacity,
        child: Image.asset(
          backgroundUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class PhotoToChange extends StatelessWidget {
  final String backgroundUrl;
  final double opacity;
  PhotoToChange({this.backgroundUrl, this.opacity});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Opacity(
        opacity: opacity,
        child: Image.asset(backgroundUrl, fit: BoxFit.cover),
      ),
    );
  }
}
