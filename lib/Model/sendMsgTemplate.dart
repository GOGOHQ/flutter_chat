import 'package:flutter_chat/Model/chatContentModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sendMsgTemplate.g.dart';

@JsonSerializable()
class SendMsgTemplate {
  String fromWho;
  String message;
  String toWho;
  int voiceLength;
  String makerName;
  String avatarUrl;

  SendMsgTemplate({this.toWho, this.message, this.fromWho, this.voiceLength,this.avatarUrl,this.makerName});

  factory SendMsgTemplate.fromJson(Map<String, dynamic> json) =>
      _$SendMsgTemplateFromJson(json);
  Map<String, dynamic> toJson() => _$SendMsgTemplateToJson(this);
}
