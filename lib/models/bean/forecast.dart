class Forecast {
  final String date;
  final String fengli;
  final String fengxiang;
  final String high;
  final String low;
  final String type;
  final String week;

  Forecast(
      this.date, this.fengli, this.fengxiang, this.high, this.low, this.type, this.week);

  Forecast.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        fengli = json['fengli'],
        fengxiang = json['fengxiang'],
        high = json['high'],
        low = json['low'],
        type = json['type'],
        week = json['week'];

  Map<String, dynamic> toJson() =>
      {
        'date': date,
        'fengli': fengli,
        'fengxiang': fengxiang,
        'high': high,
        'low': low,
        'type': type,
        'week': week
      };

}
