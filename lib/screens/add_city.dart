
import 'package:flutter/material.dart';
import 'package:weather_flutter/common/config.dart';
import 'package:weather_flutter/common/navigator_util.dart';
import 'package:weather_flutter/common/toast.dart';
import 'package:weather_flutter/models/api/api.dart';

class AddCityPage extends StatelessWidget {

  AddCityPage({Key? key}) : super(key: key);
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: windowsBg,
      child: Scaffold(
        appBar: AppBar(title: const Text('添加城市')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.streetAddress,
                  controller: _cityController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    labelText: '城市名',
                    hintText: '请在此处输入城市名，例如：杭州',
                    prefixIcon: Icon(Icons.location_city, color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white),
                    floatingLabelStyle: TextStyle(color: Colors.blue),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)
                    )
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 15),
                  child: MaterialButton(
                    child: const Text('保存', style: TextStyle(color: Colors.white)),
                    minWidth: double.infinity,
                    height: 50,
                    color: Colors.blue,
                    onPressed: () async {
                      final city = _cityController.text;
                      if (city.isEmpty) {
                        showToast(context, '请输入正确的市/区名称');
                        return;
                      }
                      final list = await getCityList();
                      if (list.contains(city)) {
                        showToast(context, '市/区已经添加过了');
                        return;
                      }
                      final isSuccess = await saveCity(city);
                      if (isSuccess) {
                        NavigatorUtil.pop(context, city);
                      } else {
                        showToast(context, '市/区保存失败');
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
