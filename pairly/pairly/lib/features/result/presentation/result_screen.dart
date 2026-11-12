import 'package:flutter/material.dart';
import 'package:pairly/core/constants/app_constants.dart';
import 'package:pairly/core/theme/app_colors.dart';
import 'package:pairly/core/widgets/pairly_button.dart';
import 'package:pairly/core/widgets/pairly_logo.dart';
import 'package:pairly/features/game/domain/game_difficulty.dart';
import 'package:pairly/features/game/presentation/game_controller.dart';
import 'package:pairly/features/statistics/domain/statistics_models.dart';

/// Oyun tamamlandığında açılan Sonuç Ekranı (`result_light.html` & `result_dark.html`).
class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.difficulty,
    required this.durationSeconds,
    required this.moves,
    required this.outcome,
    required this.onPlayAgain,
    required this.onHome,
  });

  final GameDifficulty difficulty;
  final int durationSeconds;
  final int moves;
  final GameCompletionOutcome outcome;
  final VoidCallback onPlayAgain;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardSurface = isDark ? AppColors.darkSurface : AppColors.surface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final primaryAccent = isDark ? AppColors.darkPrimary : AppColors.primary;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final formattedTime = GameController.formatSeconds(durationSeconds);
    final bestRecord = outcome.bestRecordAfterGame;
    final bestFormattedTime = bestRecord != null
        ? GameController.formatSeconds(bestRecord.bestTimeSeconds)
        : formattedTime;
    final bestMoves = bestRecord?.fewestMoves ?? moves;
    final timeImprovement = outcome.timeImprovementSeconds;

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
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Üst Marka Barı
                        const PairlyLogo(size: 30, showText: true),

                        const SizedBox(height: 20),

                        // Orta Bölüm: İllüstrasyon, Başlık, Rozetler ve Performans Kartı
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _ResultMatchedCardsIllustration(isDark: isDark),
                            const SizedBox(height: 20),
                            Text(
                              'Tebrikler!',
                              style: theme.textTheme.headlineLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Tüm kartları eşleştirdin.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),

                            // Seviye ve Rekor Rozetleri
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: cardSurface,
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(color: borderColor),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 7,
                                        height: 7,
                                        decoration: BoxDecoration(
                                          color: primaryAccent,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        difficulty.levelTitle,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (outcome.isNewBestTime ||
                                    outcome.isNewFewestMoves)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: primaryAccent.withValues(
                                        alpha: 0.14,
                                      ),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: primaryAccent.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.emoji_events_rounded,
                                          size: 15,
                                          color: primaryAccent,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          outcome.isNewBestTime
                                              ? 'Yeni En İyi Süre!'
                                              : 'Yeni En İyi Skor!',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: primaryAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Performans Özeti Kartı
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: cardSurface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: borderColor),
                              ),
                              child: Column(
                                children: [
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _ResultMetricItem(
                                            icon: Icons.schedule_rounded,
                                            label: 'Süre',
                                            value: formattedTime,
                                            valueColor: textPrimary,
                                          ),
                                        ),
                                        VerticalDivider(
                                          color: borderColor,
                                          width: 16,
                                          thickness: 1,
                                        ),
                                        Expanded(
                                          child: _ResultMetricItem(
                                            icon: Icons.touch_app_outlined,
                                            label: 'Hamle',
                                            value: '$moves',
                                            valueColor: textPrimary,
                                          ),
                                        ),
                                        VerticalDivider(
                                          color: borderColor,
                                          width: 16,
                                          thickness: 1,
                                        ),
                                        Expanded(
                                          child: _ResultMetricItem(
                                            icon:
                                                Icons.check_circle_outline_rounded,
                                            label: 'Eşleşme',
                                            value:
                                                '${difficulty.pairsCount} / ${difficulty.pairsCount}',
                                            valueColor: primaryAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Divider(height: 1, color: borderColor),
                                  const SizedBox(height: 12),

                                  // Kişisel En İyi Derece Satırı
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.verified_rounded,
                                              size: 18,
                                              color: primaryAccent,
                                            ),
                                            const SizedBox(width: 6),
                                            Flexible(
                                              child: Text(
                                                timeImprovement != null
                                                    ? 'Önceki rekorundan $timeImprovement sn daha hızlı'
                                                    : 'Kişisel En İyi Derece',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: textPrimary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '$bestFormattedTime ($bestMoves Hamle)',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: primaryAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Alt Aksiyon Butonları
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PairlyButton(
                              label: 'Tekrar Oyna',
                              icon: Icons.replay_rounded,
                              variant: PairlyButtonVariant.primary,
                              onPressed: onPlayAgain,
                            ),
                            const SizedBox(height: 12),
                            PairlyButton(
                              label: 'Ana Sayfa',
                              icon: Icons.home_outlined,
                              variant: PairlyButtonVariant.secondary,
                              onPressed: onHome,
                            ),
                          ],
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

class _ResultMetricItem extends StatelessWidget {
  const _ResultMetricItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final muted = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: muted),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _ResultMatchedCardsIllustration extends StatelessWidget {
  const _ResultMatchedCardsIllustration({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final surface = isDark ? AppColors.darkSurface : AppColors.surface;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final accent = isDark ? AppColors.darkPrimary : AppColors.primary;

    return SizedBox(
      width: 170,
      height: 136,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: const Offset(-20, 0),
            child: Transform.rotate(
              angle: -0.12,
              child: Container(
                width: 92,
                height: 120,
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: border),
                ),
                child: Icon(
                  Icons.spa_outlined,
                  size: 32,
                  color: accent.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(20, 0),
            child: Transform.rotate(
              angle: 0.12,
              child: Container(
                width: 92,
                height: 120,
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: accent, width: 1.5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_florist_rounded,
                      size: 32,
                      color: accent,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
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

