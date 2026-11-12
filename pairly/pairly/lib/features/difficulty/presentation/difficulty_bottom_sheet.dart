import 'package:flutter/material.dart';
import 'package:pairly/core/constants/app_constants.dart';
import 'package:pairly/core/theme/app_colors.dart';
import 'package:pairly/core/widgets/pairly_button.dart';
import 'package:pairly/features/game/domain/game_difficulty.dart';

/// Beş seviyeli zorluk seçimini (`showModalBottomSheet`) açan yardımcı fonksiyon.
/// Kullanıcı bir zorluk seçip "Oyunu Başlat" butonuna bastığında seçilen
/// [GameDifficulty] değerini döndürür.
Future<GameDifficulty?> showDifficultyBottomSheet(
  BuildContext context, {
  GameDifficulty initialDifficulty = GameDifficulty.medium,
}) {
  return showModalBottomSheet<GameDifficulty>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return DifficultyBottomSheet(
        initialDifficulty: initialDifficulty,
      );
    },
  );
}

/// Stitch tasarımlarına (`difficulty_light.html` & `difficulty_dark.html`) uygun
/// beş seviyeli Zorluk Seviyesi Seçimi alt penceresi.
class DifficultyBottomSheet extends StatefulWidget {
  const DifficultyBottomSheet({
    super.key,
    this.initialDifficulty = GameDifficulty.medium,
  });

  final GameDifficulty initialDifficulty;

  @override
  State<DifficultyBottomSheet> createState() => _DifficultyBottomSheetState();
}

class _DifficultyBottomSheetState extends State<DifficultyBottomSheet> {
  late GameDifficulty _selectedDifficulty;

  @override
  void initState() {
    super.initState();
    _selectedDifficulty = widget.initialDifficulty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sheetBg = isDark ? AppColors.darkSurfaceLow : AppColors.surface;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.surface;
    final selectedCardBg = isDark
        ? const Color(0xFF2E3C32)
        : AppColors.surfaceVariant;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final primaryAccent = isDark ? AppColors.darkPrimary : AppColors.primary;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return SafeArea(
      top: false,
      child: Center(
        heightFactor: 1.0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Container(
            decoration: BoxDecoration(
              color: sheetBg,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              border: Border(
                top: BorderSide(color: borderColor),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(
              AppConstants.defaultPadding,
              12,
              AppConstants.defaultPadding,
              20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Üst Tutamaç Çubuğu
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: borderColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Başlık ve Kapat Butonu
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Zorluk Seviyesi',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Hafıza matrisini ve oyun modunu belirleyin.',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded, size: 20),
                        tooltip: 'Kapat',
                        style: IconButton.styleFrom(
                          backgroundColor: cardBg,
                          foregroundColor: textSecondary,
                          minimumSize: const Size(34, 34),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 5 Zorluk Seviyesi Listesi
                  ...GameDifficulty.values.map((level) {
                    final isSelected = level == _selectedDifficulty;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          setState(() {
                            _selectedDifficulty = level;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? selectedCardBg : cardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? primaryAccent : borderColor,
                              width: isSelected ? 2.0 : 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkBackground
                                      : AppColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? primaryAccent.withValues(alpha: 0.5)
                                        : borderColor,
                                  ),
                                ),
                                child: Text(
                                  level.gridBadge,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: isSelected
                                        ? primaryAccent
                                        : textSecondary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      level.label,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      level.subtitle,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: isSelected
                                            ? FontWeight.w500
                                            : FontWeight.w400,
                                        color: isSelected
                                            ? primaryAccent
                                            : textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 20,
                                  color: primaryAccent,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 8),

                  // Oyunu Başlat CTA Butonu
                  PairlyButton(
                    label: 'Oyunu Başlat',
                    icon: Icons.play_arrow_rounded,
                    onPressed: () =>
                        Navigator.of(context).pop(_selectedDifficulty),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
