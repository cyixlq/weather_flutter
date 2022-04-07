import 'package:flutter/material.dart';
import 'package:weather_flutter/models/bean/rain_snow_params.dart';

class WeatherBackground extends StatefulWidget {
  static const String tag = 'WeatherBackground';
  static const int light = 0;
  static const int middle = 1;
  static const int heavy = 2;

  static const int typeRain = 0;
  static const int typeSnow = 1;

  final double width;
  final double height;
  final int weight;
  final int type;

  const WeatherBackground(
      {Key? key,
      required this.width,
      required this.height,
      required this.weight,
      required this.type})
      : super(key: key);

  @override
  State<WeatherBackground> createState() => _WeatherBackgroundState();
}

class _WeatherBackgroundState extends State<WeatherBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<RainSnowParams> params = [];

  @override
  void initState() {
    _controller =
        AnimationController(duration: const Duration(minutes: 1), vsync: this);
    _init();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant WeatherBackground oldWidget) {
    _init();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => CustomPaint(
              painter: _RainSnowPainter(params, !_isIncorrectParams()))),
    );
  }

  _init() async {
    if (_isIncorrectParams()) {
      _controller.reset();
      return;
    }
    int count;
    int speed;
    if (widget.weight == WeatherBackground.middle) {
      count = 200;
      speed = _getSpeed(30, 4);
    } else if (widget.weight == WeatherBackground.heavy) {
      count = 300;
      speed = _getSpeed(40, 5);
    } else {
      count = 100;
      speed = _getSpeed(20, 3);
    }
    params.clear();
    for (int i = 0; i < count; i++) {
      params.add(RainSnowParams(widget.type, speed));
    }
    _controller.repeat();
  }

  bool _isIncorrectParams() {
    return widget.type < WeatherBackground.typeRain ||
        widget.type > WeatherBackground.typeSnow ||
        widget.weight < WeatherBackground.light ||
        widget.weight > WeatherBackground.heavy;
  }

  int _getSpeed(int rainSpeed, int snowSpeed) {
    return widget.type == WeatherBackground.typeRain ? rainSpeed : snowSpeed;
  }
}

class _RainSnowPainter extends CustomPainter {
  final List<RainSnowParams> params;
  final bool isNeedPaint;

  _RainSnowPainter(this.params, this.isNeedPaint);

  @override
  void paint(Canvas canvas, Size size) {
    if (isNeedPaint && params.isNotEmpty) {
      for (var element in params) {
        element.move(canvas, size);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => isNeedPaint;
}
