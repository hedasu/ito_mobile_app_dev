import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pairly/core/theme/app_colors.dart';

/// Ana sayfada (HomeScreen) başlığın üzerinde yer alan,
/// Light ve Dark Mode uyumlu ikili hafıza kartı illüstrasyonu.
class HomeHeroCards extends StatelessWidget {
  const HomeHeroCards({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardSurface = isDark ? AppColors.darkSurface : AppColors.surface;
    final innerBadgeBg =
        isDark ? AppColors.darkSurfaceLow : AppColors.surfaceVariant;
    final primaryAccent = isDark ? AppColors.darkPrimary : AppColors.primary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final mutedColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return SizedBox(
      width: 240,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Yumuşak arka plan ışıması (Nordic halo)
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primaryAccent.withValues(alpha: isDark ? 0.12 : 0.10),
                  blurRadius: 40,
                  spreadRadius: 8,
                ),
              ],
            ),
          ),

          // Arkadaki eğimli ikincil kart
          Transform.translate(
            offset: const Offset(18, -8),
            child: Transform.rotate(
              angle: -12 * math.pi / 180,
              child: Opacity(
                opacity: 0.85,
                child: Container(
                  width: 136,
                  height: 184,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cardSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.35 : 0.05,
                        ),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.spa_outlined,
                            size: 14,
                            color: mutedColor.withValues(alpha: 0.6),
                          ),
                          Icon(
                            Icons.auto_awesome,
                            size: 12,
                            color: mutedColor.withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: borderColor),
                        ),
                        child: Icon(
                          Icons.all_inclusive,
                          size: 20,
                          color: mutedColor.withValues(alpha: 0.7),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 12,
                            color: mutedColor.withValues(alpha: 0.6),
                          ),
                          Icon(
                            Icons.spa_outlined,
                            size: 14,
                            color: mutedColor.withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Öndeki aktif kart
          Transform.translate(
            offset: const Offset(-12, 6),
            child: Transform.rotate(
              angle: 6 * math.pi / 180,
              child: Container(
                width: 136,
                height: 184,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cardSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: primaryAccent.withValues(alpha: 0.45),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.45 : 0.08,
                      ),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.filter_vintage_outlined,
                          size: 15,
                          color: primaryAccent,
                        ),
                        Text(
                          'PAIR',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: primaryAccent,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: innerBadgeBg,
                        shape: BoxShape.circle,
                        border: Border.all(color: borderColor),
                      ),
                      child: Icon(
                        Icons.eco_outlined,
                        size: 28,
                        color: primaryAccent,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.park_outlined,
                          size: 15,
                          color: primaryAccent,
                        ),
                        Icon(
                          Icons.filter_vintage_outlined,
                          size: 15,
                          color: primaryAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

