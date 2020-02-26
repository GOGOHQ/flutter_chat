import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'package:amap_all_fluttify/amap_all_fluttify.dart';
import 'package:dio/dio.dart';
import 'package:flutter_chat/Common/staticMembers.dart';
import 'package:flutter_chat/Model/sendMsgTemplate.dart';
import 'package:flutter_chat/Pages/chatDetail/chatDetail.dart';
import 'package:flutter_chat/http/http_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_client/signalr_client.dart';
import 'package:path_provider/path_provider.dart';

class SignalRProvider with ChangeNotifier {
  HubConnection conn;
  String connId;
  List<ChatRecord> records;
  ScrollController scrollController;
  String avatar1 =
      "https://pic1.zhimg.com/v2-f8c95bf6807a3773eb5679aae2892960_is.jpg";
  String avatar2 =
      "https://pic2.zhimg.com/v2-bd46162e4c96d4046ec27a7cf48536cb_is.jpg";

  //初始化
  SignalRProvider() {
    scrollController = ScrollController();
    records = List<ChatRecord>();
    // records.add(ChatRecord(
    //     avatarUrl: avatar1,
    //     content: "hello",
    //     sender: 0,
    //     chatType: CHATTYPE.TEXT));
    // records.add(ChatRecord(
    //     avatarUrl: avatar2, content: "你好", sender: 1, chatType: CHATTYPE.TEXT));
    // records.add(ChatRecord(
    //     avatarUrl: avatar1,
    //     content: "吃了吗",
    //     sender: 0,
    //     chatType: CHATTYPE.TEXT));
    // records.add(ChatRecord(
    //     avatarUrl: avatar2, content: "吃了", sender: 1, chatType: CHATTYPE.TEXT));
    conn = HubConnectionBuilder()
        .withUrl("http://192.168.0.106:5000/chatHub",
            options: HttpConnectionOptions())
        .build();
    conn.start();

    //下载服务器语音
    conn.on("receiveVoice", (message) async {
      String downloadPath = "http://192.168.0.106:5000/voiceTemp/" +
          message.first.toString() +
          ".mp3";
      String savePath = (await getTemporaryDirectory()).path +
          message.first.toString() +
          ".mp3";
      await HttpRequest.dio.download(downloadPath, savePath);
      addVoiceChat(
          voiceTime: Duration(seconds: int.parse(message[1].toString())),
          voicePath: savePath,
          sender: SENDER.OTHER);
      scrollController.animateTo(
          scrollController.position.maxScrollExtent +
              ScreenUtil().setWidth(300),
          duration: Duration(milliseconds: 300),
          curve: Curves.ease);
      notifyListeners();
    });

    //接受连接id
    conn.on("receiveConnId", (message) {
      connId = message.first.toString();
      print("conID:${connId}");
      notifyListeners();
    });

    //接收消息
    conn.on("receiveMsg", (message) {
      addTextChat(message.first.toString());
      notifyListeners();
    });
  }

  scrollToEnd() {
    scrollController.animateTo(
        scrollController.position.maxScrollExtent + ScreenUtil().setWidth(300),
        duration: Duration(milliseconds: 300),
        curve: Curves.ease);
  }

  //增加音频消息记录
  addVoiceChat({Duration voiceTime, String voicePath, int sender}) {
    records.add(ChatRecord(
        sender: sender,
        chatType: CHATTYPE.VOICE,
        avatarUrl: avatar1,
        voiceTime: voiceTime,
        voicePath: voicePath));
    notifyListeners();
  }

  addPicChat(
      {int sender,
      String picContent,
      String vedioPath,
      double imgWidth,
      double imgHeight,
      BoxFit fitType}) {
    records.add(ChatRecord(
        chatType: CHATTYPE.IMAGE,
        imgFitType: fitType,
        imgWidth: imgWidth,
        avatarUrl: avatar1,
        imgHeight: imgHeight,
        picContent: picContent,
        videoPath: vedioPath,
        sender: SENDER.SELF));
    notifyListeners();
  }

  //增加文字消息记录
  addTextChat(String content) {
    records.add(ChatRecord(
        sender: 0,
        content: content,
        avatarUrl: avatar1,
        chatType: CHATTYPE.TEXT));
    notifyListeners();
  }

  //增加文字消息记录
  addLocationChat(Uint8List locPic, Poi poi) {
    records.add(ChatRecord(
        sender: 0,
        locPic: locPic,
        poi: poi,
        avatarUrl: avatar1,
        chatType: CHATTYPE.LOCATION));
    notifyListeners();
  }

  //发送消息
  sendMessage(msg) {
    conn.invoke("receiveMsgAsync", args: [
      jsonEncode(SendMsgTemplate(
              fromWho: connId,
              toWho: connId,
              message: msg,
              makerName: "郑慧",
              avatarUrl: avatar1)
          .toJson())
    ]);
    addTextChat(msg);
    notifyListeners();
  }

  notifyVoice(fileName, Duration playTime) async {
    conn.invoke("notifyVoice", args: [
      jsonEncode(SendMsgTemplate(
              fromWho: connId,
              toWho: connId,
              makerName: "郑慧",
              avatarUrl: avatar1,
              message: fileName,
              voiceLength: playTime.inSeconds)
          .toJson())
    ]);
  }
}
