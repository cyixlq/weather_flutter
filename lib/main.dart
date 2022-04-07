import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_flutter/common/config.dart';
import 'package:weather_flutter/common/my_log.dart';
import 'package:weather_flutter/models/api/net_client.dart';
import 'package:weather_flutter/screens/home.dart';

void main() {
  NetClient().init('https://api.vvhan.com/');
  MyLog.isDebug = kDebugMode;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 除半透明状态栏
    if (isAndroid) {
      // android 平台
      SystemUiOverlayStyle _style = const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(_style);
    }
    return MaterialApp(
      title: '天气',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          centerTitle: true,
          elevation: 0
        )
      ),
      home: const MainPage(),
    );
  }
}
