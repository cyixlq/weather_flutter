@file:Suppress("DEPRECATION")

package top.cyixlq.weather.weather_flutter.utils

import android.annotation.SuppressLint
import android.app.Activity
import android.graphics.Color
import android.os.Build
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.FrameLayout
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.Observer
import top.cyixlq.weather.weather_flutter.R

class SystemBarUtil private constructor(private val activity: Activity) {

    companion object {
        private const val TAG = "SystemBarUtil"
        private const val STATUS_BAR_MASK_COLOR = 0x7F000000
        private const val ID_NAV_BAR = R.id.navigation_bar_view
        private const val ID_STATUS_BAR = R.id.status_bar_view

        fun create(activity: Activity): SystemBarUtil = SystemBarUtil(activity)
    }

    private val highLiveData = MutableLiveData<NavParam>()
    private val window = activity.window
    private val rootView: ViewGroup = (window.decorView as ViewGroup).getChildAt(0) as ViewGroup
    @SuppressLint("RtlHardcoded")
    private val fitNavBarObserver = Observer<NavParam> {
        val content = rootView.findViewById<View>(androidx.appcompat.R.id.decor_content_parent)
        when (it.gravity) {
            Gravity.BOTTOM -> content.setPadding(0, content.paddingTop, 0, it.high)
            Gravity.LEFT -> content.setPadding(it.high, content.paddingTop, 0, 0)
            Gravity.RIGHT -> content.setPadding(0, content.paddingTop, it.high, 0)
        }
    }

    init {
        (window.decorView as ViewGroup).setOnHierarchyChangeListener(object : ViewGroup.OnHierarchyChangeListener {
            override fun onChildViewAdded(parent: View?, child: View?) {
                if (child?.id == android.R.id.navigationBarBackground) {
                    window.decorView.findViewById<View>(ID_NAV_BAR).bringToFront()
                    child.addOnLayoutChangeListener { _, left, top, right, bottom, _, _, _, _ ->
                        child.scaleX = 0f
                        val lp = child.layoutParams as FrameLayout.LayoutParams
                        window.decorView.findViewById<View>(ID_NAV_BAR).layoutParams = child.layoutParams
                        if (lp.gravity == Gravity.BOTTOM) {
                            highLiveData.value = NavParam(lp.gravity, bottom - top)
                        } else {
                            highLiveData.value = NavParam(lp.gravity, right - left)
                        }
                    }
                } else if (child?.id == android.R.id.statusBarBackground) {
                    child.scaleX = 0f
                }
            }
            override fun onChildViewRemoved(parent: View?, child: View?) {}
        })
    }

    fun immersiveStatusBar() {
        window.decorView.findViewById(R.id.status_bar_view) ?: View(window.context).apply {
            id = R.id.status_bar_view
            val params = FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, getStatusBarHeight())
            params.gravity = Gravity.TOP
            layoutParams = params
            (window.decorView as ViewGroup).addView(this)
        }
        setStatusBarColor(Color.TRANSPARENT)
    }

    fun immersiveNavigationBar() {
        window.decorView.findViewById(R.id.navigation_bar_view) ?: View(window.context).apply {
            id = R.id.navigation_bar_view
            (window.decorView as ViewGroup).addView(this)
        }
        setNavigationBarColor(Color.TRANSPARENT)
    }

    @SuppressLint("ObsoleteSdkInt")
    fun setLightNavigationBar(isLightingColor: Boolean) {
        val window = activity.window
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (isLightingColor) {
                window.decorView.systemUiVisibility =
                    window.decorView.systemUiVisibility or if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR else 0
            } else {
                window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_LAYOUT_STABLE
            }
        }
    }

    @SuppressLint("ObsoleteSdkInt")
    fun setLightStatusBar(isLightingColor: Boolean) {
        val window = activity.window
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (isLightingColor) {
                window.decorView.systemUiVisibility =
                    View.SYSTEM_UI_FLAG_LAYOUT_STABLE or View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR
            } else {
                window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_LAYOUT_STABLE
            }
        }
    }

    fun fitStatusBar(fit: Boolean) {
        val content = rootView.findViewById<View>(androidx.appcompat.R.id.decor_content_parent)
        if (fit) {
            content.setPadding(0, getStatusBarHeight(), 0, content.paddingBottom)
        } else {
            content.setPadding(0, 0, 0, content.paddingBottom)
        }
    }

    fun fitNavigationBar(fit: Boolean) {
        val content = rootView.findViewById<View>(androidx.appcompat.R.id.decor_content_parent)
        if (fit) {
            if (activity is LifecycleOwner) {
                highLiveData.observe(activity, fitNavBarObserver)
            }
        } else {
            highLiveData.removeObserver(fitNavBarObserver)
            content.setPadding(0, content.paddingTop, 0, 0)
        }
    }

    @SuppressLint("ObsoleteSdkInt")
    fun setStatusBarColor(color: Int) {
        val statusBarView = activity.window.decorView.findViewById<View?>(ID_STATUS_BAR)
        if (color == 0 && Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            statusBarView?.setBackgroundColor(STATUS_BAR_MASK_COLOR)
        } else {
            statusBarView?.setBackgroundColor(color)
        }
        statusBarView?.bringToFront()
    }

    fun setNavigationBarColor(color: Int) {
        val navigationBarView = activity.window.decorView.findViewById<View?>(ID_NAV_BAR)
        if (color == 0 && Build.VERSION.SDK_INT <= Build.VERSION_CODES.M) {
            navigationBarView?.setBackgroundColor(STATUS_BAR_MASK_COLOR)
        } else {
            navigationBarView?.setBackgroundColor(color)
        }
        navigationBarView?.bringToFront()
    }

    fun getStatusBarHeight(): Int {
        val resourceId = activity.resources.getIdentifier("status_bar_height", "dimen", "android")
        if (resourceId > 0) {
            return activity.resources.getDimensionPixelSize(resourceId)
        }
        return 0
    }

    fun getNavigationBarHigh(): Int = highLiveData.value?.high ?: 0

    fun getNavigationBarHeightLiveData(): LiveData<NavParam> = highLiveData

    fun isImmersiveNavigationBar(): Boolean  = activity.window.attributes.flags and WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION != 0

    data class NavParam(
        val gravity: Int,
        val high: Int
    )
}