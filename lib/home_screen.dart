import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'services/battery_service.dart';
import 'theme/app_theme.dart';
import 'widgets/top_bar.dart';
import 'widgets/hero_current.dart';
import 'widgets/stat_card.dart';
import 'widgets/footer_strip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entry;

  @override
  void initState() {
    super.initState();
    _entry = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _entry.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = context.watch<BatteryService>();

    final cards = <_CardData>[
      _CardData('VOLTAGE', '${b.voltageV.toStringAsFixed(2)} V'),
      _CardData('POWER', '${b.powerW.toStringAsFixed(2)} W'),
      _CardData(
        'TEMP',
        '${b.temperatureC.toStringAsFixed(1)} °C',
        icon: Icon(PhosphorIcons.thermometer(),
            size: 14, color: AppColors.textSecondary),
      ),
      _CardData('LEVEL', '${b.level} %'),
      _CardData('HEALTH', b.health),
      _CardData('CAPACITY',
          b.capacityMah > 0 ? '${b.capacityMah} mAh' : '— mAh'),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TopBar(),
              const SizedBox(height: 24),
              const HeroCurrent(),
              const SizedBox(height: 32),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.outer),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cards.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.gap,
                    crossAxisSpacing: AppSpacing.gap,
                    childAspectRatio: 1.7,
                  ),
                  itemBuilder: (_, i) {
                    final start = (i * 0.06).clamp(0.0, 0.7);
                    final anim = CurvedAnimation(
                      parent: _entry,
                      curve: Interval(start, (start + 0.4).clamp(0.0, 1.0),
                          curve: Curves.easeOutCubic),
                    );
                    return AnimatedBuilder(
                      animation: anim,
                      builder: (_, child) => Opacity(
                        opacity: anim.value,
                        child: Transform.translate(
                          offset: Offset(0, (1 - anim.value) * 12),
                          child: child,
                        ),
                      ),
                      child: StatCard(
                        label: cards[i].label,
                        value: cards[i].value,
                        trailingIcon: cards[i].icon,
                      ),
                    );
                  },
                ),
              ),
              const FooterStrip(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardData {
  final String label;
  final String value;
  final Widget? icon;
  _CardData(this.label, this.value, {this.icon});
}

