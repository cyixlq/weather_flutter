
import 'package:flutter/material.dart';
import 'package:weather_flutter/common/config.dart';
import 'package:weather_flutter/models/bean/forecast.dart';

class WeatherItem extends StatelessWidget {

  final Forecast forecast;

  const WeatherItem({Key? key, required this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(children: [
            Text(forecast.date,
                style: const TextStyle(color: Colors.white)),
            const Flexible(
                child: Divider(color: Colors.transparent), flex: 1),
            Icon(
              getWeatherIcon(forecast.type),
              size: 20,
              color: Colors.white,
            ),
            Text(
                '${forecast.low.replaceAll('低温 ', '')} / ${forecast.high.replaceAll('高温 ', '')}',
                style: const TextStyle(color: Colors.white))
          ]));
  }
}
