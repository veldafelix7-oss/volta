package com.volta.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.volta.app/battery"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "read") {
                    result.success(readBattery())
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun readBattery(): Map<String, Any?> {
        val bm = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val ifilter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        val intent: Intent? = registerReceiver(null as BroadcastReceiver?, ifilter)

        val currentNow = try {
            // BatteryManager returns µA. Convert to mA.
            // Sign convention differs per OEM — normalize so positive = charging.
            val uA = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW)
            val plugged = intent?.getIntExtra(BatteryManager.EXTRA_PLUGGED, 0) ?: 0
            val ma = uA / 1000
            if (plugged != 0 && ma < 0) -ma else ma
        } catch (e: Exception) { 0 }

        val voltage = intent?.getIntExtra(BatteryManager.EXTRA_VOLTAGE, 0) ?: 0
        val temp = intent?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 0) ?: 0
        val level = intent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
        val scale = intent?.getIntExtra(BatteryManager.EXTRA_SCALE, -1) ?: -1
        val pct = if (level >= 0 && scale > 0) level * 100 / scale else 0

        val plugged = intent?.getIntExtra(BatteryManager.EXTRA_PLUGGED, 0) ?: 0
        val source = when (plugged) {
            BatteryManager.BATTERY_PLUGGED_USB -> "USB"
            BatteryManager.BATTERY_PLUGGED_AC -> "AC"
            BatteryManager.BATTERY_PLUGGED_WIRELESS -> "WIRELESS"
            else -> "UNPLUGGED"
        }

        val healthInt = intent?.getIntExtra(BatteryManager.EXTRA_HEALTH,
            BatteryManager.BATTERY_HEALTH_UNKNOWN) ?: BatteryManager.BATTERY_HEALTH_UNKNOWN
        val health = when (healthInt) {
            BatteryManager.BATTERY_HEALTH_GOOD -> "GOOD"
            BatteryManager.BATTERY_HEALTH_OVERHEAT -> "OVERHEAT"
            BatteryManager.BATTERY_HEALTH_DEAD -> "DEAD"
            BatteryManager.BATTERY_HEALTH_OVER_VOLTAGE -> "OVERVOLT"
            BatteryManager.BATTERY_HEALTH_UNSPECIFIED_FAILURE -> "FAIL"
            BatteryManager.BATTERY_HEALTH_COLD -> "COLD"
            else -> "UNKNOWN"
        }

        val technology = intent?.getStringExtra(BatteryManager.EXTRA_TECHNOLOGY) ?: "Li-ion"

        // Design capacity via PowerProfile reflection
        val capacity = try {
            val cls = Class.forName("com.android.internal.os.PowerProfile")
            val ctor = cls.getConstructor(Context::class.java)
            val instance = ctor.newInstance(this)
            val method = cls.getMethod("getBatteryCapacity")
            (method.invoke(instance) as Double).toInt()
        } catch (e: Exception) {
            // Fallback: chargeCounter / level ratio if available (µAh)
            try {
                val ch = bm.getLongProperty(BatteryManager.BATTERY_PROPERTY_CHARGE_COUNTER)
                if (ch > 0 && pct > 0) (ch / 1000 * 100 / pct).toInt() else 0
            } catch (e: Exception) { 0 }
        }

        return mapOf(
            "current" to currentNow,
            "voltage" to voltage,
            "temperature" to temp,
            "level" to pct,
            "source" to source,
            "health" to health,
            "technology" to technology,
            "capacity" to capacity,
            "sdk" to Build.VERSION.SDK_INT,
        )
    }
}
