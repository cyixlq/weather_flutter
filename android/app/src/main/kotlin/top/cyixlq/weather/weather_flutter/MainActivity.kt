package top.cyixlq.weather.weather_flutter

import android.os.Bundle
import android.view.View
import android.view.ViewGroup
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import top.cyixlq.weather.weather_flutter.plugin.LogPlugin
import top.cyixlq.weather.weather_flutter.plugin.PackageInfoPlugin
import top.cyixlq.weather.weather_flutter.plugin.UrlLauncherPlugin

class MainActivity: FlutterActivity() {

    companion object {
        private const val TAG = "MainActivity"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        (window.decorView as ViewGroup).setOnHierarchyChangeListener(object : ViewGroup.OnHierarchyChangeListener {
            override fun onChildViewAdded(parent: View?, child: View?) {
                if (child?.id == android.R.id.statusBarBackground || child?.id == android.R.id.navigationBarBackground) {
                    child.scaleX = 0f
                }
            }
            override fun onChildViewRemoved(parent: View?, child: View?) {}
        })
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        addPlugin(flutterEngine, LogPlugin())
        addPlugin(flutterEngine, PackageInfoPlugin(this))
        addPlugin(flutterEngine, UrlLauncherPlugin(this))
    }

    private fun addPlugin(engine: FlutterEngine, plugin: FlutterPlugin) {
        try {
            engine.plugins.add(plugin)
        } catch (e: Exception) {
            Log.e(TAG, "Error registering plugin: ${plugin.javaClass.canonicalName}", e)
        }
    }

}
