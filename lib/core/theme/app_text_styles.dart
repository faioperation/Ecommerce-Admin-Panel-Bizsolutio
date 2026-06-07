import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Base font family: Inter (Popular in Notion/Linear)
  static final TextStyle _base = GoogleFonts.inter();

  // Headings
  static TextStyle h1 = _base.copyWith(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5);
  static TextStyle h2 = _base.copyWith(fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: -0.5);
  static TextStyle h3 = _base.copyWith(fontSize: 20, fontWeight: FontWeight.w600);
  static TextStyle h4 = _base.copyWith(fontSize: 18, fontWeight: FontWeight.w600);
  static TextStyle h5 = _base.copyWith(fontSize: 16, fontWeight: FontWeight.w600);

  // Body Text
  static TextStyle bodyLg = _base.copyWith(fontSize: 16, fontWeight: FontWeight.w400);
  static TextStyle body = _base.copyWith(fontSize: 14, fontWeight: FontWeight.w400);
  static TextStyle bodySm = _base.copyWith(fontSize: 13, fontWeight: FontWeight.w400);
  static TextStyle caption = _base.copyWith(fontSize: 12, fontWeight: FontWeight.w400);

  // Label/Button Text
  static TextStyle button = _base.copyWith(fontSize: 14, fontWeight: FontWeight.w500);
  static TextStyle overline = _base.copyWith(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5);
}
