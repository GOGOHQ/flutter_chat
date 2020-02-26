import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomRowAnimProvider extends State<StatefulWidget>
    with ChangeNotifier, TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animController;
  double bottomSheetHeight = 0;
  bool ifExpanded = false;
  BottomRowAnimProvider(context) {
    animController = AnimationController(
        vsync: this,
        animationBehavior: AnimationBehavior.normal,
        duration: Duration(milliseconds: 150),
        reverseDuration: Duration(milliseconds: 150));
    animation = Tween<double>(begin: 0.0, end: ScreenUtil().setWidth(200))
        .animate(
            CurvedAnimation(curve: Curves.bounceOut, parent: animController))
          ..addListener(() {
            bottomSheetHeight = animation.value;
            Future.delayed(Duration(seconds: 0), () {
              notifyListeners();
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.forward) {
              ifExpanded = true;
            } else if (status == AnimationStatus.reverse) {
              ifExpanded = false;
            }
          });
  }
  runAnimation() {
    if (ifExpanded == false) {
      animController.forward(from: 0);
    }
  }

  reverseAnim() {
    if (ifExpanded == true) {
      animController.reverse(from: 1.0);
    }
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
