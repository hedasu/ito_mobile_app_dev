import 'package:flutter/material.dart';
import 'package:pairly/core/constants/app_constants.dart';
import 'package:pairly/core/theme/app_colors.dart';

/// Pairly uygulama logosunu gösteren tekrar kullanılabilir (reusable) widget.
/// Sadece ikon olarak veya yanındaki 'Pairly' marka metniyle ([showText]) kullanılabilir.
class PairlyLogo extends StatelessWidget {
  const PairlyLogo({
    super.key,
    this.size = 36.0,
    this.borderRadius,
    this.showText = false,
  });

  /// Logo görselinin genişlik ve yükseklik boyutu.
  final double size;

  /// Özel köşe yuvarlaklığı. Belirtilmezse boyuta göre orantılı hesaplanır.
  final double? borderRadius;

  /// Logonun yanında uygulama başlığının ('Pairly') gösterilip gösterilmeyeceği.
  final bool showText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectiveRadius = borderRadius ?? (size * 0.24);

    final logoBox = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(effectiveRadius),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        AppConstants.logoAssetPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        semanticLabel: '${AppConstants.appName} Logo',
      ),
    );

    if (!showText) {
      return logoBox;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        logoBox,
        const SizedBox(width: 10),
        Text(
          AppConstants.appName,
          style: theme.textTheme.headlineMedium,
        ),
      ],
    );
  }
}
