import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Single source of truth for battery telemetry.
/// Polls every 500 ms via a Kotlin MethodChannel and battery_plus stream.
class BatteryService extends ChangeNotifier {
  static const _channel = MethodChannel('com.volta.app/battery');

  final Battery _battery = Battery();
  Timer? _timer;
  StreamSubscription<BatteryState>? _stateSub;

  // Public telemetry ----------------------------------------------------------
  int currentMa = 0;            // signed: + charging, - discharging
  double voltageV = 0;          // volts
  double temperatureC = 0;      // °C
  int level = 0;                // %
  String source = 'UNPLUGGED';  // USB / AC / WIRELESS / UNPLUGGED
  String health = 'GOOD';
  String technology = 'Li-ion';
  int capacityMah = 0;
  BatteryState state = BatteryState.unknown;

  double get powerW =>
      (voltageV * (currentMa.abs() / 1000.0)).clamp(0, 999);

  bool get isCharging =>
      state == BatteryState.charging || state == BatteryState.full;

  String get statusWord {
    switch (state) {
      case BatteryState.charging:
        return 'CHARGING';
      case BatteryState.full:
        return 'FULL';
      case BatteryState.discharging:
      case BatteryState.unknown:
      default:
        return 'DISCHARGING';
    }
  }

  Future<void> start() async {
    // Initial pull
    await _pull();

    // Poll every 500 ms
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) => _pull());

    // Listen to plug/unplug events for notifications elsewhere
    _stateSub = _battery.onBatteryStateChanged.listen((s) {
      state = s;
      notifyListeners();
    });
  }

  Future<void> _pull() async {
    try {
      final Map<Object?, Object?>? data =
          await _channel.invokeMapMethod<Object?, Object?>('read');
      if (data != null) {
        currentMa = (data['current'] as num?)?.toInt() ?? currentMa;
        voltageV = ((data['voltage'] as num?)?.toDouble() ?? 0) / 1000.0;
        temperatureC = ((data['temperature'] as num?)?.toDouble() ?? 0) / 10.0;
        level = (data['level'] as num?)?.toInt() ?? level;
        source = (data['source'] as String?) ?? source;
        health = (data['health'] as String?) ?? health;
        technology = (data['technology'] as String?) ?? technology;
        capacityMah = (data['capacity'] as num?)?.toInt() ?? capacityMah;
      }
      state = await _battery.batteryState;
    } catch (_) {
      // Silent — keep last known values.
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stateSub?.cancel();
    super.dispose();
  }
}
