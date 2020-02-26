import 'dart:math';
import 'dart:typed_data';

import 'package:amap_all_fluttify/amap_all_fluttify.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter_chat/Common/staticMembers.dart';
import 'package:flutter_chat/Provider/bottomRowAnimaProvider.dart';
import 'package:flutter_chat/Provider/signalRProvider.dart';
import 'package:flutter_chat/Provider/voiceRecoderProvider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_chat/Provider/xfVoiceProvider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'bottomChatRow.dart';
import 'chatRow.dart';

class ChatRecord {
  Uint8List locPic;
  Poi poi;
  String picContent;
  BoxFit imgFitType;
  double imgWidth;
  double imgHeight;
  String videoPath;
  int sender;
  String avatarUrl;
  String content;
  int chatType;
  String voicePath;
  Duration voiceTime;
  ChatRecord(
      {this.poi,
      this.locPic,
      this.picContent,
      this.videoPath,
      this.imgWidth,
      this.imgHeight,
      this.imgFitType,
      this.sender,
      this.content,
      this.avatarUrl,
      this.chatType,
      this.voicePath,
      this.voiceTime});
}

class DetailPage extends StatelessWidget {
  final int index;
  DetailPage({this.index});
  @override
  Widget build(BuildContext context) {
    VoiceRecoderProvider voiceRecoderProvider =
        Provider.of<VoiceRecoderProvider>(context);
    XFVoiceProvider xfVoiceProvider = Provider.of<XFVoiceProvider>(context);
    SignalRProvider provider = Provider.of<SignalRProvider>(context);
    BottomRowAnimProvider bottomRowAnimProvider =
        Provider.of<BottomRowAnimProvider>(context);
    bool hasLoad = false;
    if (provider != null && provider.conn != null && provider.connId != null)
      hasLoad = true;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("data"),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(20.0)),
            child: Icon(Icons.more_horiz),
          )
        ],
      ),
      body: Material(
        child: Hero(
            tag: index,
            child: hasLoad
                ? Column(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            bottomRowAnimProvider.reverseAnim();
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              ListView.builder(
                                  controller: provider.scrollController,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: provider.records.length,
                                  itemBuilder: (_, index) {
                                    return ChatRow(
                                        voiceRecoderProvider: voiceRecoderProvider,
                                        id: index,
                                        record: provider.records[index]);
                                  }),
                              voiceRecoderProvider.taping
                                  ? VoiceBox(provider: voiceRecoderProvider)
                                  : Container()
                            ],
                          ),
                        ),
                      ),
                      BottomChatRow(
                        xfVoiceProvider: xfVoiceProvider,
                        signalRprovider: provider,
                        voiceRecoderProvider: voiceRecoderProvider,
                        bottomRowAnimProvider: bottomRowAnimProvider,
                      )
                    ],
                  )
                : Container(
                    color: Colors.grey[200],
                    width: ScreenUtil.screenWidth,
                    height: ScreenUtil.screenHeight,
                    child: Center(
                        child: SpinKitRing(
                      color: Colors.white,
                      size: 50.0,
                    )),
                  )),
      ),
    );
  }
}

class VoiceBox extends StatelessWidget {
  final VoiceRecoderProvider provider;
  VoiceBox({this.provider});
  @override
  Widget build(BuildContext context) {
    double b = provider.voice / 8;
    int whiteNum = b.toInt();
    return Container(
      width: ScreenUtil().setWidth(370),
      height: ScreenUtil().setWidth(370),
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(15)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            Icons.keyboard_voice,
            size: ScreenUtil().setWidth(160),
            color: Colors.white,
          ),
          Container(
            height: ScreenUtil().setWidth(140),
            width: ScreenUtil().setWidth(120),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(9, (index) {
                  return Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setWidth(5)),
                      color: index >= 9 - whiteNum
                          ? Colors.white
                          : Colors.grey[400],
                      width: ScreenUtil().setWidth(90 - 10 * index),
                      height: ScreenUtil().setWidth(130) / 14);
                })),
          )
        ]),
        Container(
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(40)),
            child: Text('正在录音,上划取消', style: TextStyle(color: Colors.white)))
      ]),
    );
  }
}

//  Bubble(
//           margin: BubbleEdges.only(top: 10, left: 40, right: 20),
//           alignment: Alignment.topRight,
//           nip: BubbleNip.rightTop,
//           color: Color.fromRGBO(225, 255, 199, 1.0),
//           child: Text('Hello, World! Hello, World! Hello, World! Hello, World!',
//               textAlign: TextAlign.left),
//         ),
//         Bubble(
//           margin: BubbleEdges.only(top: 10, right: 40, left: 20),
//           alignment: Alignment.topLeft,
//           nip: BubbleNip.leftTop,
//           child: Text(
//               'Hi, developer! Hi, developer! Hi, developer! Hi, developer!'),
//         ),
