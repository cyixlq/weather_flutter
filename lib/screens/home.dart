import 'package:flutter/material.dart';
import 'package:weather_flutter/common/config.dart';
import 'package:weather_flutter/common/my_log.dart';
import 'package:weather_flutter/common/navigator_util.dart';
import 'package:weather_flutter/common/package_info.dart';
import 'package:weather_flutter/common/toast.dart';
import 'package:weather_flutter/common/weather_icons.dart';
import 'package:weather_flutter/component/about_dialog.dart';
import 'package:weather_flutter/component/loading_dialog.dart';
import 'package:weather_flutter/component/weather_background.dart';
import 'package:weather_flutter/component/weather_content.dart';
import 'package:weather_flutter/component/weather_item.dart';
import 'package:weather_flutter/models/api/api.dart';
import 'package:weather_flutter/models/bean/weather.dart';
import 'package:weather_flutter/screens/city_list.dart';

class MainPage extends StatefulWidget {
  static const tag = 'MainPage';

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _city = '';
  Weather? _weather;
  bool _isLoadingShow = false;

  @override
  void initState() {
    _checkCurrentCity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: windowsBg,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_city),
          leading: IconButton(
              onPressed: () {
                _getWeather(isRefresh: true);
                _showLoading();
              },
              icon: const Icon(Icons.refresh)),
          actions: [
            IconButton(onPressed: _go2CityList, icon: const Icon(Icons.menu)),
            IconButton(
              onPressed: _showAboutDialog,
              icon: const Icon(WeatherIcons.about),
              iconSize: 20,
            )
          ],
        ),
        body: Stack(
          children: [
            WeatherBackground(
              width: double.infinity,
              height: double.infinity,
              weight: _getWeight(_weather?.forecast[0].type),
              type: _getType(_weather?.forecast[0].type),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20 + MediaQuery.of(context).padding.left,
                  right: 20 + MediaQuery.of(context).padding.right,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(getWeatherIcon(_weather?.forecast[0].type),
                              color: Colors.white, size: 120),
                          Text(
                            '${_weather?.wendu ?? '??'}℃',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 60),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _weather?.forecast[0].date ?? '',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    WeatherContent(
                      _weather?.forecast[0].low,
                      _weather?.forecast[0].high,
                      _weather?.forecast[0].fengli,
                      _weather?.forecast[0].fengxiang,
                    ),
                    ..._buildForecastItems(),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildForecastItems() {
    if (_weather == null) {
      return [];
    }
    return _weather!.forecast
        .skip(1)
        .map((forecast) => Column(children: [
              WeatherItem(
                forecast: forecast,
              ),
              const Divider(color: Colors.white, thickness: 1)
            ]))
        .toList();
  }

  int _getWeight(String? typeStr) {
    final typeStr = _weather?.forecast[0].type;
    int weight = -1;
    if (typeStr != null) {
      if (typeStr.contains('小')) {
        weight = WeatherBackground.light;
      } else if (typeStr.contains('中')) {
        weight = WeatherBackground.middle;
      } else if (typeStr.contains('大')) {
        weight = WeatherBackground.heavy;
      }
    }
    return weight;
  }

  int _getType(String? typeStr) {
    int type = -1;
    if (typeStr != null) {
      if (typeStr.contains('雨')) {
        type = WeatherBackground.typeRain;
      } else if (typeStr.contains('雪')) {
        type = WeatherBackground.typeSnow;
      }
    }
    return type;
  }

  void _getWeather({bool isRefresh = false}) {
    getWeather(_city, isRefresh: isRefresh).then(
        (value) => setState(() {
          _weather = value;
        }
      )).catchError((e) {
        showToast(context, '天气数据获取错误，或许是不支持的市/区名');
        MyLog.e(MainPage.tag, '天气数据获取错误: ${e.toString()}');
        setState(() {
          _weather = null;
        });
      }).whenComplete(() {
        if (_isLoadingShow) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            Navigator.of(context).pop();
            _isLoadingShow = false;
          });
        }
      });
  }

  _showLoading() {
    _isLoadingShow = true;
    showDialog(context: context, builder: (context) => const LoadingDialog());
  }

  _checkCurrentCity() {
    getCurrentCity().then((value) {
      if (value != null && value.toString().isNotEmpty) {
        setState(() {
          _city = value.toString();
        });
        _getWeather();
      } else {
        showToast(context, '请先添加一个市/区');
        _go2CityList();
      }
    });
  }

  _go2CityList() {
    NavigatorUtil.push(context, const CityListPage()).then((value) {
      if (value != null && value.toString().isNotEmpty) {
        setState(() {
          _city = value.toString();
        });
        _getWeather();
      } else {
        if (_city.isEmpty) {
          showToast(context, '市/区选择失败，点击右上角按钮重新选择');
        }
      }
    });
  }

  _showAboutDialog() async {
    final String appName = await PackageInfo.appName();
    final String versionName = await PackageInfo.versionName();
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return MyAboutDialog(
          applicationName: appName,
          applicationVersion: versionName,
          applicationIcon: Image.asset(
            'assets/images/icon_launch.png',
            width: 50,
            height: 50,
          ),
          applicationLegalese: 'copyright © Cy Company',
          children: [
            Container(
              height: 40,
              color: Colors.red,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: const Text(
                '作者：cyixlq',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
            Container(
                height: 40,
                color: Colors.green,
                padding: const EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'CY出品，必属精品！',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
            ),
            Container(
              height: 40,
              color: Colors.blue,
            ),
          ],
        );
      },
    );
  }
}
