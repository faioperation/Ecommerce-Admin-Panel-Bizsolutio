import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors (Stripe/Linear inspired Indigo)
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4338CA);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primarySubtle = Color(0xFFEEF2FF);

  // Background Colors - Light
  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color sidebarLight = Color(0xFFF3F4F6);
  
  // Background Colors - Dark
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color sidebarDark = Color(0xFF0F172A);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF111827);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textTertiaryLight = Color(0xFF9CA3AF);

  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color textTertiaryDark = Color(0xFF6B7280);

  // Border & Divider
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF334155);

  // Status Colors (Success, Warning, Error, Info)
  static const Color success = Color(0xFF10B981);
  static const Color successSubtle = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSubtle = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorSubtle = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoSubtle = Color(0xFFDBEAFE);

  // Table Colors
  static const Color tableHeaderLight = Color(0xFFF3F4F6);
  static const Color tableHeaderDark = Color(0xFF0F172A);
  static const Color tableRowHoverLight = Color(0xFFF9FAFB);
  static const Color tableRowHoverDark = Color(0xFF1E293B);

  // Chart Colors (A palette for data visualization)
  static const List<Color> chartPalette = [
    Color(0xFF6366F1), // Indigo
    Color(0xFF10B981), // Emerald
    Color(0xFFF59E0B), // Amber
    Color(0xFFEF4444), // Red
    Color(0xFF8B5CF6), // Violet
    Color(0xFF06B6D4), // Cyan
    Color(0xFFEC4899), // Pink
  ];
}
