// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sendMsgTemplate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMsgTemplate _$SendMsgTemplateFromJson(Map<String, dynamic> json) {
  return SendMsgTemplate(
    toWho: json['toWho'] as String,
    message: json['message'] as String,
    fromWho: json['fromWho'] as String,
    voiceLength: json['voiceLength'] as int,
    avatarUrl: json['avatarUrl'] as String,
    makerName: json['makerName'] as String,
  );
}

Map<String, dynamic> _$SendMsgTemplateToJson(SendMsgTemplate instance) =>
    <String, dynamic>{
      'fromWho': instance.fromWho,
      'message': instance.message,
      'toWho': instance.toWho,
      'voiceLength': instance.voiceLength,
      'avatarUrl':instance.avatarUrl,
      'makerName':instance.makerName
    };
