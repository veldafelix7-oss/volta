import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../services/battery_service.dart';
import '../theme/app_theme.dart';
import 'particle_field.dart';

class HeroCurrent extends StatefulWidget {
  const HeroCurrent({super.key});

  @override
  State<HeroCurrent> createState() => _HeroCurrentState();
}

class _HeroCurrentState extends State<HeroCurrent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  int _prevMa = 0;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = context.watch<BatteryService>();
    final ma = b.currentMa.abs();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (b.isCharging)
              FadeTransition(
                opacity: Tween<double>(begin: 0.5, end: 1.0)
                    .animate(CurvedAnimation(
                        parent: _pulse, curve: Curves.easeInOut)),
                child: Padding(
                  padding: const EdgeInsets.only(right: 12, top: 8),
                  child: Icon(
                    PhosphorIcons.lightning(PhosphorIconsStyle.fill),
                    size: 28,
                    color: AppColors.primary,
                  ),
                ),
              ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: _prevMa.toDouble(), end: ma.toDouble()),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              onEnd: () => _prevMa = ma,
              builder: (_, v, __) => Text(
                _format(v.round()),
                style: AppTheme.hero,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text('mA', style: AppTheme.labelSmall.copyWith(letterSpacing: 3)),
        const SizedBox(height: 16),
        ParticleField(
          currentMa: b.currentMa,
          active: b.isCharging,
          height: 160,
        ),
      ],
    );
  }

  String _format(int v) {
    // Thin-space thousands separator for premium look.
    final s = v.toString();
    if (s.length <= 3) return s;
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('\u2009');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
