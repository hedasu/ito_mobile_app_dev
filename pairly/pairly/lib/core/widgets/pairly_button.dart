import 'package:flutter/material.dart';
import 'package:pairly/core/constants/app_constants.dart';
import 'package:pairly/core/theme/app_colors.dart';

/// Buton görünüm tipleri.
enum PairlyButtonVariant {
  /// Ana aksiyon butonu (dolgulu, birincil vurgu rengi).
  primary,

  /// İkincil aksiyon butonu (yüzey rengi ve ince kenarlık).
  secondary,
}

/// Pairly tasarım sistemine uygun, tekrar kullanılabilir (reusable) hap (pill) buton.
class PairlyButton extends StatelessWidget {
  const PairlyButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = PairlyButtonVariant.primary,
    this.isFullWidth = true,
  });

  /// Buton üzerinde gösterilecek metin.
  final String label;

  /// Tıklama aksiyonu.
  final VoidCallback? onPressed;

  /// Metnin solunda gösterilecek opsiyonel ikon.
  final IconData? icon;

  /// Butonun stil varyantı (primary veya secondary).
  final PairlyButtonVariant variant;

  /// Butonun yatayda tüm genişliği kaplayıp kaplamayacağı.
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: variant == PairlyButtonVariant.primary ? 22 : 20,
            color: variant == PairlyButtonVariant.secondary
                ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                : null,
          ),
          const SizedBox(width: 10),
        ],
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    final Widget button = switch (variant) {
      PairlyButtonVariant.primary => ElevatedButton(
          onPressed: onPressed,
          child: content,
        ),
      PairlyButtonVariant.secondary => OutlinedButton(
          onPressed: onPressed,
          child: content,
        ),
    };

    if (!isFullWidth) {
      return SizedBox(
        height: AppConstants.buttonHeight,
        child: button,
      );
    }

    return SizedBox(
      width: double.infinity,
      height: AppConstants.buttonHeight,
      child: button,
    );
  }
}

