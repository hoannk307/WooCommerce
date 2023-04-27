// Copyright (c) 2023, WooSignal Ltd.
// All rights reserved.
//
// Redistribution and use in source and binary forms are permitted
// provided that the above copyright notice and this paragraph are
// duplicated in all such forms and that any documentation,
// advertising materials, and other materials related to such
// distribution and use acknowledge that the software was developed
// by the WooSignal. The name of the
// WooSignal may not be used to endorse or promote products derived
// from this software without specific prior written permission.
// THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:device_info_plus/device_info_plus.dart';
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';
import './shared_pref.dart';
import 'dart:io' show Platform;
import "dart:core";

class ApiProvider {
  late Dio _dio;
  late final String _version;
  Map<String, dynamic> _deviceMeta = {};

  String url = "";
  String consumerKey = "ck_f57ead1743b7b24757aa19b6918ab9f32920a353";
  String consumerSecret = "cs_0a56873b3a8b0279d26382223adc427168f551c2";

  /// Set the device meta
  Future<void> setDeviceMeta() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    String? uuid = await getUUID();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      _deviceMeta = {
        "model": androidDeviceInfo.device,
        "brand":
            androidDeviceInfo.brand.replaceAll(RegExp('[^\u0001-\u007F]'), '_'),
        "manufacturer": androidDeviceInfo.manufacturer,
        "version": androidDeviceInfo.version.sdkInt.toString(),
        "uuid": uuid,
        "platform_type": "android",
        "api_version": "$_version/v3"
      };
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      _deviceMeta = {
        "model": iosDeviceInfo.model,
        "brand":
            iosDeviceInfo.name?.replaceAll(RegExp('[^\u0001-\u007F]'), '_'),
        "manufacturer": "Apple",
        "version": iosDeviceInfo.systemVersion,
        "uuid": uuid,
        "platform_type": "ios",
        "api_version": "$_version/v3"
      };
    }
  }

  /// set the FCM token
  void setFcmToken(String token) {
    if (_deviceMeta.containsKey('fcm_token')) {
      _deviceMeta['fcm_token'] = token;
    } else {
      _deviceMeta.addAll({"fcm_token": token});
    }
    _setDioHeaders();
  }

  /// Init Dio class
  _initDio() {
    BaseOptions options =
        BaseOptions(baseUrl: "https://magicskin.com.vn/wp-json/wc/v3/");
    _dio = Dio(options);
  }

  /// Set the http headers for Dio
  _setDioHeaders() {
    _dio.options.headers = {
      "Content-Type": "application/json",
      //"X-DMETA": json.encode(_deviceMeta).toString()
    };
  }

  /// Constructor requires a [appKey] from WooSignal
  ApiProvider({required String version}) : _version = version;

  /// Initialize class
  Future init() async {
    _initDio();
    //await setDeviceMeta();
    await _setDioHeaders();
  }

  /// Print to the console with a [log] response
  void _printLog(String log) {
    print("WOOSIGNAL LOG: $log");
  }

  String authenURL(url) {
    bool containsQueryParams = url.toString().contains("?");
    return url +
        (containsQueryParams == true
            ? "&consumer_key=$consumerKey&consumer_secret=this.consumerSecret"
            : "?consumer_key=$consumerKey&consumer_secret=$consumerSecret");
  }

  /// HTTP POST request using a [url] and [data] payload
  Future<dynamic> post(url, data) async {
    url = authenURL(url);
    try {
      Response response =
          await _dio.post(url, data: {"data": json.encode(data)});
      return response.data;
    } catch (error, stacktrace) {
      _printLog("$error stackTrace: $stacktrace");
      return null;
    }
  }

  /// HTTP GET request using a [url]
  Future<dynamic> get(url, data) async {
    url = authenURL(url);
    try {
      Response response = await _dio.get(url, queryParameters: data);
      return response.data;
    } catch (error, stacktrace) {
      _printLog("$error stackTrace: $stacktrace");
      return null;
    }
  }
}
