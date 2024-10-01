package info.referrer.referrer

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Parcelable
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.NewIntentListener

class ReferrerPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, NewIntentListener {
  private lateinit var channel : MethodChannel

  private  var activity: Activity? = null

  private var referrerMap: Map<String, String?>? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "referrer")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getReferrer") {
      result.success(referrerMap)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addOnNewIntentListener(  this)
    onNewIntent(binding.activity.intent)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.removeOnNewIntentListener(this);
    binding.addOnNewIntentListener(  this)
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  private fun getReferrerCompat(intent: Intent) : String? {
    return if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP_MR1){
      intent.parcelable<Uri>(Intent.EXTRA_REFERRER)?.toString()
    } else{
      intent.parcelable<Uri>("android.intent.extra.REFERRER")?.toString()
    }
  }

  private fun getReferrerNameCompat(intent: Intent) : String? {
    return if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP_MR1){
      intent.parcelable<Uri>(Intent.EXTRA_REFERRER_NAME)?.toString()
    } else{
      intent.parcelable<Uri>("android.intent.extra.REFERRER_NAME")?.toString()
    }
  }

  override fun onNewIntent(intent: Intent): Boolean {
    referrerMap = createReferrerMap(intent)
    // Return false, so that we don't interrupt other intent handler
    return false
  }

  private fun createReferrerMap(intent: Intent): Map<String, String?>? {
    val map = mapOf(
      "referrer" to getReferrerCompat(intent),
      "referrerName" to getReferrerNameCompat(intent),
      "browserName" to intent.getStringExtra("com.android.browser.application_id"),
    ).filter { it.value != null }

    if(map.isEmpty()) {
      return null
    }
    return map
  }
}

inline fun <reified T : Parcelable> Intent.parcelable(key: String): T? = when {
  android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.TIRAMISU -> getParcelableExtra(key, T::class.java)
  else -> @Suppress("DEPRECATION") getParcelableExtra(key) as? T
}