
import 'package:flutter/material.dart';
import 'package:weather_flutter/common/config.dart';
import 'package:weather_flutter/common/my_log.dart';
import 'package:weather_flutter/common/navigator_util.dart';
import 'package:weather_flutter/common/toast.dart';
import 'package:weather_flutter/component/city_item.dart';
import 'package:weather_flutter/models/api/api.dart';
import 'package:weather_flutter/screens/add_city.dart';

class CityListPage extends StatefulWidget {
  const CityListPage({Key? key}) : super(key: key);

  @override
  State<CityListPage> createState() => _CityListPageState();
}

class _CityListPageState extends State<CityListPage> {
  static const _tag = 'CityListPage';
  final List<String> _cityList = [];
  final _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    _getCityList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: windowsBg,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('城市列表'),
          actions: [
            IconButton(onPressed: () async {
              String? city = await NavigatorUtil.push(context, AddCityPage());
              if (city != null && city.isNotEmpty) {
                _listKey.currentState?.insertItem(_cityList.length);
                _cityList.add(city);
              }
            }, icon: const Icon(Icons.add))
          ],
        ),
        body: AnimatedList(
          key: _listKey,
          initialItemCount: 0,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index, Animation<double> animation) {
            return _buildCityItem(index, animation);
          },
        )
      ),
    );
  }

  Widget _buildCityItem(int index, Animation<double> animation) {
    final city = _cityList[index];
    return SizeTransition(
      sizeFactor: animation,
      child: CityItem(onItemClick:() async {
        bool isSuccess = await setCurrentCity(city);
        if (isSuccess) {
          NavigatorUtil.pop(context, city);
        } else {
          showToast(context, '当前城市设置失败');
        }
      }, onDelClick: () async {
        if (_cityList.length == 1) {
          showToast(context, '必须保留一个市/区');
          return;
        }
        final isSuccess = await delCity(city);
        if (isSuccess) {
          _listKey.currentState?.removeItem(
              index,
              (context, animation) => _buildRemoveItem(city, animation));
          _cityList.removeAt(index);
        }
      }, city: city,),
    );
  }

  Widget _buildRemoveItem(String city, Animation<double> animation) {
    return SizeTransition(sizeFactor: animation, child: CityItem(city: city));
  }

  _getCityList() {
    getCityList().then((value) {
      MyLog.i(_tag, '_cityList.length = ${_cityList.length}; value.length = ${value.length}');
      for (int i = 0; i < value.length; i++) {
        _listKey.currentState?.insertItem(i);
        _cityList.add(value[i]);
      }
    });
  }
}
