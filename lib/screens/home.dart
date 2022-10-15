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
import 'package:weather_flutter/component/weather_item.dart';
import 'package:weather_flutter/component/weather_today.dart';
import 'package:weather_flutter/models/api/api.dart';
import 'package:weather_flutter/models/api/http_error.dart';
import 'package:weather_flutter/models/bean/forecast.dart';
import 'package:weather_flutter/screens/city_list.dart';

class MainPage extends StatefulWidget {
  static const tag = 'MainPage';

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _city = '';
  List<Forecast>? _weather;
  bool _isLoadingShow = false;

  @override
  void initState() {
    _checkCurrentCity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.only(
      left: MediaQuery.of(context).padding.left,
      right: MediaQuery.of(context).padding.right,
      bottom: MediaQuery.of(context).padding.bottom,
    );
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
              weight: _getWeight(_weather?[1].type),
              type: _getType(_weather?[1].type),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20 + padding.left,
                right: 20 + padding.right,
              ),
              child: createListView(padding.bottom),
            )
          ],
        ),
      ),
    );
  }

  ListView createListView(double paddingBottom) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: _weather?.length ?? 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return WeatherToday(_weather?[index + 1]);
        } else if (index == _weather!.length - 1) {
          return SizedBox(width: double.infinity, height: paddingBottom,);
        }
        return Column(children: [
          WeatherItem(
            forecast: _weather![index + 1],
          ),
          const Divider(color: Colors.white, thickness: 1)
        ]);
      },
    );
  }

  int _getWeight(String? typeStr) {
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
        final String msg;
        if (e is HttpError) {
          msg = e.msg;
        } else {
          msg = '未知异常: ${e.toString()}';
        }
        showToast(context, msg);
        MyLog.e(MainPage.tag, '天气数据获取错误: $msg');
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
