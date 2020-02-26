import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat/Utils/nativeUtil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

class ChooseFileProvider with ChangeNotifier {
  String filePath;
  String compressedImagePath;
  String tempImgFolder;
  String origPath;
  ChooseFileProvider() {
    getTempFolderPath();
  }

  updateFilePath(String choosedFilePath) {
    filePath = choosedFilePath;
    notifyListeners();
  }

  genTempOrigPath() {
    String fileId = Uuid().v4().toString();
    String result = p.join(tempImgFolder, "$fileId.mp4");
    return result;
  }

  runFFMpeg(String cmd) async {
    await NativeTool.ffmpegConverter(cmd);
  }

  genTempFramePath() {
    String fileId = Uuid().v4().toString();
    String result = p.join(tempImgFolder, "$fileId.jpg");
    return result;
  }

  genTempMp4Path() {
    String fileId = Uuid().v4().toString();
    String result = p.join(tempImgFolder, "$fileId.mp4");
    return result;
  }

  getTempFolderPath() async {
    var folder = await getExternalStorageDirectory();
    tempImgFolder = "${folder.path}/tempVideoFrames/";
    if (!await Directory(tempImgFolder).exists()) {
      await Directory(tempImgFolder).create(recursive: true);
    }
    notifyListeners();
  }

  updateCompressedImagePath(String imagePath) {
    compressedImagePath = imagePath;
    notifyListeners();
  }
}
