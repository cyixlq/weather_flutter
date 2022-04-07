import 'package:dio/dio.dart';
import 'package:weather_flutter/common/my_log.dart';

class MyLogInterceptor extends Interceptor {

  static const tag = 'NetWork';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final options = response.requestOptions;
    MyLog.i(tag, '------------------------------- HTTP CONTENT START -------------------------------');
    MyLog.i(tag, '*** Request ***');
    MyLog.i(tag, 'uri: ${options.uri}');
    if (options.queryParameters.isNotEmpty) {
      MyLog.i(tag, 'query: ${options.queryParameters}');
    }
    MyLog.i(tag, 'responseType: ${options.responseType.toString()}');
    if (options.extra.isNotEmpty) {
      MyLog.i(tag, 'extra: ${options.extra}');
    }
    MyLog.i(tag, '*** Response ***');
    MyLog.i(tag, 'statusCode: ${response.statusCode}');
    MyLog.i(tag, 'redirect: ${response.realUri}');
    response.headers.forEach((key, v) =>  MyLog.i(tag,'$key: ${v.join('\r\n\t')}'));
    MyLog.printJson(tag, response.data);
    MyLog.i(tag, '------------------------------- HTTP CONTENT END ---------------------------------');
    handler.next(response);
  }
}