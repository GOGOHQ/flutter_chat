import 'dart:async';
import 'dart:io';
import 'package:flutter_chat/Pages/vedioDetail.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter_chat/Common/staticMembers.dart';
import 'package:flutter_chat/Pages/chatDetail/chatDetail.dart';
import 'package:flutter_chat/Provider/voiceRecoderProvider.dart';
import 'package:flutter_chat/Utils/timeUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatRow extends StatefulWidget {
  final ChatRecord record;
  final int id;
  final VoiceRecoderProvider voiceRecoderProvider;
  ChatRow({
    this.id,
    this.voiceRecoderProvider,
    @required this.record,
  });

  @override
  _ChatRowState createState() => _ChatRowState();
}

class _ChatRowState extends State<ChatRow> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Timer timer;
  String location;
  String businessArea;
  @override
  void initState() {
    controller = AnimationController(vsync: this)
      ..drive(Tween(begin: 0, end: 1))
      ..duration = Duration(milliseconds: 350);
    super.initState();
    if (widget.record.chatType == CHATTYPE.LOCATION) {
      initLocation();
    }
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  initLocation() async {
    String city = await widget.record.poi.cityName;
    String province = await widget.record.poi.provinceName;
    String address = await widget.record.poi.address;
    String _businessArea = await widget.record.poi.title;
    setState(() {
      location = city + province + address;
      businessArea = _businessArea;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.record.sender == SENDER.SELF
        ? Container(
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(15.0),
          bottom: ScreenUtil().setWidth(15.0),
          top: ScreenUtil().setWidth(40.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(widget.record.avatarUrl),
          ),
          Container(
            width: ScreenUtil().setWidth(550),
            child: Bubble(
                color: widget.record.chatType == CHATTYPE.LOCATION ||
                    widget.record.chatType == CHATTYPE.IMAGE
                    ? Colors.white
                    : Color.fromRGBO(225, 255, 199, 1.0),
                padding: widget.record.chatType == CHATTYPE.LOCATION
                    ? BubbleEdges.all(0)
                    : BubbleEdges.only(
                    top: ScreenUtil().setWidth(15),
                    left: ScreenUtil().setWidth(30),
                    right: ScreenUtil().setWidth(30)),
                margin: BubbleEdges.only(
                    top: ScreenUtil().setWidth(45.0),
                    left: ScreenUtil().setWidth(15.0)),
                alignment: Alignment.topLeft,
                nip: BubbleNip.leftTop,
                child: buildChatContent(
                    widget.record, widget.voiceRecoderProvider,
                    location: location, area: businessArea)),
          ),
        ],
      ),
    )
        : Container(
      padding: EdgeInsets.only(
          right: ScreenUtil().setWidth(20.0),
          bottom: ScreenUtil().setWidth(15.0),
          top: ScreenUtil().setWidth(40.0)),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(550),
              child: Bubble(
                  padding: widget.record.chatType == CHATTYPE.LOCATION
                      ? BubbleEdges.all(0)
                      : BubbleEdges.only(
                      top: ScreenUtil().setWidth(15),
                      left: ScreenUtil().setWidth(30),
                      right: ScreenUtil().setWidth(30)),
                  margin: BubbleEdges.only(
                      top: ScreenUtil().setWidth(45.0),
                      right: ScreenUtil().setWidth(15.0)),
                  alignment: Alignment.topRight,
                  nip: BubbleNip.rightTop,
                  color: Colors.white,
                  child: buildChatContent(
                      widget.record, widget.voiceRecoderProvider,
                      location: location, area: businessArea)),
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(widget.record.avatarUrl),
            ),
          ]),
    );
  }

  buildChatContent(ChatRecord record, VoiceRecoderProvider voiceRecoderProvider,
      {String location, String area}) {
    switch (record.chatType) {
      case CHATTYPE.TEXT:
        return Text(
          record.content,
          strutStyle: StrutStyle(forceStrutHeight: true, leading: 0.2),
          style: TextStyle(
              fontSize: ScreenUtil().setSp(28.0), fontWeight: FontWeight.w500),
        );
      case CHATTYPE.VOICE:
        return record.sender == SENDER.SELF
            ? GestureDetector(
          onTap: () async {
            if (!voiceRecoderProvider.flutterSound.isPlaying) {
              await voiceRecoderProvider
                  .playVoice(record.voicePath)
                  .then((_) {
                controller.forward().then((_) {
                  timer = Timer(record.voiceTime, () {
                    controller.reverse();
                  });
                });
              });
            } else {
              controller.reverse();
              await voiceRecoderProvider.playVoice(record.voicePath);
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedIcon(
                  icon: AnimatedIcons.play_pause, progress: controller),
              Text(TimeUtil.convertDurationToString(record.voiceTime))
            ],
          ),
        )
            : GestureDetector(
          onTap: () async {
            if (!voiceRecoderProvider.flutterSound.isPlaying) {
              await voiceRecoderProvider
                  .playVoice(record.voicePath)
                  .then((_) {
                controller.forward().then((_) {
                  timer = Timer(record.voiceTime, () {
                    controller.reverse();
                  });
                });
              });
            } else {
              controller.reverse();
              await voiceRecoderProvider.playVoice(record.voicePath);
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(TimeUtil.convertDurationToString(record.voiceTime)),
              VoiceIcon(
                controller: controller,
              )
            ],
          ),
        );
      case CHATTYPE.IMAGE:
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VedioPage(
                      id: widget.id,
                      playData: record.videoPath,
                      coverData: record.picContent,
                    )));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: Image.file(
              File(record.picContent),
              width: record.imgWidth,
              height: record.imgHeight,
              fit: record.imgFitType,
            ),
          ),
        );
      case CHATTYPE.LOCATION:
        return Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  width: ScreenUtil().setWidth(400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(location ?? "",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      Text(
                        area ?? "",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(24),
                        ),
                      )
                    ],
                  ),
                ),
                Image.memory(
                  record.locPic,
                  width: ScreenUtil().setWidth(400),
                  height: ScreenUtil().setWidth(300),
                  fit: BoxFit.fitWidth,
                ),
              ],
            ));
      default:
        return Container();
    }
  }
}

class VoiceIcon extends StatefulWidget {
  final AnimationController controller;
  VoiceIcon({@required this.controller});
  @override
  _VoiceIconState createState() => _VoiceIconState();
}

class _VoiceIconState extends State<VoiceIcon>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedIcon(
        icon: AnimatedIcons.play_pause, progress: widget.controller);
  }
}
