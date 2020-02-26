import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat/Common/staticMembers.dart';
import 'package:flutter_chat/Pages/mapPage/gaodeMapPage.dart';
import 'package:flutter_chat/Provider/bottomRowAnimaProvider.dart';
import 'package:flutter_chat/Provider/chooseFileProvider.dart';
import 'package:flutter_chat/Provider/signalRProvider.dart';
import 'package:flutter_chat/Widgets/extendsOption.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'chatDetail.dart';

class ExtendBottomRow extends StatelessWidget {
  final BottomRowAnimProvider bottomRowAnimProvider;
  final SignalRProvider signalRProvider;
  ExtendBottomRow({this.bottomRowAnimProvider, this.signalRProvider});
  @override
  Widget build(BuildContext context) {
    ChooseFileProvider chooseFileProvider =
        Provider.of<ChooseFileProvider>(context);
    return Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(15.0)),
        decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border(top: BorderSide(width: 1, color: Colors.grey[300]))),
        width: ScreenUtil.screenWidth,
        height: bottomRowAnimProvider.bottomSheetHeight,
        child: Wrap(
          spacing: ScreenUtil().setWidth(30),
          children: <Widget>[
            SendPicOption(
              signalRProvider: signalRProvider,
              chooseFileProvider: chooseFileProvider,
            ),
            SendLocationOption(
              signalRProvider: signalRProvider,
            )
          ],
        ));
  }
}

class SendPicOption extends StatelessWidget {
  final SignalRProvider signalRProvider;
  final ChooseFileProvider chooseFileProvider;
  SendPicOption({this.chooseFileProvider, this.signalRProvider});
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: GestureDetector(
            onTap: () async {
              final file =
                  await ImagePicker.pickVideo(source: ImageSource.gallery);
              if (file == null) {
                return;
              }
              String filePath = file.path;
              chooseFileProvider.updateFilePath(filePath);
              String resultFrameImage = chooseFileProvider.genTempFramePath();
              String origPath = chooseFileProvider.genTempOrigPath();
              String tempMp4File = chooseFileProvider.genTempMp4Path();
              String cmd =
                  '-i $filePath -f image2 -ss 00:00:00 -vframes 1 $resultFrameImage';
              await chooseFileProvider.runFFMpeg(cmd);
              var imgFile = File(resultFrameImage);
              var bytes = imgFile.readAsBytesSync();
              var sth = await decodeImageFromList(bytes);
              var height = sth.height.toDouble();
              var width = sth.width.toDouble();
              double ratio = width / height;
              double maxRatio = 3;
              double minRatio = 1 / 3;
              double maxWidth = 300 * ScreenUtil().scaleWidth;
              double maxHeight = ScreenUtil().setHeight(350);
              BoxFit fitType;
              if (ratio >= maxRatio) {
                fitType = BoxFit.fitHeight;
                double scale = height / maxHeight;
                height = height / scale;
                width = height * maxRatio / scale;
              } else if (ratio <= maxRatio && ratio >= 1) {
                fitType = BoxFit.fitWidth;
                double scale = width / maxWidth;
                height = height / scale;
                width = width / scale;
              } else if (ratio >= minRatio && ratio < 1) {
                fitType = BoxFit.fitHeight;
                double scale = height / maxWidth;
                height = height / scale;
                width = width / scale;
              } else {
                fitType = BoxFit.fitWidth;
                double scale = width / maxWidth;
                height = height / scale;
                width = width / scale;
              }

              signalRProvider.addPicChat(
                sender: SENDER.SELF,
                imgHeight: height,
                imgWidth: width,
                fitType: fitType,
                vedioPath: filePath,
                picContent: resultFrameImage,
              );
            },
            child: ExtendOption(
              text: '相册',
              icon: Icons.photo_size_select_actual,
            )));
  }
}

class SendLocationOption extends StatelessWidget {
  final SignalRProvider signalRProvider;
  final ChooseFileProvider chooseFileProvider;
  SendLocationOption({this.chooseFileProvider, this.signalRProvider});
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: GestureDetector(
            onTap: () async {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MapPage(
                        signalRProvider: signalRProvider,
                      )));
            },
            child: ExtendOption(
              text: '位置',
              icon: Icons.location_on,
            )));
  }
}
