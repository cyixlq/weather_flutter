
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weather_flutter/component/weather_background.dart';

/// 自定义View，保存雨雪参数
class RainSnowParams {

  //x坐标
  late double x;
  //y坐标
  late double y;
  //绘制类型
  int type = WeatherBackground.typeRain;
  //速度
  int speed;
  //view宽
  late double width;
  //view高
  late double height;
  //缩放
  late double _scale;
  //随机数
  final random = Random();
  //画笔
  late final Paint _paint;
  //透明度
  late double alpha;
  //第一次move前需要reset一下
  bool _isFirstMove = true;

  RainSnowParams(this.type, this.speed) {
    _paint = Paint();
    _paint.color = Colors.white;
  }

  reset(Size size) {
    _scale = random.nextDouble();
    if (type == WeatherBackground.typeRain) {
      width = 2 * _scale;
      height = 40 * _scale;
    } else {
      width = 6 * _scale;
      height = 6 * _scale;
    }
    x = random.nextDouble() * size.width;
    y = -(random.nextDouble() * (1.5 * size.height));
    alpha = 0.3 + 0.7 * _scale;
    _paint.colorFilter = ColorFilter.matrix(<double>[
      1, 0, 0, 0, 0, 0,
      1, 0, 0, 0, 0, 0,
      1, 0, 0, 0, 0, 0,
      alpha, 0,
    ]);
  }

  move(Canvas canvas, Size size) {
    if (_isFirstMove) {
      reset(size);
      _isFirstMove = false;
    }
    if (y >= size.height) {
      reset(size);
    }
    if (type == WeatherBackground.typeRain) {
      y += speed;
    } else {
      y += speed * _scale;
    }
    if (type == WeatherBackground.typeRain) {
      canvas.drawRect(Rect.fromLTWH(x, y, width, height), _paint);
    } else if (type == WeatherBackground.typeSnow) {
      canvas.drawCircle(Offset(x, y), width, _paint);
    }
  }
}