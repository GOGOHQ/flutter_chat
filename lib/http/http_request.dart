import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:convert';

class HttpRequest {
  static Dio dio =
      Dio(BaseOptions(connectTimeout: 500000, receiveTimeout: 3000000));

  static String baseUrl = 'http://192.168.0.106:8080';

  static Future<dynamic> get(String uri,
      {Map<String, dynamic> queryParameters, noBaseUrl: false}) async {
    Options op = new Options();
    try {
      Response response = await dio.get(noBaseUrl ? uri : baseUrl + uri,
          queryParameters: queryParameters, options: op);
      final statusCode = response.statusCode;
      final responseBody = response.data;
      print('[uri=$uri][statusCode=$statusCode]');
      // print('[uri=$uri][statusCode=$statusCode][response=$responseBody]');
      return responseBody;
    } on Exception catch (e) {
      print('[uri=$uri]exception e=${e.toString()}');
      return null;
    }
  }

  static Future<dynamic> post(String uri, dynamic body,
      {noBaseUrl: false, Map<String, dynamic> querys}) async {
    Options op = new Options();

    try {
      final putData = jsonEncode(body);
      Response response = await dio.post(noBaseUrl ? uri : baseUrl + uri,
          data: putData, options: op, queryParameters: querys);
      final statusCode = response.statusCode;
      final responseBody = response.data;
      print('[uri=$uri][statusCode=$statusCode]');
      // print('[uri=$uri][statusCode=$statusCode][response=$responseBody]');
      return responseBody;
    } on Exception catch (e) {
      print('[uri=$uri]exception e=${e.toString()}');
      return null;
    }
  }

  static Future<dynamic> upload(
      String uri, String filePath, String fileName, String sender,
      {noBaseUrl: false}) async {
    Options op = new Options();

    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath),
        "name": fileName,
        "sender": sender
      });
      Response response = await dio.post(noBaseUrl ? uri : baseUrl + uri,
          data: formData, options: op);
      final statusCode = response.statusCode;
      final responseBody = response.data;
      print('[uri=$uri][statusCode=$statusCode]');
      // print('[uri=$uri][statusCode=$statusCode][response=$responseBody]');
      return responseBody;
    } on Exception catch (e) {
      print('[uri=$uri]exception e=${e.toString()}');
      return null;
    }
  }
}
