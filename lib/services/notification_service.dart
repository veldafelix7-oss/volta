import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'battery_service.dart';

/// Fires one-shot notifications on plug / unplug events.
/// Auto-cancels after 5 seconds.
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final BatteryService battery;

  BatteryState? _lastState;
  StreamSubscription<BatteryState>? _sub;
  final Battery _batteryPlus = Battery();

  NotificationService(this.battery);

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(const InitializationSettings(android: android));

    // Request POST_NOTIFICATIONS on Android 13+
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _sub = _batteryPlus.onBatteryStateChanged.listen(_onChange);
  }

  Future<void> _onChange(BatteryState s) async {
    if (_lastState == null) {
      _lastState = s;
      return;
    }
    final wasCharging = _lastState == BatteryState.charging ||
        _lastState == BatteryState.full;
    final nowCharging =
        s == BatteryState.charging || s == BatteryState.full;

    if (!wasCharging && nowCharging) {
      await _show(
        id: 1,
        title: 'Charging started',
        body: '${battery.currentMa.abs()} mA · '
            '${battery.powerW.toStringAsFixed(2)} W',
      );
    } else if (wasCharging && !nowCharging) {
      await _show(
        id: 2,
        title: 'Charger disconnected',
        body: 'Battery at ${battery.level}%',
      );
    }
    _lastState = s;
  }

  Future<void> _show({
    required int id,
    required String title,
    required String body,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'volta_events',
        'Charging events',
        channelDescription: 'Plug in / unplug notifications',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        playSound: false,
        enableVibration: false,
        icon: '@mipmap/ic_launcher',
        timeoutAfter: 5000,
      ),
    );
    await _plugin.show(id, title, body, details);
  }

  void dispose() => _sub?.cancel();
}
