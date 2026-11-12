import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pairly/core/services/feedback_service.dart';
import 'package:pairly/core/state/app_settings_controller.dart';
import 'package:pairly/core/state/notifier_scope.dart';
import 'package:pairly/core/theme/app_colors.dart';
import 'package:pairly/core/widgets/pairly_button.dart';
import 'package:pairly/core/widgets/settings_bottom_sheet.dart';
import 'package:pairly/features/difficulty/presentation/difficulty_bottom_sheet.dart';
import 'package:pairly/features/game/domain/game_difficulty.dart';
import 'package:pairly/features/game/presentation/game_controller.dart';
import 'package:pairly/features/game/presentation/widgets/memory_card_widget.dart';
import 'package:pairly/features/result/presentation/result_screen.dart';
import 'package:pairly/features/statistics/presentation/statistics_controller.dart';

/// Hafıza oyunu alanı ekranı (`game_light.html` & `game_dark.html`).
class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.initialDifficulty,
    this.enableAutoTimer = true,
  });

  final GameDifficulty initialDifficulty;
  final bool enableAutoTimer;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameController _controller;
  bool _isNavigatingToResult = false;

  @override
  void initState() {
    super.initState();
    _controller = GameController(
      initialDifficulty: widget.initialDifficulty,
      enableAutoTimer: widget.enableAutoTimer,
      onGameStarted: _handleGameStarted,
      onCardFlipped: _handleCardFlipped,
      onMatchFound: _handleMatchFound,
      onMismatch: _handleMismatch,
      onGameWon: _handleGameWon,
    );
  }

  void _handleGameStarted() {
    if (!mounted) return;
    final stats = NotifierScope.read<StatisticsController>(context);
    stats.recordGameStarted();
  }

  void _handleCardFlipped() {
    if (!mounted) return;
    final settings = NotifierScope.read<AppSettingsController>(context);
    FeedbackService.playFlip(
      soundEnabled: settings.soundEnabled,
      hapticEnabled: settings.hapticEnabled,
    );
  }

  void _handleMatchFound() {
    if (!mounted) return;
    final settings = NotifierScope.read<AppSettingsController>(context);
    final stats = NotifierScope.read<StatisticsController>(context);
    stats.recordMatchFound();
    FeedbackService.playMatch(
      soundEnabled: settings.soundEnabled,
      hapticEnabled: settings.hapticEnabled,
    );
  }

  void _handleMismatch() {
    if (!mounted) return;
    final settings = NotifierScope.read<AppSettingsController>(context);
    FeedbackService.playMismatch(
      soundEnabled: settings.soundEnabled,
      hapticEnabled: settings.hapticEnabled,
    );
  }

  Future<void> _handleGameWon() async {
    if (!mounted || _isNavigatingToResult) return;
    _isNavigatingToResult = true;

    final settings = NotifierScope.read<AppSettingsController>(context);
    final stats = NotifierScope.read<StatisticsController>(context);

    FeedbackService.playWin(
      soundEnabled: settings.soundEnabled,
      hapticEnabled: settings.hapticEnabled,
    );

    final completedDifficulty = _controller.difficulty;
    final finalSeconds = _controller.elapsedSeconds;
    final finalMoves = _controller.moves;

    final outcome = await stats.recordGameCompleted(
      difficulty: completedDifficulty,
      durationSeconds: finalSeconds,
      moves: finalMoves,
    );

    if (!mounted) return;

    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (routeContext) => ResultScreen(
          difficulty: completedDifficulty,
          durationSeconds: finalSeconds,
          moves: finalMoves,
          outcome: outcome,
          onPlayAgain: () {
            Navigator.of(routeContext).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => GameScreen(
                  initialDifficulty: completedDifficulty,
                  enableAutoTimer: widget.enableAutoTimer,
                ),
              ),
            );
          },
          onHome: () {
            Navigator.of(routeContext).popUntil((route) => route.isFirst);
          },
        ),
      ),
    );
  }

  Future<void> _openDifficultySelector() async {
    final wasPaused = _controller.isPaused;
    _controller.setPaused(true);

    final chosen = await showDifficultyBottomSheet(
      context,
      initialDifficulty: _controller.difficulty,
    );

    if (!mounted) return;
    if (chosen != null) {
      _controller.startNewGame(difficulty: chosen);
    } else if (!wasPaused) {
      _controller.setPaused(false);
    }
  }

  Future<void> _openSettings() async {
    final wasPaused = _controller.isPaused;
    _controller.setPaused(true);
    await showSettingsBottomSheet(context);
    if (!mounted) return;
    if (!wasPaused) {
      _controller.setPaused(false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardSurface = isDark ? AppColors.darkSurface : AppColors.surface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final primaryAccent = isDark ? AppColors.darkPrimary : AppColors.primary;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final difficulty = _controller.difficulty;

        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          // 1. Üst Navigasyon ve Zorluk Rozeti Barı
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _CircleHeaderButton(
                                icon: Icons.arrow_back_rounded,
                                tooltip: 'Geri',
                                onTap: () => Navigator.of(context).pop(),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(999),
                                    onTap: _openDifficultySelector,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: cardSurface,
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        border: Border.all(color: borderColor),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: primaryAccent,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              difficulty.levelTitle,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: textPrimary,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Icon(
                                            Icons.swap_horiz_rounded,
                                            size: 16,
                                            color: textSecondary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _CircleHeaderButton(
                                    icon: Icons.tune_rounded,
                                    tooltip: 'Ayarlar',
                                    onTap: _openSettings,
                                  ),
                                  const SizedBox(width: 8),
                                  _CircleHeaderButton(
                                    icon: Icons.refresh_rounded,
                                    tooltip: 'Yeniden Başlat',
                                    onTap: () => _controller.startNewGame(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // 2. Süre, Hamle ve Eşleşme Sayaç Kartları
                          Row(
                            children: [
                              Expanded(
                                child: _ScoreboardMetricCard(
                                  icon: Icons.timer_outlined,
                                  label: 'Süre',
                                  value: _controller.formattedTime,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _ScoreboardMetricCard(
                                  icon: Icons.touch_app_outlined,
                                  label: 'Hamle',
                                  value: '${_controller.moves}',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _ScoreboardMetricCard(
                                  icon: Icons.grid_view_rounded,
                                  label: 'Eşleşme',
                                  value:
                                      '${_controller.matches} / ${_controller.totalPairs}',
                                  highlightValue: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // 3. Tamamlanma Oranı İlerleme Çubuğu
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tamamlanma Oranı',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: textSecondary,
                                    ),
                                  ),
                                  Text(
                                    _controller.progressPercentageText,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: primaryAccent,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: LinearProgressIndicator(
                                  value: _controller.progressRatio,
                                  minHeight: 6,
                                  backgroundColor: borderColor,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    primaryAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // 4. Dinamik Kart Izgarası (3x2, 3x4, 4x4, 4x5, 4x6)
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, gridConstraints) {
                                final cols = difficulty.columns;
                                final rows = difficulty.rows;
                                const spacing = 8.0;

                                final availWidth = gridConstraints.maxWidth;
                                final availHeight = gridConstraints.maxHeight;

                                final cellWidth =
                                    ((availWidth - (cols - 1) * spacing) / cols)
                                        .clamp(24.0, double.infinity);
                                final cellHeight =
                                    ((availHeight - (rows - 1) * spacing) /
                                            rows)
                                        .clamp(24.0, double.infinity);

                                // Kartların tüm ızgara boyutlarında taşmadan ekrana sığmasını sağlar
                                final idealHeight = cellWidth / 0.82;
                                final actualCellHeight = math.min(
                                  cellHeight,
                                  idealHeight,
                                );
                                final actualCellWidth = math.min(
                                  cellWidth,
                                  actualCellHeight * 0.92,
                                );
                                final childAspectRatio =
                                    actualCellWidth / actualCellHeight;
                                final boardWidth =
                                    cols * actualCellWidth +
                                    (cols - 1) * spacing;

                                return Center(
                                  child: SizedBox(
                                    width: boardWidth,
                                    child: GridView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: _controller.cards.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: cols,
                                            mainAxisSpacing: spacing,
                                            crossAxisSpacing: spacing,
                                            childAspectRatio: childAspectRatio,
                                          ),
                                      itemBuilder: (context, index) {
                                        final card = _controller.cards[index];
                                        return MemoryCardWidget(
                                          key: ValueKey('card_${card.id}'),
                                          card: card,
                                          onTap: () =>
                                              _controller.onCardTap(index),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),

                          // 5. Alt Duraklat / Devam Et Butonu
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton.icon(
                              onPressed: _controller.togglePause,
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: Icon(
                                _controller.isPaused
                                    ? Icons.play_arrow_rounded
                                    : Icons.pause_rounded,
                                size: 20,
                                color: primaryAccent,
                              ),
                              label: Text(
                                _controller.isPaused ? 'Devam Et' : 'Duraklat',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Duraklatma Katmanı (Pause Overlay)
                if (_controller.isPaused)
                  Positioned.fill(
                    child: Container(
                      color: (isDark
                              ? AppColors.darkBackground
                              : AppColors.background)
                          .withValues(alpha: 0.88),
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 320),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: cardSurface,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: borderColor),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 54,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: primaryAccent.withValues(
                                      alpha: 0.15,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.pause_circle_outline_rounded,
                                    size: 30,
                                    color: primaryAccent,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'Oyun Duraklatıldı',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Zihnini dinlendir, hazır olduğunda devam et.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                PairlyButton(
                                  label: 'Devam Et',
                                  icon: Icons.play_arrow_rounded,
                                  onPressed: _controller.togglePause,
                                ),
                                const SizedBox(height: 10),
                                PairlyButton(
                                  label: 'Ana Sayfaya Dön',
                                  icon: Icons.home_outlined,
                                  variant: PairlyButtonVariant.secondary,
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).popUntil((route) => route.isFirst);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CircleHeaderButton extends StatelessWidget {
  const _CircleHeaderButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.surface;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final fg = isDark ? AppColors.darkTextPrimary : AppColors.primary;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: surface,
            shape: BoxShape.circle,
            border: Border.all(color: border),
          ),
          child: Icon(icon, size: 20, color: fg),
        ),
      ),
    );
  }
}

class _ScoreboardMetricCard extends StatelessWidget {
  const _ScoreboardMetricCard({
    required this.icon,
    required this.label,
    required this.value,
    this.highlightValue = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool highlightValue;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.surface;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final primaryAccent = isDark ? AppColors.darkPrimary : AppColors.primary;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 13,
                color: highlightValue ? primaryAccent : textSecondary,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: highlightValue ? primaryAccent : textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

