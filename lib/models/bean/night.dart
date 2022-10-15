
class Night {
  final String type;
  final String fengxiang;
  final String fengli;

  Night(this.type, this.fengxiang, this.fengli);

  factory Night.fromJson(Map<String, dynamic> json) {
    return Night(json['type'], json['fengxiang'], json['fengli']);
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'fengxiang': fengxiang,
    'fengli': fengli
  };
}