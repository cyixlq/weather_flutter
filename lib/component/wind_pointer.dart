import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weather_flutter/common/config.dart';

class WindPointer extends StatelessWidget {
  final double width;
  final double height;
  final String dir;


  final Paint _paint = Paint();
  final Map<String, double> angelMap = {
    '东北风': 45,
    '东风': 90,
    '东南风': 135,
    '南风': 180,
    '西南风': 225,
    '西风': 270,
    '西北风': 315
  };

  WindPointer({
    Key? key,
    required this.width,
    required this.height,
    required this.dir
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: angelMap[dir] ?? 0),
        duration: const Duration(seconds: 1),
        builder: (BuildContext context, double value, Widget? child) {
          return CustomPaint(
            size: Size(width, height),
            painter: _WindPointerPainter(_paint, value, dir),
          );
        });
  }
}

class _WindPointerPainter extends CustomPainter {
  final Paint _paint;
  final double currentAngle;
  final String dir;
  final textPaint = TextPainter(textDirection: TextDirection.ltr);
  final textStyle = const TextStyle(
    color: Colors.white,
    fontSize: 12,
  );
  final halfPointWidth = 1;

  _WindPointerPainter(this._paint, this.currentAngle, this.dir);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width, size.height) / 2;
    final double halfWidth = size.width / 2;
    final double halfHeight = size.height / 2;
    _paint..color = const Color(0x22FFFFFF)
      ..strokeWidth = 0
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(halfWidth, halfHeight), 30, _paint);
    final dirTextSpan = TextSpan(
      text: dir,
      style: const TextStyle(color: Colors.white, fontSize: 12),
    );
    textPaint.text = dirTextSpan;
    textPaint.layout();
    textPaint.paint(canvas, Offset(halfWidth - textPaint.width / 2, halfHeight - textPaint.height / 2));
    _drawDial(canvas, halfWidth, halfHeight, radius);
    _drawPointer(canvas, halfWidth, halfHeight, radius);
  }

  _drawDial(Canvas canvas, double halfWidth, double halfHeight, double radius) {
    _paint..style = PaintingStyle.fill..color = Colors.white;
    canvas.save();
    final texts = ['北', '东', '南', '西'];
    int index = 0;
    for (int i = 1; i <= 168; i++) {
      canvas.drawRect(
          Rect.fromLTWH(
            halfWidth - 0.5,
            0,
            1,
            6,
          ),
          _paint);
      if (i == 1 || i == 43 || i == 85 || i== 127) {
        final textSpan = TextSpan(
          text: texts[index++],
          style: textStyle,
        );
        textPaint.text = textSpan;
        textPaint.layout(
          minWidth: 0,
          maxWidth: 10,
        );
        textPaint.paint(canvas, Offset(halfWidth - 5, 7));
      }
      canvasCenterRotation(canvas, halfWidth, halfHeight, 2.143);
    }
    canvas.restore();
  }

  _drawPointer(Canvas canvas, double halfWidth, double halfHeight, double radius) {
    canvas.save();
    canvasCenterRotation(canvas, halfWidth, halfHeight, currentAngle);
    final Path path = Path()
      ..moveTo(halfWidth - halfPointWidth, halfHeight - radius + 10)
      ..lineTo(halfWidth - 6, halfHeight - radius + 14)
      ..lineTo(halfWidth,  halfHeight - radius)
      ..lineTo(halfWidth + 6, halfHeight - radius + 14)
      ..lineTo(halfWidth + halfPointWidth, halfHeight - radius + 10)
      ..lineTo(halfWidth + halfPointWidth, halfHeight - 30)
      ..lineTo(halfWidth - halfPointWidth, halfHeight - 30)
      ..close();
    canvas.drawPath(path, _paint);
    canvas.drawRect(
        Rect.fromLTWH(
          halfWidth - halfPointWidth,
          halfHeight + 30,
          halfPointWidth * 2,
          radius - 30 - 8
        ), _paint);
    _paint..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(halfWidth, halfHeight + radius - 4), 4, _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WindPointerPainter oldDelegate) => true;
}
