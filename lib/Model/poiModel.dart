import 'package:json_annotation/json_annotation.dart';

part 'poiModel.g.dart';
@JsonSerializable()

class PoiModel{
  int distance;
  String address;
  String title;
  double latitude;
  double longitude;

  PoiModel({
    this.latitude,this.longitude,this.address,this.distance,this.title
  });
    factory PoiModel.fromJson(Map<String, dynamic> json) =>
      _$PoiModelFromJson(json);
  Map<String, dynamic> toJson() => _$PoiModelToJson(this);
}