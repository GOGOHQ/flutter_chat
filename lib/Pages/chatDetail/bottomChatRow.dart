import 'dart:convert';

import 'dart:io';

import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_chat/Common/staticMembers.dart';
import 'package:flutter_chat/Pages/chatDetail/sendButton.dart';
import 'package:flutter_chat/Provider/bottomRowAnimaProvider.dart';
import 'package:flutter_chat/Provider/chooseFileProvider.dart';
import 'package:flutter_chat/Provider/signalRProvider.dart';
import 'package:flutter_chat/Provider/voiceRecoderProvider.dart';
import 'package:flutter_chat/Provider/xfVoiceProvider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';

import 'extendBottomRow.dart';

class BottomChatRow extends StatefulWidget {
  final SignalRProvider signalRprovider;
  final VoiceRecoderProvider voiceRecoderProvider;
  final XFVoiceProvider xfVoiceProvider;
  final BottomRowAnimProvider bottomRowAnimProvider;
  BottomChatRow({
    @required this.xfVoiceProvider,
    @required this.signalRprovider,
    @required this.bottomRowAnimProvider,
    @required this.voiceRecoderProvider,
  });

  @override
  _BottomChatRowState createState() => _BottomChatRowState();
}

class _BottomChatRowState extends State<BottomChatRow>
    with SingleTickerProviderStateMixin {
  TextEditingController txtController = TextEditingController();
  Animation<double> paddingAnimation;

  DateTime startTime;
  DateTime endTime;
  int textNum = 0;
  bool isVoiceRow = false;

  @override
  void initState() {
    txtController.addListener(() {
      setState(() {
        textNum = txtController.text.length;
      });
    });
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(
                right: ScreenUtil().setWidth(20.0),
              ),
              width: ScreenUtil.screenWidth,
              color: Colors.grey[100],
              height: ScreenUtil().setWidth(100.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildStartVoiceIcon(),
                    Expanded(child: buildInputOrRecord(widget.xfVoiceProvider)),
                    Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(15.0)),
                        child: GestureDetector(child: Icon(Icons.face))),
                    textNum > 0 && !isVoiceRow
                        ? SendButton(
                            txtController: txtController,
                            signalRProvider: widget.signalRprovider,
                          )
                        : GestureDetector(
                            child: Icon(Icons.add_circle_outline),
                            onTap: () {
                              widget.bottomRowAnimProvider.runAnimation();
                            },
                          ),
                    // ChannelTTVWatcher(xfVoiceProvider: xfVoiceProvider),
                    // ChannelVTTWatcher(xfVoiceProvider: xfVoiceProvider)
                  ])),
          MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => ChooseFileProvider())
              ],
              child: ExtendBottomRow(
                bottomRowAnimProvider: widget.bottomRowAnimProvider,
                signalRProvider: widget.signalRprovider,
              ))
        ],
      ),
    );
  }

  Widget buildInputOrRecord(XFVoiceProvider xF) {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 200),
      crossFadeState: widget.voiceRecoderProvider.ifVoiceRecord
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      firstChild: buildInput(),
      secondChild: buildVoiceRecord(xF),
    );
  }

  // runXFVoiceVTT(
  //     XFVoiceProvider xF, cmdMp3, cmdPcm, resultPath, origPath, mp3Path) async {
  //   await NativeTool.ffmpegConverter(cmdMp3);
  //   await NativeTool.ffmpegConverter(cmdPcm);
  //   // File(origPath).delete();
  //   print("resultPath:$resultPath");
  //   File(mp3Path).delete();
  //   var bytes = File(resultPath).readAsBytesSync();
  //   xF.convertVoiceToText("5e43ae7f", bytes);
  // }

  Widget buildVoiceRecord(XFVoiceProvider xF) {
    SignalRProvider sR = widget.signalRprovider;
    VoiceRecoderProvider vR = widget.voiceRecoderProvider;

    return IgnorePointer(
      ignoring: !vR.canTap,
      child: GestureDetector(
        onTapDown: (result) {
          vR.startRecord();
          startTime = DateTime.now();
        },
        onTapUp: (result) async {
          endTime = DateTime.now();
          Duration playTime = endTime.difference(startTime);
          if (playTime.inSeconds == 0) {
            BotToast.showText(
                text: "按键时间太短,再试试",
                textStyle: TextStyle(fontSize: 12, color: Colors.white));
            vR.cancelRecord();
          } else {
            await vR.stopRecord();
            vR.uploadVoice(sR, playTime);
            // xF.initChannelVTT();
            // convertVoice(vR, xF);

            // resultPath = resultPath.replaceAll(MEDIATYPE.MP4, MEDIATYPE.PCM);
            // mp3Path = mp3Path.replaceAll(MEDIATYPE.MP4, MEDIATYPE.MP3);
            // String cmdMP3 = NativeTool.cmdForRecordToMp3(vR.filePath, mp3Path);
            // String cmdPcm = NativeTool.cmdForRecordToPCM(mp3Path, resultPath);
            // runXFVoiceVTT(cmdMP3, cmdPcm, resultPath, vR.filePath, mp3Path);
            sR.addVoiceChat(
                voiceTime: playTime,
                voicePath: vR.filePath,
                sender: SENDER.SELF);
            sR.scrollToEnd();
          }
        },
        onTapCancel: () {
          vR.cancelRecord();
        },
        child: Container(
            alignment: Alignment.center,
            width: ScreenUtil().setWidth(530),
            height: ScreenUtil().setHeight(100),
            margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(12.0)),
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(5.0)),
            decoration: BoxDecoration(
                color: vR.taping ? Colors.grey : Colors.white,
                borderRadius: BorderRadius.circular(5.0)),
            child: Text(
                widget.voiceRecoderProvider.taping ? '松开 已完成' : '长按 请说话',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(32),
                    color: vR.taping ? Colors.white : Colors.grey))),
      ),
    );
  }

  // void convertVoice(VoiceRecoderProvider vR, XFVoiceProvider xF) {
  //   String resultPath = vR.filePath;
  //   String mp3Path = vR.filePath;
  //   if (Platform.isIOS) {
  //     resultPath = resultPath.replaceAll(MEDIATYPE.M4A, MEDIATYPE.PCM);
  //     mp3Path = mp3Path.replaceAll(MEDIATYPE.M4A, MEDIATYPE.MP3);
  //   } else {
  //     resultPath = resultPath.replaceAll(MEDIATYPE.MP4, MEDIATYPE.PCM);
  //     mp3Path = mp3Path.replaceAll(MEDIATYPE.MP4, MEDIATYPE.MP3);
  //   }
  //   print("resultPath$resultPath");
  //   String cmdMP3 = NativeTool.cmdForRecordToMp3(vR.filePath, mp3Path);
  //   String cmdPCM = NativeTool.cmdForRecordToPCM(mp3Path, resultPath);
  //   runXFVoiceVTT(xF, cmdMP3, cmdPCM, resultPath, vR.filePath, mp3Path);
  // }

  Widget buildInput() {
    return IgnorePointer(
      ignoring: !widget.voiceRecoderProvider.canTap,
      child: Container(
          margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(12.0)),
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(5.0)),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
          child: Material(
            color: Colors.white,
            child: TextField(
              cursorWidth: 0,
              decoration: InputDecoration(
                suffixIcon: textNum > 0
                    ? IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          txtController.clear();
                        })
                    : Container(),
                contentPadding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(5),
                    top: ScreenUtil().setWidth(12.0)),
                border: InputBorder.none,
              ),
              autocorrect: false,
              controller: txtController,
            ),
          )),
    );
  }

  Container buildStartVoiceIcon() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15.0)),
        child: AnimatedCrossFade(
            firstChild: GestureDetector(
              onTap: () {
                setState(() {
                  isVoiceRow = true;
                });
                widget.voiceRecoderProvider.updateVoiceRecord();
              },
              child: Transform.rotate(
                angle: pi / 2,
                child: Icon(Icons.wifi),
              ),
            ),
            secondChild: GestureDetector(
                onTap: () {
                  setState(() {
                    isVoiceRow = false;
                  });
                  widget.voiceRecoderProvider.updateVoiceRecord();
                },
                child: Icon(Icons.keyboard)),
            crossFadeState: widget.voiceRecoderProvider.ifVoiceRecord
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 200)));
  }
}

// class ChannelVTTWatcher extends StatefulWidget {
//   final XFVoiceProvider xfVoiceProvider;
//   ChannelVTTWatcher({this.xfVoiceProvider});

//   @override
//   _ChannelVTTWatcherState createState() => _ChannelVTTWatcherState();
// }

// class _ChannelVTTWatcherState extends State<ChannelVTTWatcher> {
//   XFVoiceProvider xfVoiceProvider;
//   @override
//   void initState() {
//     xfVoiceProvider = widget.xfVoiceProvider;

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var channel = xfVoiceProvider.channelVTT;
//     if (channel == null && channel.stream == null) {
//       print("isnul");
//     }
//     return (channel == null && channel.stream == null)
//         ? Text('rwerwr')
//         : StreamBuilder(
//             stream: channel.stream,
//             builder: (BuildContext context, AsyncSnapshot snapshot) {
//               if (snapshot.hasData) {
//                 print("hasdatafwaraaaaaaaaaaaaa");
//               }
//               return Container(
//                 child: Text('rwqr'),
//               );
//             });
//   }
// }

// class ChannelTTVWatcher extends StatefulWidget {
//   final XFVoiceProvider xfVoiceProvider;
//   ChannelTTVWatcher({this.xfVoiceProvider});
//   @override
//   _ChannelTTVWatcherState createState() => _ChannelTTVWatcherState();
// }

// class _ChannelTTVWatcherState extends State<ChannelTTVWatcher> {
//   XFVoiceProvider xfVoiceProvider;
//   String fileStream = "";
//   List<int> fileIntList = List<int>();
//   String path;
//   bool ifAdded = false;
//   @override
//   void initState() {
//     xfVoiceProvider = widget.xfVoiceProvider;
//     initAsync();
//     super.initState();
//   }

//   initAsync() async {
//     // getDownloadsDirectory()
//     path = (await getExternalStorageDirectory()).path;
//   }

//   @override
//   Widget build(BuildContext context) {
//     var channel = xfVoiceProvider.channelTTV;
//     if (channel == null && channel.stream == null) {
//       print("isnul");
//     }
//     return (channel == null && channel.stream == null)
//         ? Text('rwerwr')
//         : StreamBuilder(
//             stream: channel.stream,
//             builder: (BuildContext context, AsyncSnapshot snapshot) {
//               if (snapshot.hasData) {
//                 print("hasdata");
//                 var result = jsonDecode(snapshot.data);
//                 fileStream = result["data"]["audio"].toString();
//                 fileIntList.addAll(base64.decode(fileStream));
//                 if (result["data"]["status"] == 2) {
//                   print("finish");
//                   // String docPath = widget.docPath;
//                   // 延迟两秒再写 这时候分段的数据全部已经到达
//                   String filePath =
//                       p.join(path, Uuid().v4().toString() + ".pcm");
//                   print(filePath);
//                   print("ifAdded:${ifAdded}");
//                   Future.delayed(Duration(seconds: 2)).then((_) {
//                     if (!ifAdded) {
//                       ifAdded = true;
//                       File file = File(filePath);
//                       file.writeAsBytesSync(fileIntList);
//                       // widget.signalR.addVoiceFromXF(filePath);
//                       // }
//                     }
//                   });
//                 }
//               }
//               return Container();
//             });
//   }
// }
