
import 'package:flutter/material.dart';
import 'package:weather_flutter/common/config.dart';
import 'package:weather_flutter/component/weather_content.dart';
import 'package:weather_flutter/models/bean/forecast.dart';

class WeatherToday extends StatelessWidget {

  final Forecast? _forecast;

  const WeatherToday(this._forecast, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                    getWeatherIcon(_forecast?.type),
                    color: Colors.white, size: 120
                ),
                Text(
                  _forecast?.type ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 30),
                ),
              ],
            ),
          ),
        ),
        Text(_forecast?.date ?? '', style: const TextStyle(color: Colors.white, fontSize: 20)),
        WeatherContent(_forecast?.low,_forecast?.high,_forecast?.fengli,_forecast?.fengxiang)
      ]
    );
  }
}