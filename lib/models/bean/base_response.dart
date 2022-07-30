class BaseResponse<T> {
  final bool success;
  final T data;

  BaseResponse(this.success, this.data);

  BaseResponse.fromJson(Map<String, dynamic> json,
      T Function(Map<String, dynamic> json) fromJsonT)
      : success = json['success'],
        data = fromJsonT(json['data']);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      {'success': success, 'data': toJsonT(data)};
}
