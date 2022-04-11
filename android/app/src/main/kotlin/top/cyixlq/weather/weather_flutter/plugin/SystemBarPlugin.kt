package top.cyixlq.weather.weather_flutter.plugin

import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import top.cyixlq.weather.weather_flutter.utils.SystemBarUtil

class SystemBarPlugin(private var activity: Activity?) : FlutterPlugin {

    private lateinit var channel : MethodChannel
    private lateinit var systemBarUtil: SystemBarUtil

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val activity = activity ?: return
        systemBarUtil = SystemBarUtil.create(activity)
        channel = MethodChannel(binding.binaryMessenger, "top.cyixlq.weather.weather_flutter.plugin/system_bar_plugin")
        channel.setMethodCallHandler { call, _ ->
            when(call.method) {
                "setStatusBarColor" -> getColor(call)?.let {
                    systemBarUtil.setStatusBarColor(it)
                }
                "setNavigationBarColor" -> getColor(call)?.let {
                    systemBarUtil.setNavigationBarColor(it)
                }
                "setLightStatusBar" -> systemBarUtil.setLightStatusBar(isLight(call))
                "setLightNavigationBar" -> systemBarUtil.setLightNavigationBar(isLight(call))
            }
        }
    }

    private fun getColor(call: MethodCall): Int? {
        val color = call.argument<Any>("color")
        if (color is Long)
            return color.toInt()
        if (color is Int)
            return color
        return null
    }

    private fun isLight(call: MethodCall): Boolean {
        return call.argument<Boolean>("isLight") ?: false
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        activity = null
        channel.setMethodCallHandler(null)
    }
}