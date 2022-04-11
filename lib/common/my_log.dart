
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:weather_flutter/common/config.dart';

class MyLog {

  MyLog._();

  static bool isDebug = true;
  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

  static const MethodChannel _channel = MethodChannel('top.cyixlq.log_plugin/log_plugin');

  static v(String tag, String msg) {
    _printLog('v', tag, msg);
  }
  static d(String tag, String msg) {
    _printLog('d', tag, msg);
  }
  static i(String tag, String msg) {
    _printLog('i', tag, msg);
  }
  static w(String tag, String msg) {
    _printLog('w', tag, msg);
  }
  static e(String tag, String msg) {
    _printLog('e', tag, msg);
  }
  static wtf(String tag, String msg) {
    _printLog('wtf', tag, msg);
  }

  static Map<String, String> _createParams(String tag, String msg) {
    return {
      'tag': tag,
      'msg': msg
    };
  }

  static void _printLog(String level, String tag, String msg) {
    if (isDebug) {
      if (isAndroid) {
        _channel.invokeMethod(level, _createParams(tag, msg));
      } else {
        if (level == 'wtf') {
          level = 'E';
        } else {
          level = level.toUpperCase();
        }
        final now = DateTime.now();
        print('$now $level/$tag: $msg');
      }
    }
  }

  static void printJson(String tag, Object msg) {
    try {
      final json = _encoder.convert(msg);
      final array = json.split('\n');
      if (array.isNotEmpty) {
        for (var element in array) {
          _printLog('i', tag, element);
        }
      }
    } catch (e) {
      print(e);
    }
  }

}