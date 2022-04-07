import 'package:dio/dio.dart';
import 'package:weather_flutter/models/api/http_error.dart';
import 'package:weather_flutter/models/api/my_log_interceptor.dart';

class NetClient {
  static final NetClient _instance = NetClient._internal();
  late Dio _dio;

  NetClient._internal();

  factory NetClient() => _instance;

  void init(String baseUrl, {int? connectTimeout, int? receiveTimeout, int? sendTimeout}) {
    BaseOptions options = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        sendTimeout: sendTimeout);
    _dio = Dio(options);
    _dio.interceptors.add(MyLogInterceptor());
  }

  Future<dynamic> get(final String path, {Map<String, dynamic>? parameter}) async {
    final response = _dio.get(path, queryParameters: parameter);
    final data = parse(response);
    return data;
  }

  dynamic parse(Future<Response> response) async {
    final res = await response;
    final code = res.statusCode ?? 400;
    if (code >= 400) {
      throw HttpError(code, res.statusMessage ?? '未知Http状态错误');
    } else {
      return res.data;
    }
  }
}
