import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:weather_flutter/common/weather_icons.dart';


final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;

const Map<String, IconData> weatherIconMap = {
  '霾': WeatherIcons.wuMai,
  '小雨': WeatherIcons.xiaoYu,
  '中雨': WeatherIcons.zhongYu,
  '大雨': WeatherIcons.daYu,
  '雷阵雨': WeatherIcons.leiZhenYu,
  '阴': WeatherIcons.yin,
  '晴': WeatherIcons.qing,
  '多云': WeatherIcons.duoYun,
  '小雪': WeatherIcons.xiaoXue,
  '中雪': WeatherIcons.zhongXue,
  '大雪': WeatherIcons.daXue,
  '雨夹雪': WeatherIcons.yuJiaXue
};

IconData getWeatherIcon(String? type) {
  if (type == null) {
    return WeatherIcons.unknow;
  }
  IconData? iconData = weatherIconMap[type];
  if (iconData == null) {
    return WeatherIcons.unknow;
  }
  return iconData;
}

final BoxDecoration windowsBg = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: const [0.1, 1],
      colors: _getWindowBgColors()
    )
);

List<Color> _getWindowBgColors() {
  final hour = DateTime.now().hour;
  if (hour >= 7 && hour <= 11) {
    return morningColors;
  }
  if (hour >= 12 && hour <= 18) {
    return middleColors;
  }
  return nightColors;
}

const List<Color> morningColors = [
  Color(0xffABDCFF),
  Color(0xff0396FF)
];

const List<Color> middleColors = [
  Color(0xffFCCF31),
  Color(0xffF55555)
];

const List<Color> nightColors = [
  Color(0xff3B2667),
  Color(0xffBC78EC)
];

void canvasCenterRotation(Canvas canvas, double halfWidth, double halfHeight, double angle) {
  final double radians = angle / 180 * pi;
  canvas.translate(halfWidth, halfHeight);
  canvas.rotate(radians);
  canvas.translate(-halfWidth, -halfHeight);
}

