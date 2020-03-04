import 'dart:async';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:video_player/video_player.dart';

class VedioPage extends StatefulWidget {
  final String playData;
  final String coverData;

  final int id;
  VedioPage({this.coverData, this.playData, this.id});
  @override
  _VedioPageState createState() => _VedioPageState();
}

class _VedioPageState extends State<VedioPage> {
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;

  bool isShowVideo = false;
  @override
  void initState() {
    videoPlayerController = VideoPlayerController.file(File(widget.playData));
    videoPlayerController.initialize().then((_) {
      chewieController = ChewieController(
        allowFullScreen: false,
        allowMuting: false,
        looping: false,
        videoPlayerController: videoPlayerController,
        aspectRatio: videoPlayerController.value.aspectRatio,
        autoPlay: false,
      );
      setState(() {
        isShowVideo = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Hero(
        tag: widget.id,
        child: AnimatedOpacity(
            opacity: isShowVideo ? 1.0 : 0.0,
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeOut,

            ///将statusBar背景设为黑色，并且和视屏组合起来
            child: Stack(
              children: <Widget>[
                Container(
                    height: ScreenUtil.screenHeight,
                    child: isShowVideo
                        ? Chewie(
                            controller: chewieController,
                          )
                        : Image.file(File(widget.coverData))),
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }
}
