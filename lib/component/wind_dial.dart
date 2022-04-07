import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weather_flutter/common/config.dart';

class WindDial extends StatelessWidget {
  final double width;
  final double height;
  final String? levelText;
  final Paint _paint = Paint()..color = Colors.white;

  WindDial({
    Key? key,
    required this.width,
    required this.height,
    required this.levelText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: -150, end: _getTargetAngle()),
      duration: const Duration(seconds: 1),
      builder: (BuildContext context, double value, Widget? child) {
        return CustomPaint(
          size: Size(width, height),
          painter: _WindDialPainter(value, _paint, levelText ?? '0级'),
        );
      });
  }

  double _getTargetAngle() {
    final int level = int.tryParse(levelText?.replaceAll('级', '') ?? '0') ?? 0;
    double targetAngle;
    if (level < 6) {
      targetAngle = (6 - level) * -25;
    } else {
      targetAngle = (level - 6) * 25;
    }
    return targetAngle;
  }
}

class _WindDialPainter extends CustomPainter {

  final double currentAngel;
  final Paint _paint;
  final String levelText;
  final textPaint = TextPainter(textDirection: TextDirection.ltr);

  _WindDialPainter(this.currentAngel, this._paint, this.levelText);

  @override
  void paint(Canvas canvas, Size size) {
    final double halfWidth = size.width / 2;
    final double halfHeight = size.height / 2;
    final radius = min(halfWidth, halfHeight);
    _paint..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    ///绘制圆盘
    canvas.drawArc(
        Rect.fromCircle(center: Offset(halfWidth, halfHeight), radius: radius),
        -240 * (pi / 180),
        300 * (pi / 180),
        false,
        _paint
    );
    _paint.strokeWidth = 1;
    canvas.drawArc(
        Rect.fromCircle(center: Offset(halfWidth, halfHeight), radius: radius - 5),
        -240 * (pi / 180),
        300 * (pi / 180),
        false,
        _paint
    );
    ///绘制中间文字
    final textLevelSpan = TextSpan(
      text: levelText,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    );
    textPaint.text = textLevelSpan;
    textPaint.layout();
    textPaint.paint(canvas, Offset(halfWidth - textPaint.width / 2, halfHeight - textPaint.height / 2));
    ///绘制两头最低和最高级数文字
    const tagTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 11,
    );
    const minTextSpan = TextSpan(
      text: '0级',
      style: tagTextStyle
    );
    final capHeight = cos(40 / 180 * pi) * radius;
    textPaint.text = minTextSpan;
    textPaint.layout();
    textPaint.paint(canvas, Offset(halfWidth - radius, halfHeight + capHeight));
    const maxTestSpan = TextSpan(
      text: '12级',
      style: tagTextStyle
    );
    textPaint.text = maxTestSpan;
    textPaint.layout();
    textPaint.paint(canvas, Offset(halfWidth + radius - textPaint.width, halfHeight + capHeight));
    ///绘制箭头
    canvas.save();
    canvasCenterRotation(canvas, halfWidth, halfHeight, currentAngel);
    final Path path = Path()..moveTo(halfWidth, halfHeight - radius + 7)
      ..lineTo(halfWidth - 4, halfHeight - radius + 17)
      ..lineTo(halfWidth, halfHeight - radius + 13)
      ..lineTo(halfWidth + 4, halfHeight - radius + 17)
      ..close();
    canvas.drawPath(path, _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}

