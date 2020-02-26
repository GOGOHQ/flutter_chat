import 'dart:io';

import 'package:flutter_chat/Provider/jPushProvider.dart';
import 'package:flutter_chat/Provider/signalRProvider.dart';
import 'package:flutter_chat/Provider/xfVoiceProvider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SendButton extends StatefulWidget {
  final SignalRProvider signalRProvider;
  final TextEditingController txtController;

  SendButton({this.txtController, this.signalRProvider});
  @override
  _SendButtonState createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> paddingAnimation;
  // runXFVoiceVTT(
  //     XFVoiceProvider xF, cmdMp3, cmdPcm, resultPath, origPath, mp3Path) async {
  //   await NativeTool.ffmpegConverter(cmdMp3);
  //   await NativeTool.ffmpegConverter(cmdPcm);
  //   // File(origPath).delete();
  //   File(mp3Path).delete();
  //   var bytes = File(resultPath).readAsBytesSync();
  //   await xF.initChannelVTT();
  //   await Future.delayed(Duration(seconds: 3));
  //   xF.convertVoiceToText("5e43ae7f", bytes);
  // }

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 800),
        animationBehavior: AnimationBehavior.normal);
    paddingAnimation = Tween(begin: 80.0, end: 200.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.bounceOut));
    animationController.addListener(() {
      setState(() {});
    });
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      width: ScreenUtil().setWidth(paddingAnimation.value),
      child: RaisedButton(
        padding: EdgeInsets.all(0),
        color: Colors.green[300],
        child: Text(
          "发送",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          // xfVoiceProvider.converTextToVoice("5e43ae7f", "x_xiaofeng",
          //     "大家好我的名字叫黄祺,大家好我是黄祺,大家好我是黄祺,大家好我是黄祺,大家好我是黄祺");
          // var bytes = File(
          //         "/storage/emulated/0/Android/data/com.guojio.todother/files2d85fece-9b09-40d5-85e4-3dcfd721f411.pcm")
          //     .readAsBytesSync();
          // await Future.delayed(Duration(seconds: 2));
          // xfVoiceProvider.convertVoiceToText("5e43ae7f", bytes);

          widget.signalRProvider.sendMessage(widget.txtController.text);
          widget.txtController.clear();
          widget.signalRProvider.scrollToEnd();
        },
      ),
    );
  }
}
