
class BaseResponse<T> {
  final bool success;
  final T data;
  var updateTime = 0;
  final String? message;

  BaseResponse(this.success, this.data, this.message, this.updateTime);

  factory BaseResponse.fromJsonArray(Map<String, dynamic> json, T Function(List json) fromJsonT) =>
      BaseResponse(
        json['success'],
        fromJsonT(json['data']),
        json['message'],
        json['updateTime'] ?? 0
      );

  factory BaseResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic> json) fromJsonT) =>
      BaseResponse(
        json['success'],
        fromJsonT(json['data']),
        json['message'],
        json['updateTime'] ?? 0
      );

  Map<String, dynamic> toJson() =>
      {
        'success': success,
        'data': data,
        'updateTime': updateTime,
        'message': message
      };
}
