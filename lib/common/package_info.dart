
import 'package:flutter/services.dart';
import 'package:weather_flutter/common/config.dart';

class PackageInfo {

  static const MethodChannel _channel = MethodChannel('top.cyixle.weather.weather_flutter.plugin/package_info_plugin');

  static Future<int> versionCode() async {
    if (isAndroid) {
      int code =  (await _channel.invokeMethod('versionCode')) as int;
      return code;
    }
    return -1;
  }

  static Future<String> versionName() async {
    if (isAndroid) {
      String name = (await _channel.invokeMethod('versionName')) as String;
      return name;
    }
    return 'UnKnow';
  }

  static Future<String> package() async {
    if (isAndroid) {
      String package = (await _channel.invokeMethod('package')) as String;
      return package;
    }
    return 'UnKnow';
  }

  static Future<String> appName() async {
    if (isAndroid) {
      String appName = (await _channel.invokeMethod('appName')) as String;
      return appName;
    }
    return 'UnKnow';
  }
}