package top.cyixlq.weather.weather_flutter.plugin

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import top.cyixlq.weather.weather_flutter.BuildConfig
import top.cyixlq.weather.weather_flutter.R

class PackageInfoPlugin(private var context: Context?) : FlutterPlugin {

    private lateinit var channel : MethodChannel

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "top.cyixle.weather.weather_flutter.plugin/package_info_plugin")
        channel.setMethodCallHandler { call, result ->
            when(call.method) {
                "versionCode" -> result.success(BuildConfig.VERSION_CODE)
                "versionName" -> result.success(BuildConfig.VERSION_NAME)
                "package" -> result.success(BuildConfig.APPLICATION_ID)
                "appName" -> result.success(context?.getString(R.string.app_name) ?: "UnKnow")
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        context = null
    }
}