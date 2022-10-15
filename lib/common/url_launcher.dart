
import 'package:flutter/services.dart';

class UrlLauncher {
  static const MethodChannel _channel = MethodChannel('top.cyixlq.weather.weather_flutter.plugin/url_launcher_plugin');

  static launch(String url) {
    _channel.invokeMethod('launch', {'uri': url});
  }
}