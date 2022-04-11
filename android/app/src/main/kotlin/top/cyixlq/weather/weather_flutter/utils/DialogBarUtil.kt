@file:Suppress("DEPRECATION")

package top.cyixlq.weather.weather_flutter.utils

import android.annotation.SuppressLint
import android.app.Activity
import android.app.Dialog
import android.os.Build
import android.util.Size
import android.view.View
import android.view.ViewGroup

val Activity.screenSize: Size
    get() {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            Size(windowManager.currentWindowMetrics.bounds.width(), windowManager.currentWindowMetrics.bounds.height())
        } else {
            Size(windowManager.defaultDisplay.width, windowManager.defaultDisplay.height)
        }
    }

val Activity.screenWidth get() = screenSize.width

val Activity.screenHeight: Int get() = screenSize.height

private const val STATUS_BAR_MASK_COLOR = 0x7F000000

@SuppressLint("ObsoleteSdkInt")
fun Dialog.setLightStatusBar(isLightingColor: Boolean) {
    val window = this.window ?: return
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        if (isLightingColor) {
            window.decorView.systemUiVisibility =
                View.SYSTEM_UI_FLAG_LAYOUT_STABLE or View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR
        } else {
            window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_LAYOUT_STABLE
        }
    }
}


@SuppressLint("ObsoleteSdkInt")
fun Dialog.setLightNavigationBar(isLightingColor: Boolean) {
    val window = this.window ?: return
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && isLightingColor) {
        window.decorView.systemUiVisibility =
            window.decorView.systemUiVisibility or if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR else 0
    }
}

fun Dialog.immersiveStatusBar() {
    val window = this.window ?: return
    (window.decorView as ViewGroup).setOnHierarchyChangeListener(object : ViewGroup.OnHierarchyChangeListener {
        override fun onChildViewAdded(parent: View?, child: View?) {
            if (child?.id == android.R.id.statusBarBackground) {
                child.scaleX = 0f
            }
        }
        override fun onChildViewRemoved(parent: View?, child: View?) {}
    })
}

fun Dialog.immersiveNavigationBar() {
    val window = this.window ?: return
    (window.decorView as ViewGroup).setOnHierarchyChangeListener(object : ViewGroup.OnHierarchyChangeListener {
        override fun onChildViewAdded(parent: View?, child: View?) {
            if (child?.id == android.R.id.navigationBarBackground) {
                child.scaleX = 0f
            } else if (child?.id == android.R.id.statusBarBackground) {
                child.scaleX = 0f
            }
        }

        override fun onChildViewRemoved(parent: View?, child: View?) {}
    })
}