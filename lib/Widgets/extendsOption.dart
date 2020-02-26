import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExtendOption extends StatelessWidget {
  final String text;
  final IconData icon;
  ExtendOption({this.icon, this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(100),
      height: ScreenUtil().setWidth(155),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(85),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Icon(icon)),
          Text(
            text,
            style: TextStyle(color: Colors.grey[600]),
          )
        ],
      ),
    );
  }
}
