import 'package:flutter/material.dart';
import 'package:weather_flutter/common/config.dart';
import 'package:weather_flutter/common/my_log.dart';
import 'package:weather_flutter/common/system_bar_util.dart';

class MyNavigatorObserver extends NavigatorObserver {

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final isLicensePage = route.settings.name == 'license';
    MyLog.i('CyRoute', 'didPush: ${route.toString()}; isLicensePage: $isLicensePage');
    if (isLicensePage) {
      SystemBarUtil.setNavigationBarColor(getWindowBgColors()[1].value);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final isLicensePage = route.settings.name == 'license';
    MyLog.i('CyRoute', 'didPop: ${route.toString()}; isLicensePage: $isLicensePage');
    if (isLicensePage) {
      SystemBarUtil.setNavigationBarColor(0);
    }
  }
}