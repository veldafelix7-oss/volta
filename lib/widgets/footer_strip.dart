import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/battery_service.dart';
import '../theme/app_theme.dart';

class FooterStrip extends StatelessWidget {
  const FooterStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final b = context.watch<BatteryService>();
    final statusColor = (b.statusWord == 'CHARGING' || b.statusWord == 'FULL')
        ? AppColors.primary
        : AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(b.technology, style: AppTheme.footer),
          const SizedBox(width: 10),
          Text('•', style: AppTheme.footer),
          const SizedBox(width: 10),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: AppTheme.footer.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.5,
            ),
            child: Text(b.statusWord),
          ),
        ],
      ),
    );
  }
}
