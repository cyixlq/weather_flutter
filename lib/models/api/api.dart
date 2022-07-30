import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_flutter/common/my_log.dart';
import 'package:weather_flutter/models/api/http_error.dart';
import 'package:weather_flutter/models/bean/base_response.dart';
import 'package:weather_flutter/models/bean/weather.dart';
import 'package:weather_flutter/models/api/net_client.dart';

const _tag = 'API_TAG';

/// *********** 天气API *************/
Future<Weather> getWeather(String city, { bool isRefresh = false}) async {
  final now = DateTime.now().millisecondsSinceEpoch;
  if (isRefresh) {
    // 是刷新的话直接返回网络数据，就不读取本地缓存了
    return _getWeatherNet(city, now);
  }
  final cache = await _getWeatherLocal(city);
  if (cache == null || now - cache.updateTime > 2 * 3600 * 1000) {
    // 没有缓存或者缓存时间超过了两个小时
    return _getWeatherNet(city, now);
  }
  // 缓存有效
  return cache;
}

Future<Weather> _getWeatherNet(String city, int now) async {
  final data = await NetClient().get('/api/weather', parameter: {
    'city': city,
    'type': 'week'
  });
  final BaseResponse<Weather> baseResponse = BaseResponse.fromJson(data, Weather.fromJson);
  final Weather weather = parse(baseResponse);
  weather.updateTime = now;
  _saveWeatherLocal(city, jsonEncode(weather));
  return weather;
}

Future<void> _saveWeatherLocal(String city, String json) async {
  final prefs = await SharedPreferences.getInstance();
  final isSuccess = await prefs.setString(city, json);
  MyLog.i(_tag, 'save weather data local $isSuccess');
}

Future<void> _removeWeatherLocal(String city) async {
  final prefs = await SharedPreferences.getInstance();
  final isSuccess = await prefs.remove(city);
  MyLog.i(_tag, 'remove weather data local $isSuccess');
}

Future<Weather?> _getWeatherLocal(String city) async {
  final prefs = await SharedPreferences.getInstance();
  final json = prefs.getString(city);
  if (json != null) {
    return Weather.fromJson(jsonDecode(json));
  }
  return null;
}

T parse<T>(BaseResponse<T> baseResponse) {
  if (baseResponse.success == true) {
    return baseResponse.data;
  }
  throw HttpError(500, "服务端异常");
}

/// *********** 城市API *************/
Future<List<String>> getCityList() async {
  final prefs = await SharedPreferences.getInstance();
  final List<String>? list = prefs.getStringList('city_list');
  final result = list ?? [];
  MyLog.printJson(_tag, result);
  return result;
}

Future<bool> saveCity(String city) async {
  final prefs = await SharedPreferences.getInstance();
  final list = await getCityList();
  list.add(city);
  final isSuccess = await prefs.setStringList('city_list', list);
  MyLog.i(_tag, 'save city list data local $isSuccess');
  return isSuccess;
}

Future<bool> delCity(String city) async {
  final prefs = await SharedPreferences.getInstance();
  final list = await getCityList();
  list.remove(city);
  final isSuccess = await prefs.setStringList('city_list', list);
  if (isSuccess) {
    // 删除掉对应城市缓存城市天气
    _removeWeatherLocal(city);
  }
  MyLog.i(_tag, 'save city list data local $isSuccess');
  return isSuccess;
}

Future<bool> setCurrentCity(String city) async {
  final prefs = await SharedPreferences.getInstance();
  final isSuccess = await prefs.setString('current_city', city);
  MyLog.i(_tag, 'save city list data local $isSuccess');
  return isSuccess;
}

Future<String?> getCurrentCity() async {
  final prefs = await SharedPreferences.getInstance();
  final result = prefs.getString('current_city');
  MyLog.i(_tag, 'current_city: ' + result.toString());
  return result;
}