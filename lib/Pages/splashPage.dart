import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/Common/staticMembers.dart';
import 'package:flutter_chat/Model/userLoginModel.dart';
import 'package:flutter_chat/Pages/login/loginPage.dart';
import 'package:flutter_chat/Pages/mainPage.dart';
import 'package:flutter_chat/Provider/loginProvider.dart';
import 'package:flutter_chat/Provider/signalRProvider.dart';
import 'package:flutter_chat/Router/fade_router.dart';
import 'package:flutter_chat/Utils/navigatorUtil.dart';
import 'package:flutter_chat/Utils/sqliteHelper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  PageController _controller;
  int currentPage = 0;
  bool lastPage = false;
  AnimationController animationController;
  Animation<double> _scaleAnimation;
  List<String> pics = [
    "images/splash/1.jpg",
    "images/splash/2.jpg",
    "images/splash/3.jpg"
  ];
  List<String> fpics = [
    "images/splash/f1.jpg",
    "images/splash/f2.jpg",
    "images/splash/f3.jpg"
  ];
  var pageList = [
    PageModel(
        title: "MUSIC",
        body: "EXPERIENCE WICKED PLAYLISTS",
        titleGradient: gradients[0]),
    PageModel(
        title: "SPA",
        body: "FEEL THE MAGIC OF WELLNESS",
        titleGradient: gradients[1]),
    PageModel(
        title: "TRAVEL", body: "LET'S HIKE UP", titleGradient: gradients[2]),
  ];
  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: currentPage,
    );
    animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _scaleAnimation = Tween(begin: 0.6, end: 1.0).animate(animationController);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFF485563), Color(0xFF29323C)],
            tileMode: TileMode.clamp,
            begin: Alignment.topCenter,
            stops: [0.0, 1.0],
            end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        body: new Stack(
          children: <Widget>[
            PageView.builder(
              itemCount: pageList.length,
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                  if (currentPage == pageList.length - 1) {
                    lastPage = true;
                    animationController.forward();
                  } else {
                    lastPage = false;
                    animationController.reset();
                  }
                });
              },
              itemBuilder: (context, index) {
                return SplashItem(
                  controller: _controller,
                  pageList: pageList,
                  index: index,
                  fpicUrl: fpics[index],
                  picUrl: pics[index],
                );
              },
            ),
            Positioned(
              left: 30.0,
              bottom: 55.0,
              child: Container(
                  width: 160.0,
                  child: PageIndicator(currentPage, pageList.length)),
            ),
            Positioned(
              right: 30.0,
              bottom: 30.0,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: lastPage
                    ? FloatingActionButton(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                        onPressed: () async {
                          SqliteHelper sqliteHelper = new SqliteHelper();
                          UserLoginModel loginModel =
                              await sqliteHelper.findCurLoginRecord();
                          if (loginModel.loginId != "" &&
                              loginModel.loginId != null) {
                            if (DateTime.now()
                                    .difference(loginModel.loginDate)
                                    .inDays <
                                5) {}
                          }
                        },
                      )
                    : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getImei() async {
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

  void normalLogin() {
    Navigator.of(context).pushAndRemoveUntil(
        FadeRoute(
            page: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => LoginProvider(),
            )
          ],
          child: LoginPage(),
        )),
        ModalRoute.withName('/'));
  }

  void passLogin() {
    Navigator.of(context).pushAndRemoveUntil(
        FadeRoute(
          page: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => SignalRProvider()),
            ],
            child: MainPage(),
          ),
        ),
        ModalRoute.withName('/'));
  }
}

class SplashItem extends StatelessWidget {
  const SplashItem(
      {Key key,
      @required PageController controller,
      @required this.pageList,
      @required this.index,
      this.fpicUrl,
      this.picUrl})
      : _controller = controller,
        super(key: key);
  final int index;
  final String fpicUrl;
  final PageController _controller;
  final List<PageModel> pageList;
  final String picUrl;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        var page = pageList[index];
        var delta;
        var y = 1.0;

        if (_controller.position.haveDimensions) {
          delta = _controller.page - index;
          y = 1 - delta.abs().clamp(0.0, 1.0);
        }
        return Container(
          width: ScreenUtil.screenWidth,
          height: ScreenUtil.screenHeight,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              FadeInImage(
                fadeOutDuration: Duration(seconds: 2),
                fadeInDuration: Duration(seconds: 2),
                placeholder: AssetImage(
                  fpicUrl,
                ),
                image: AssetImage(
                  picUrl,
                ),
                fit: BoxFit.cover,
              ),
              Positioned(
                left: ScreenUtil().setWidth(5),
                bottom: ScreenUtil().setHeight(180),
                child: Container(
                  margin: EdgeInsets.only(left: 12.0),
                  child: Stack(
                    children: <Widget>[
                      Opacity(
                        opacity: .10,
                        child: GradientText(
                          page.title,
                          gradient: LinearGradient(
                              colors: pageList[index].titleGradient),
                          style: TextStyle(
                              fontSize: 100.0,
                              fontFamily: "Montserrat-Black",
                              letterSpacing: 1.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0, left: 22.0),
                        child: GradientText(
                          page.title,
                          gradient: LinearGradient(
                              colors: pageList[index].titleGradient),
                          style: TextStyle(
                            fontSize: 70.0,
                            fontFamily: "Montserrat-Black",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: ScreenUtil().setWidth(5),
                bottom: ScreenUtil().setHeight(150),
                child: Padding(
                  padding: const EdgeInsets.only(left: 34.0, top: 0.0),
                  child: Transform(
                    transform: Matrix4.translationValues(0, 50.0 * (1 - y), 0),
                    child: Text(
                      page.body,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(35),
                          fontFamily: "Montserrat-Medium",
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int pageCount;
  PageIndicator(this.currentIndex, this.pageCount);

  _indicator(bool isActive) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          height: 4.0,
          decoration: BoxDecoration(
              color: isActive ? Colors.white : Color(0xFF3E4750),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 2.0)
              ]),
        ),
      ),
    );
  }

  _buildPageIndicators() {
    List<Widget> indicatorList = [];
    for (int i = 0; i < pageCount; i++) {
      indicatorList
          .add(i == currentIndex ? _indicator(true) : _indicator(false));
    }
    return indicatorList;
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: _buildPageIndicators(),
    );
  }
}
