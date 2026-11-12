import 'package:flutter/material.dart';

/// Pairly tasarım sisteminde belirlenen merkezi renk paleti (Light & Dark Mode).
abstract final class AppColors {
  // Light Mode renk paleti (PROJECT.md & DESIGN_light.md)
  /// Ana arka plan rengi (`#F7F7F5`).
  static const Color background = Color(0xFFF7F7F5);

  /// Ana vurgu ve aksiyon rengi (`#5A6D5E` / `#657568`).
  static const Color primary = Color(0xFF5A6D5E);

  /// İkincil adaçayı yeşili vurgu rengi (`#8A9A86`).
  static const Color secondary = Color(0xFF8A9A86);

  /// Birincil metin rengi (`#252925`).
  static const Color textPrimary = Color(0xFF252925);

  /// İkincil/yardımcı metin rengi (`#6B726A`).
  static const Color textSecondary = Color(0xFF6B726A);

  /// Kart ve yüzey arka plan rengi (`#FFFFFF`).
  static const Color surface = Color(0xFFFFFFFF);

  /// İkincil hafif yüzey rengi (`#F2F5EE`).
  static const Color surfaceVariant = Color(0xFFF2F5EE);

  /// Kart kenarlığı ve ayırıcı çizgi rengi (`#E6E6E2`).
  static const Color border = Color(0xFFE6E6E2);

  // Dark Mode renk paleti (DESIGN_dark.md & home_dark.html)
  /// Koyu mod ana arka plan rengi (`#171D1A`).
  static const Color darkBackground = Color(0xFF171D1A);

  /// Koyu mod kart ve yüzey rengi (`#252E28`).
  static const Color darkSurface = Color(0xFF252E28);

  /// Koyu mod alt/iç yüzey rengi (`#1B211E`).
  static const Color darkSurfaceLow = Color(0xFF1B211E);

  /// Koyu mod ana vurgu rengi (`#A5BBA6`).
  static const Color darkPrimary = Color(0xFFA5BBA6);

  /// Koyu mod ana buton üzerindeki koyu metin rengi (`#171D1A`).
  static const Color darkOnPrimary = Color(0xFF171D1A);

  /// Koyu mod birincil metin rengi (`#F1F4EF`).
  static const Color darkTextPrimary = Color(0xFFF1F4EF);

  /// Koyu mod ikincil/yardımcı metin rengi (`#8E9B90`).
  static const Color darkTextSecondary = Color(0xFF8E9B90);

  /// Koyu mod kenarlık rengi (`#3B483F`).
  static const Color darkBorder = Color(0xFF3B483F);
}
