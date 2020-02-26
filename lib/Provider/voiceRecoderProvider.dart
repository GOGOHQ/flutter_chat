import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_chat/Common/staticMembers.dart';
import 'package:flutter_chat/Provider/signalRProvider.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_sound/android_encoder.dart';
import '../http/http_request.dart';

class VoiceRecoderProvider extends ChangeNotifier {
  FlutterSound flutterSound;

  String fileName;
  String fulFileName;
  bool canTap = true;
  bool taping;
  String filePath;
  bool ifVoiceRecord;

  int recordStatus;
  double voice = 0.0;
  StreamSubscription voiceSubscription;
  VoiceRecoderProvider() {
    flutterSound = FlutterSound();
    flutterSound.setDbLevelEnabled(true);
    flutterSound.setDbPeakLevelUpdate(0.5);
    ifVoiceRecord = false;
    taping = false;

    recordStatus = RECORDSTATUS.NOT_STARTED;
  }
  //播放语音
  playVoice(filePath) async {
    bool isPlay = flutterSound.isPlaying;
    if (isPlay) {
      await flutterSound.stopPlayer();
    } else {
      await flutterSound.startPlayer(filePath);
    }
    notifyListeners();
  }

  //改变录制状态
  updateVoiceRecord() {
    ifVoiceRecord = !ifVoiceRecord;
    notifyListeners();
  }

  uploadVoice(SignalRProvider sRProvider, Duration playTime) async {
    await HttpRequest.upload("http://192.168.0.106:5000/upload/uploadFiles",
        filePath, fulFileName, sRProvider.connId,
        noBaseUrl: true);
    await sRProvider.notifyVoice(fileName, playTime);
    this.canTap = true;
    notifyListeners();
  }

  //暂停录制
  stopRecord({bool ifBreak = false}) async {
    taping = false;
    if (ifBreak) {
      recordStatus = RECORDSTATUS.BREAK;
    } else {
      recordStatus = RECORDSTATUS.END;
    }
    if (flutterSound.isRecording) {
      await flutterSound.stopRecorder();
    }
    canTap = true;
    notifyListeners();
  }

  //取消录制
  cancelRecord() async {
    canTap = false;
    notifyListeners();
    taping = false;
    Timer(Duration(seconds: 1), () async {
      if (flutterSound.isRecording) {
        await flutterSound.stopRecorder().then((_) {
          canTap = true;
          notifyListeners();
        });
      }
    });
    recordStatus = RECORDSTATUS.CANCEL;
    if (File(filePath).existsSync()) {
      File(filePath).delete();
    }
    notifyListeners();
  }

  //开始录制
  startRecord() async {
    taping = true;
    recordStatus = RECORDSTATUS.START;
    fileName = Uuid().v4().toString();
    String fileType = MEDIATYPE.MP4;
    fulFileName = fileName + fileType;
    String path = (await getExternalStorageDirectory()).path;
    Future<String> result = flutterSound.startRecorder(
        uri: path + fulFileName, androidEncoder: AndroidEncoder.AMR_NB);
    result.then((path) {
      print('startRecorder: $path');
      filePath = path;
      print("filePath:${filePath}");
      voiceSubscription = flutterSound.onRecorderDbPeakChanged.listen((value) {
        if (value != null) {
          voice = value;
          print(voice);
          notifyListeners();
        }
      });
      this.ifVoiceRecord = true;
      this.canTap = false;
      // uploadPath = path.replaceAll("file://", ""); //filepath 只是最后一层，不包括文件夹目录
      notifyListeners();
    });
  }
}
