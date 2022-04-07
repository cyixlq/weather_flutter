class BaseResponse<T> {
  final int status;
  final String desc;
  final T data;

  BaseResponse(this.status, this.desc, this.data);

  BaseResponse.fromJson(Map<String, dynamic> json,
      T Function(Map<String, dynamic> json) fromJsonT)
      : status = json['status'],
        desc = json['desc'],
        data = fromJsonT(json['data']);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      {'status': status, 'desc': desc, 'data': toJsonT(data)};
}
