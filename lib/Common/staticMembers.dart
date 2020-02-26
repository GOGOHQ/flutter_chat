import 'package:flutter/material.dart';

class RECORDSTATUS {
  static const int NOT_STARTED = -1; //尚未开始
  static const int START = 0; //录音开始
  static const int END = 1; //录音结束  抬起手
  static const int BREAK = 2; //语音中断
  static const int CANCEL = 3; //录音取消
}

class MEDIATYPE {
  static const String MP4 = ".mp4";
  static const String MP3 = ".mp3";
  static const String M4A = ".m4a";
  static const String PCM = ".pcm";
}

class CHATTYPE {
  static const int TEXT = 0;
  static const int VOICE = 1;
  static const int LOCATION = 2;
  static const int IMAGE = 3;
}

class SENDER {
  static const int SELF = 0;
  static const int OTHER = 1;
}

class THEMECOLORMAPPING {
  static const int BLUEGREY = 0;
  static const int RED = 1;
  static const int PURPLE = 2;
  static const int YELLOW = 3;
}

class THEMECOLOR {
  static const Color BLUEGREY = Colors.blueGrey;
  static const Color RED = Colors.redAccent;
  static const Color PURPLE = Colors.purpleAccent;
  static const Color YELLOW = Colors.yellowAccent;
}

class THEMEMODE {
  static const int DARK = 1;
  static const int LIGHT = 0;
}

var pageList = [
  PageModel(
      imageUrl: "images/splash/1.jpg",
      title: "MUSIC",
      body: "EXPERIENCE WICKED PLAYLISTS",
      titleGradient: gradients[0]),
  PageModel(
      imageUrl: "images/splash/2.jpg",
      title: "SPA",
      body: "FEEL THE MAGIC OF WELLNESS",
      titleGradient: gradients[1]),
  PageModel(
      imageUrl: "images/splash/3.jpg",
      title: "TRAVEL",
      body: "LET'S HIKE UP",
      titleGradient: gradients[2]),
];

List<List<Color>> gradients = [
  [Color(0xFF9708CC), Color(0xFF43CBFF)],
  [Color(0xFFE2859F), Color(0xFFFCCF31)],
  [Color(0xFF5EFCE8), Color(0xFF736EFE)],
];

class PageModel {
  var imageUrl;
  var title;
  var body;
  List<Color> titleGradient = [];
  PageModel({this.imageUrl, this.title, this.body, this.titleGradient});
}
