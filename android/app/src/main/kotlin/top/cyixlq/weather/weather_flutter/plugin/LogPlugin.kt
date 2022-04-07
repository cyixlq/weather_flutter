package top.cyixlq.weather.weather_flutter.plugin

import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

/** LogPlugin */
class LogPlugin: FlutterPlugin {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "top.cyixlq.log_plugin/log_plugin")
    channel.setMethodCallHandler { call, _ ->
      val tag = call.argument<String>("tag")
      val msg = call.argument<String>("msg") ?: ""
      when(call.method) {
        "v" -> Log.v(tag, msg)
        "d" -> Log.d(tag, msg)
        "i" -> Log.i(tag, msg)
        "w" -> Log.w(tag, msg)
        "e" -> Log.e(tag, msg)
        "wtf" -> Log.wtf(tag, msg)
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
