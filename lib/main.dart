import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_flutter/common/my_log.dart';
import 'package:weather_flutter/common/my_navigator_observer.dart';
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
      navigatorObservers: [
        MyNavigatorObserver()
      ],
    );
  }
}
