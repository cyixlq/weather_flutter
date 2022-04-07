package top.cyixlq.weather.weather_flutter

import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import top.cyixlq.weather.weather_flutter.plugin.LogPlugin
import top.cyixlq.weather.weather_flutter.plugin.PackageInfoPlugin

class MainActivity: FlutterActivity() {

    companion object {
        private const val TAG = "MainActivity"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        try {
            flutterEngine.plugins.add(LogPlugin())
        } catch (e: Exception) {
            Log.e(
                TAG,
                "Error registering plugin log_plugin, top.cyixle.weather.weather_flutter.plugin.LogPlugin",
                e
            )
        }
        try {
            flutterEngine.plugins.add(PackageInfoPlugin(this))
        } catch (e: Exception) {
            Log.e(
                TAG,
                "Error registering plugin package_info_plugin, top.cyixle.weather.weather_flutter.plugin.PackageInfoPlugin",
                e
            )
        }
    }

}
