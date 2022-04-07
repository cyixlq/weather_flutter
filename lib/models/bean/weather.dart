
import 'package:weather_flutter/models/bean/forecast.dart';
import 'package:weather_flutter/models/bean/yesterday.dart';

class Weather {
  int updateTime;
  final String city;
  final List<Forecast> forecast;
  final String ganmao;
  final String wendu;
  final Yesterday yesterday;

  Weather(this.updateTime, this.city, this.forecast, this.ganmao, this.wendu,
      this.yesterday);

  factory Weather.fromJson(Map<String, dynamic> json) {
    var list = json['forecast'] as List;
    List<Forecast> forecast = list.map((i) => Forecast.fromJson(i)).toList();
    return Weather(json['updateTime'] ?? 0, json['city'], forecast, json['ganmao'],
        json['wendu'], Yesterday.fromJson(json['yesterday']));
  }

  Map<String, dynamic> toJson() =>
      {
        'updateTime': updateTime,
        'city': city,
        'forecast': forecast,
        'ganmao': ganmao,
        'wendu': wendu,
        'yesterday': yesterday.toJson()
      };
}
