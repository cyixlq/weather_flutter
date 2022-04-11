
import 'package:flutter/services.dart';
import 'package:weather_flutter/common/config.dart';

class SystemBarUtil {

  SystemBarUtil._();

  static const MethodChannel _channel = MethodChannel('top.cyixlq.weather.weather_flutter.plugin/system_bar_plugin');

  static setStatusBarColor(int color) {
    if (isAndroid) {
      _channel.invokeMethod('setStatusBarColor', {'color': color});
    }
  }

  static setNavigationBarColor(int color) {
    if (isAndroid) {
      _channel.invokeMethod('setNavigationBarColor', {'color': color});
    }
  }

  static setLightStatusBar(bool isLight) {
    if (isAndroid) {
      _channel.invokeMethod('setLightStatusBar', {'isLight': isLight});
    }
  }

  static setLightNavigationBar(bool isLight) {
    if (isAndroid) {
      _channel.invokeMethod('setLightNavigationBar', {'isLight': isLight});
    }
  }

}