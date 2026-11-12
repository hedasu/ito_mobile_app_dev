import 'package:flutter/material.dart';
import 'package:pairly/core/constants/app_constants.dart';
import 'package:pairly/core/theme/app_colors.dart';
import 'package:pairly/core/widgets/pairly_button.dart';
import 'package:pairly/core/widgets/pairly_logo.dart';
import 'package:pairly/core/widgets/settings_bottom_sheet.dart';
import 'package:pairly/features/difficulty/presentation/difficulty_bottom_sheet.dart';
import 'package:pairly/features/game/presentation/game_screen.dart';
import 'package:pairly/features/home/presentation/widgets/home_hero_cards.dart';
import 'package:pairly/features/statistics/presentation/statistics_screen.dart';

/// Pairly Ana Sayfa (HomeScreen) ekranı.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    this.onStartGamePressed,
    this.onStatisticsPressed,
  });

  /// Özel "Oyuna Başla" geri çağrısı (belirtilmezse `DifficultyBottomSheet` açar).
  final VoidCallback? onStartGamePressed;

  /// Özel "İstatistikler" geri çağrısı (belirtilmezse `StatisticsScreen`'e gider).
  final VoidCallback? onStatisticsPressed;

  Future<void> _handleStartGame(BuildContext context) async {
    if (onStartGamePressed != null) {
      onStartGamePressed!();
      return;
    }

    final selectedDifficulty = await showDifficultyBottomSheet(context);
    if (selectedDifficulty == null || !context.mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GameScreen(initialDifficulty: selectedDifficulty),
      ),
    );
  }

  Future<void> _handleStatistics(BuildContext context) async {
    if (onStatisticsPressed != null) {
      onStatisticsPressed!();
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (statsRouteContext) => StatisticsScreen(
          onStartGameRequested: () async {
            Navigator.of(statsRouteContext).pop();
            if (!context.mounted) return;
            await _handleStartGame(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.surface;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final iconColor = isDark ? AppColors.darkTextPrimary : AppColors.primary;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
                vertical: 16,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: (constraints.maxHeight - 32).clamp(
                    0.0,
                    double.infinity,
                  ),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppConstants.maxContentWidth,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Üst Marka Barı (Logo + Pairly + Ayarlar/Tema İkonu)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: SizedBox(
                            height: 40,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Center(
                                  child: PairlyLogo(
                                    size: 34,
                                    showText: true,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Tooltip(
                                    message: 'Ayarlar ve Tema',
                                    child: InkWell(
                                      customBorder: const CircleBorder(),
                                      onTap: () =>
                                          showSettingsBottomSheet(context),
                                      child: Container(
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: surface,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: border),
                                        ),
                                        child: Icon(
                                          Icons.tune_rounded,
                                          size: 19,
                                          color: iconColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Orta Bölüm: Kart İllüstrasyonu ve "Hafızanı keşfet" Başlığı
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const HomeHeroCards(),
                            const SizedBox(height: 24),
                            Text(
                              AppConstants.homeTitle,
                              textAlign: TextAlign.center,
                              style: textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppConstants.homeDescription,
                              textAlign: TextAlign.center,
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Alt Aksiyon Butonları ("Oyuna Başla" & "İstatistikler")
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PairlyButton(
                                label: AppConstants.startGameLabel,
                                icon: Icons.play_arrow_rounded,
                                variant: PairlyButtonVariant.primary,
                                onPressed: () => _handleStartGame(context),
                              ),
                              const SizedBox(height: 12),
                              PairlyButton(
                                label: AppConstants.statisticsLabel,
                                icon: Icons.bar_chart_rounded,
                                variant: PairlyButtonVariant.secondary,
                                onPressed: () => _handleStatistics(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
