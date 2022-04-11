package top.cyixlq.weather.weather_flutter

import android.os.Bundle
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import top.cyixlq.weather.weather_flutter.plugin.LogPlugin
import top.cyixlq.weather.weather_flutter.plugin.PackageInfoPlugin
import top.cyixlq.weather.weather_flutter.plugin.SystemBarPlugin
import top.cyixlq.weather.weather_flutter.utils.SystemBarUtil

class MainActivity: FlutterActivity() {

    companion object {
        private const val TAG = "MainActivity"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val util = SystemBarUtil.create(this)
        util.immersiveStatusBar()
        util.immersiveNavigationBar()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        addPlugin(flutterEngine, LogPlugin())
        addPlugin(flutterEngine, PackageInfoPlugin(this))
        addPlugin(flutterEngine, SystemBarPlugin(this))
    }

    private fun addPlugin(engine: FlutterEngine, plugin: FlutterPlugin) {
        try {
            engine.plugins.add(plugin)
        } catch (e: Exception) {
            Log.e(TAG, "Error registering plugin: ${plugin.javaClass.canonicalName}", e)
        }
    }

}
