import 'dart:io';
import 'dart:typed_data';

import 'package:amap_all_fluttify/amap_all_fluttify.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/Model/poiModel.dart';
import 'package:flutter_chat/Provider/signalRProvider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  final SignalRProvider signalRProvider;
  MapPage({this.signalRProvider});
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<String> poiStringList = [];
  List<PoiModel> pois = [];
  AmapController _controller;
  LatLng curL;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  searchPoi(LatLng latLng) async {
    final poiList = await AmapSearch.searchAround(latLng);
    Stream.fromIterable(poiList)
        .asyncMap((it) async {
          return PoiModel(
              address: await it.address,
              distance: await it.distance,
              title: await it.title,
              latitude: (await it.latLng).latitude,
              longitude: (await it.latLng).longitude);
        })
        .toList()
        .then((it) => setState(() {
              pois = it;
            }));
  }

//  listenLocation()async{
//    if (await requestPermission()) {
//    await for (final location in AmapLocation.listenLocation()) {
//      setState(() => _location = location);
//      print("location:$_location");
//    }
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(700),
                  child: AmapView(
                    // 地图类型 (可选)
                    mapType: MapType.Standard,
                    // 是否显示缩放控件 (可选)
                    showZoomControl: true,
                    // 是否显示指南针控件 (可选)
                    showCompass: true,
                    // 是否显示比例尺控件 (可选)
                    showScaleControl: true,
                    // 是否使能缩放手势 (可选)
                    zoomGesturesEnabled: true,
                    // 是否使能滚动手势 (可选)
                    scrollGesturesEnabled: true,
                    // 是否使能旋转手势 (可选)
                    rotateGestureEnabled: true,
                    // 是否使能倾斜手势 (可选)
                    tiltGestureEnabled: true,
                    // 缩放级别 (可选)
                    zoomLevel: 16,
                    // 中心点坐标 (可选)
                    // centerCoordinate: LatLng(29, 116),
                    // 标记 (可选)
                    markers: <MarkerOption>[],
                    // 标识点击回调 (可选)
                    onMarkerClicked: (Marker marker) {},
                    // 地图点击回调 (可选)
                    onMapClicked: (LatLng coord) async {
                      await _controller.clearMarkers();
                      await _controller.addMarker(MarkerOption(latLng: coord));
                      await _controller.setCenterCoordinate(
                          coord.latitude, coord.longitude);
                      curL = LatLng(coord.latitude, coord.longitude);
                      await searchPoi(coord);
                    },
                    // 地图拖动回调 (可选)
                    onMapMoveStart: (move) {},
                    onMapMoveEnd: (end) {},
                    // 地图创建完成回调 (可选)
                    onMapCreated: (controller) async {
                      _controller = controller;
                      // requestPermission是权限请求方法, 需要你自己实现
                      // 如果不知道怎么处理, 可以参考example工程的实现, example过程依赖了`permission_handler`插件.
                      if (await requestPermission()) {
                        await controller.showMyLocation(true);
                        LatLng latLng = await controller.getLocation();
                        curL = latLng;
                        await searchPoi(latLng);
                      }
                    },
                  ),
                ),
                Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                        icon: Icon(
                          Icons.loyalty,
                          size: 32,
                          color: Colors.indigo,
                        ),
                        onPressed: () async {
                          await _controller.showMyLocation(
                            true,
                          );
                          LatLng latLng = await _controller.getLocation();
                          curL = latLng;
                          searchPoi(latLng);
                        })),
                Positioned(
                    top: 10,
                    right: 10,
                    child: RaisedButton(
                        child: Text('发送'),
                        color: Colors.green[300],
                        onPressed: () async {
                          Poi poi = (await AmapSearch.searchAround(curL)).first;
                          Uint8List v;
                          await _controller.screenShot((data) {
                            v = data;
                            widget.signalRProvider.addLocationChat(v, poi);
                            Navigator.of(context).pop();
                          });
                        })),
              ],
            ),
            buildPoiList()
          ],
        ),
      ),
    );
  }

  Widget buildPoiList() {
    return Expanded(
        child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemCount: pois.length,
            itemBuilder: (_, index) {
              return InkWell(
                onTap: () async {
                  await _controller.clearMarkers();
                  await _controller.setCenterCoordinate(
                      pois[index].latitude, pois[index].longitude);
                  await _controller.addMarker(MarkerOption(
                      widget: Row(children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.redAccent,
                        ),
                        Text(pois[index].title)
                      ]),
                      latLng:
                          LatLng(pois[index].latitude, pois[index].longitude)));
                  curL = LatLng(pois[index].latitude, pois[index].longitude);
                  await searchPoi(
                      LatLng(pois[index].latitude, pois[index].longitude));
                },
                child: Container(
                  height: ScreenUtil().setHeight(100),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(10),
                                right: ScreenUtil().setWidth(20)),
                            child: Icon(
                              Icons.location_on,
                              color: Colors.redAccent,
                            )),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                pois[index].title,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(32),
                                ),
                              ),
                              Text(
                                pois[index].address == ""
                                    ? "暂无"
                                    : pois[index].address,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: ScreenUtil().setSp(22),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Text(
                            "${pois[index].distance.toString()}米",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(29),
                            ),
                          ),
                        ),
                      ]),
                ),
              );
            }));
  }

  Future<bool> requestPermission() async {
    final permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.location]);

    if (permissions[PermissionGroup.location] == PermissionStatus.granted) {
      return true;
    } else {
      BotToast.showText(
          text: "需要定位权限",
          textStyle: TextStyle(fontSize: 12, color: Colors.white));
      return false;
    }
  }
}

// class PoiList extends StatefulWidget {
//   final AmapController controller;
//   PoiList({this.controller});
//   @override
//   _PoiListState createState() => _PoiListState();
// }

// class _PoiListState extends State<PoiList> {
//   List<String> poiStringList = [];
//   List<PoiModel> pois = [];
//   @override
//   void initState() {
//     super.initState();
//     searchPoi();
//   }

//   searchPoi() async {
//     final poiList = await AmapSearch.searchAround(widget.curL);
//     Stream.fromIterable(poiList)
//         .asyncMap((it) async {
//           return PoiModel(
//               address: await it.address,
//               distance: await it.distance,
//               title: await it.title,
//               latitude: (await it.latLng).latitude,
//               longitude: (await it.latLng).longitude);
//         })
//         .toList()
//         .then((it) => setState(() {
//               pois = it;
//             }));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//         separatorBuilder: (BuildContext context, int index) => Divider(),
//         itemCount: pois.length,
//         itemBuilder: (_, index) {
//           return InkWell(
//             onTap: () {
//               widget.controller.setCenterCoordinate(
//                   pois[index].latitude, pois[index].longitude);
//             },
//             child: Container(
//               height: ScreenUtil().setHeight(100),
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Container(
//                         margin: EdgeInsets.only(
//                             left: ScreenUtil().setWidth(10),
//                             right: ScreenUtil().setWidth(20)),
//                         child: Icon(
//                           Icons.location_on,
//                           color: Colors.redAccent,
//                         )),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: <Widget>[
//                           Text(
//                             pois[index].title,
//                             style: TextStyle(
//                               fontSize: ScreenUtil().setSp(32),
//                             ),
//                           ),
//                           Text(
//                             pois[index].address == ""
//                                 ? "暂无"
//                                 : pois[index].address,
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: ScreenUtil().setSp(22),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(right: 12.0),
//                       child: Text(
//                         "${pois[index].distance.toString()}米",
//                         style: TextStyle(
//                           fontSize: ScreenUtil().setSp(29),
//                         ),
//                       ),
//                     ),
//                   ]),
//             ),
//           );
//         });
//   }
// }
