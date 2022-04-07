import 'package:flutter/material.dart';
import 'package:weather_flutter/component/temperature_chart.dart';
import 'package:weather_flutter/component/weather_item_card.dart';
import 'package:weather_flutter/component/wind_dial.dart';
import 'package:weather_flutter/component/wind_pointer.dart';

class WeatherContent extends StatelessWidget {
  final String? low;
  final String? high;
  final String? wind;
  final String? windDir;

  const WeatherContent(this.low, this.high, this.wind, this.windDir, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WeatherItemCard(
          title: '气温',
          child: TemperatureChart(
            lowText: low ?? '',
            highText: high ?? '',
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: WeatherItemCard(
                title: '风力',
                marginEnd: 5,
                child: WindDial(
                  width: 120,
                  height: 120,
                  levelText: wind,
                ),
              ),
            ),
            Expanded(
              child: WeatherItemCard(
                title: '风向',
                marginStart: 5,
                child: WindPointer(
                  width: 120,
                  height: 120,
                  dir: windDir ?? '',
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
