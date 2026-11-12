import 'package:flutter/material.dart';
import 'package:pairly/core/constants/app_constants.dart';
import 'package:pairly/core/services/feedback_service.dart';
import 'package:pairly/core/state/app_settings_controller.dart';
import 'package:pairly/core/state/notifier_scope.dart';
import 'package:pairly/core/theme/app_colors.dart';
import 'package:pairly/core/widgets/pairly_button.dart';

/// Tema (Light / Dark / Sistem), ses efektleri ve dokunsal geri bildirim
/// ayarlarını içeren modal bottom sheet'i açar.
Future<void> showSettingsBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const SettingsBottomSheet(),
  );
}

/// Stitch oyun ayarları tasarımına (`game_light.html` & `game_dark.html`) uygun,
/// aynı zamanda Light/Dark/System tema seçimi sağlayan ayarlar paneli.
class SettingsBottomSheet extends StatelessWidget {
  const SettingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = NotifierScope.watch<AppSettingsController>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sheetBg = isDark ? AppColors.darkSurface : AppColors.surface;
    final tileBg = isDark ? AppColors.darkBackground : AppColors.surfaceVariant;
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
              border: Border(top: BorderSide(color: borderColor)),
            ),
            padding: const EdgeInsets.fromLTRB(
              AppConstants.defaultPadding,
              12,
              AppConstants.defaultPadding,
              24,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                  // Başlık Satırı
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.tune_rounded,
                            color: primaryAccent,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Oyun Ayarları',
                            style: theme.textTheme.titleLarge,
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded, size: 20),
                        tooltip: 'Kapat',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Tema Seçimi (Açık / Koyu / Sistem)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: tileBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.palette_outlined,
                              size: 20,
                              color: primaryAccent,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Tema Görünümü',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _ThemeModeChip(
                              label: 'Sistem',
                              icon: Icons.brightness_auto_rounded,
                              isSelected:
                                  settings.themeMode == ThemeMode.system,
                              onTap: () =>
                                  settings.setThemeMode(ThemeMode.system),
                            ),
                            const SizedBox(width: 8),
                            _ThemeModeChip(
                              label: 'Açık',
                              icon: Icons.light_mode_rounded,
                              isSelected: settings.themeMode == ThemeMode.light,
                              onTap: () =>
                                  settings.setThemeMode(ThemeMode.light),
                            ),
                            const SizedBox(width: 8),
                            _ThemeModeChip(
                              label: 'Koyu',
                              icon: Icons.dark_mode_rounded,
                              isSelected: settings.themeMode == ThemeMode.dark,
                              onTap: () =>
                                  settings.setThemeMode(ThemeMode.dark),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Ses Efektleri Anahtarı
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: tileBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          settings.soundEnabled
                              ? Icons.volume_up_rounded
                              : Icons.volume_off_rounded,
                          color: primaryAccent,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ses Efektleri',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary,
                                ),
                              ),
                              Text(
                                'Kart çevirme ve eşleşme sesleri',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: settings.soundEnabled,
                          activeThumbColor: primaryAccent,
                          onChanged: settings.setSoundEnabled,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Dokunsal Geri Bildirim Anahtarı
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: tileBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.vibration_rounded,
                          color: primaryAccent,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dokunsal Geri Bildirim',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary,
                                ),
                              ),
                              Text(
                                FeedbackService.isHapticSupportedOnPlatform
                                    ? 'Hamle ve titreşim geri bildirimleri'
                                    : 'Mobil cihazlarda titreşim desteği',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: settings.hapticEnabled,
                          activeThumbColor: primaryAccent,
                          onChanged: settings.setHapticEnabled,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  PairlyButton(
                    label: 'Tamam',
                    onPressed: () => Navigator.of(context).pop(),
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

class _ThemeModeChip extends StatelessWidget {
  const _ThemeModeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.darkPrimary : AppColors.primary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryAccent
                : (isDark ? AppColors.darkSurface : AppColors.surface),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? primaryAccent : borderColor,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? (isDark ? AppColors.darkOnPrimary : Colors.white)
                    : textPrimary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? (isDark ? AppColors.darkOnPrimary : Colors.white)
                        : textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
