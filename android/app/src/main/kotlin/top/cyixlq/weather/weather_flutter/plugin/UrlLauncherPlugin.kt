package top.cyixlq.weather.weather_flutter.plugin

import android.content.Context
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

class UrlLauncherPlugin(private var context: Context?) : FlutterPlugin {

    private lateinit var channel : MethodChannel

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "top.cyixlq.weather.weather_flutter.plugin/url_launcher_plugin")
        channel.setMethodCallHandler { call, _ ->
            val url = call.argument<String>("uri")
            if (call.method == "launch") {
                val uri = Uri.parse(url)
                val intent = Intent(Intent.ACTION_VIEW, uri)
                context?.startActivity(intent)
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = null
        channel.setMethodCallHandler(null)
    }

}