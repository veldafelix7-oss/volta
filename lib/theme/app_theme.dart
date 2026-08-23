import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Volta color palette — off-white + warm mustard. No other colors allowed.
class AppColors {
  static const background = Color(0xFFFAFAF7); // off-white cream
  static const surface = Color(0xFFF2EFE6);    // soft paper card
  static const border = Color(0xFFE4DFD0);     // subtle divider
  static const primary = Color(0xFFC89B2A);    // mustard gold
  static const accent = Color(0xFFB8860B);     // deeper accent for live element
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF7A756A);
}

class AppSpacing {
  static const double outer = 24;
  static const double inner = 16;
  static const double gap = 12;
  static const double radiusCard = 16;
  static const double radiusChip = 8;
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        surface: AppColors.surface,
        onPrimary: AppColors.background,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
    );
  }

  // Text presets --------------------------------------------------------------
  static TextStyle hero = GoogleFonts.spaceGrotesk(
    fontSize: 96,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
    height: 1,
  );

  static TextStyle cardValue = GoogleFonts.spaceGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.1,
  );

  static TextStyle labelSmall = GoogleFonts.spaceGrotesk(
    fontSize: 11,
    fontWeight: FontWeight.w300,
    letterSpacing: 2,
    color: AppColors.primary,
  );

  static TextStyle wordmark = GoogleFonts.spaceGrotesk(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 4,
    color: AppColors.textPrimary,
  );

  static TextStyle footer = GoogleFonts.spaceGrotesk(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
    color: AppColors.textSecondary,
  );
}
