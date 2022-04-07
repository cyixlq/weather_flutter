class Yesterday {
  final String date;
  final String fl;
  final String fx;
  final String high;
  final String low;
  final String type;

  Yesterday(this.date, this.fl, this.fx, this.high, this.low, this.type);

  Yesterday.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        fl = json['fl'],
        fx = json['fx'],
        high = json['high'],
        low = json['low'],
        type = json['type'];

  Map<String, dynamic> toJson() =>
      {
        'date': date,
        'fl': fl,
        'fx': fx,
        'high': high,
        'low': low,
        'type': type
      };
}