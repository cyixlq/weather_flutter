import 'package:flutter/material.dart';

class TemperatureChart extends StatelessWidget {


  static const double minT = -20; // 表格最低温度
  static const double maxT = 50; // 表格最高温度
  static const double totalT = maxT - minT; // 表格总温度

  final paint = Paint()..color = Colors.white;
  final textPaint = TextPainter(textDirection: TextDirection.ltr);
  final textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 14
  );

  final String lowText;
  final String highText;

  TemperatureChart({
    Key? key,
    required this.lowText,
    required this.highText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 1),
      tween: Tween(begin: minT, end: _getHigh()),
      builder: (BuildContext context, double value, Widget? child) {
        return CustomPaint(
          size: const Size(double.infinity, 120),
          painter: _TemperatureChartPainter(_getLow(), _getHigh(), value, this),
        );
      },
    );
  }

  double _getHigh() {
    return double.tryParse(highText.replaceAll('高温 ', '').replaceAll('℃', '')) ?? minT;
  }

  double _getLow() {
    return double.tryParse(lowText.replaceAll('低温 ', '').replaceAll('℃', '')) ?? minT;
  }

}

class _TemperatureChartPainter extends CustomPainter {

  final double low;
  final double high;
  final double value;
  final TemperatureChart chart;

  _TemperatureChartPainter(this.low, this.high, this.value, this.chart);

  @override
  void paint(Canvas canvas, Size size) {
    final yMax = size.height - 20; // y轴最大值
    chart.paint..strokeWidth = 2..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset.zero, Offset(0, yMax), chart.paint);
    canvas.drawLine(Offset(0, yMax), Offset(size.width, yMax), chart.paint);
    final lowTextSpan = TextSpan(
      text: '低温',
      style: chart.textStyle
    );
    chart.textPaint.text = lowTextSpan;
    chart.textPaint.layout();
    chart.textPaint.paint(canvas, Offset(chart.textPaint.width, yMax));
    final currentLow = value >= low ? low : value;
    final lowOffset = Offset(
      chart.textPaint.width * 1.5,
      (1 - (currentLow - TemperatureChart.minT) / TemperatureChart.totalT) * yMax
    );
    canvas.drawCircle(lowOffset, 3, chart.paint);
    final highTextSpan = TextSpan(
      text: '高温',
      style: chart.textStyle
    );
    chart.textPaint.text = highTextSpan;
    chart.textPaint.layout();
    chart.textPaint.paint(canvas, Offset(size.width - chart.textPaint.width * 2, yMax));
    final currentHigh = value >= high ? high : value;
    final highOffset = Offset(
      size.width - chart.textPaint.width * 1.5,
      (1 - (currentHigh - TemperatureChart.minT) / TemperatureChart.totalT) * yMax
    );
    canvas.drawCircle(highOffset, 3, chart.paint);
    chart.paint.strokeWidth = 1;
    canvas.drawLine(lowOffset, highOffset, chart.paint);
    final currentLowTextSpan = TextSpan(
      text: '${currentLow.round()}℃',
      style: chart.textStyle
    );
    chart.textPaint.text = currentLowTextSpan;
    chart.textPaint.layout();
    chart.textPaint.paint(canvas, Offset(lowOffset.dx - chart.textPaint.width / 2, lowOffset.dy - chart.textPaint.height));
    final currentHighTextSpan = TextSpan(
      text: '${currentHigh.round()}℃',
      style: chart.textStyle
    );
    chart.textPaint.text = currentHighTextSpan;
    chart.textPaint.layout();
    chart.textPaint.paint(canvas, Offset(highOffset.dx - chart.textPaint.width / 2, highOffset.dy - chart.textPaint.height));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}
