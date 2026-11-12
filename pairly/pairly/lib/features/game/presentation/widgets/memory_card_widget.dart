import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pairly/core/theme/app_colors.dart';
import 'package:pairly/features/game/domain/memory_card_item.dart';

/// 3B çevirme (flip) animasyonlu hafıza kartı widget'ı.
///
/// Kapalı yüzünde Stitch tasarımına uygun (`?` rozetli) sade arka yüz,
/// açık yüzünde ise sembol ve eşleşme onay rozeti (`✓`) gösterilir.
class MemoryCardWidget extends StatelessWidget {
  const MemoryCardWidget({
    super.key,
    required this.card,
    required this.onTap,
  });

  final MemoryCardItem card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(
          begin: 0,
          end: card.isFaceUp ? 1.0 : 0.0,
        ),
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        builder: (context, value, _) {
          final angle = value * math.pi;
          final showFront = value >= 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: showFront
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: _CardFrontFace(card: card, isDark: isDark),
                  )
                : _CardBackFace(isDark: isDark),
          );
        },
      ),
    );
  }
}

class _CardBackFace extends StatelessWidget {
  const _CardBackFace({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final accentColor = isDark ? AppColors.darkPrimary : AppColors.primary;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? AppColors.darkBackground.withValues(alpha: 0.5)
                : AppColors.surfaceVariant,
            border: Border.all(
              color: accentColor.withValues(alpha: 0.35),
            ),
          ),
          child: Text(
            '?',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: accentColor.withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardFrontFace extends StatelessWidget {
  const _CardFrontFace({
    required this.card,
    required this.isDark,
  });

  final MemoryCardItem card;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final primaryAccent = isDark ? AppColors.darkPrimary : AppColors.primary;
    final bgColor = card.isMatched
        ? (isDark ? const Color(0xFF1E2E24) : const Color(0xFFE2ECE4))
        : (isDark ? AppColors.darkSurface : AppColors.surface);
    final borderColor = card.isMatched
        ? primaryAccent.withValues(alpha: isDark ? 0.85 : 0.55)
        : primaryAccent;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor,
          width: card.isMatched ? 1.5 : 2.0,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                card.symbol,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          if (card.isMatched)
            Positioned(
              top: 5,
              right: 5,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: primaryAccent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 11,
                  color: isDark ? AppColors.darkOnPrimary : Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
