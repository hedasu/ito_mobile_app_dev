import 'package:flutter/material.dart';
import 'package:pairly/core/constants/app_constants.dart';
import 'package:pairly/core/state/notifier_scope.dart';
import 'package:pairly/core/theme/app_colors.dart';
import 'package:pairly/core/widgets/pairly_button.dart';
import 'package:pairly/features/game/domain/game_difficulty.dart';
import 'package:pairly/features/game/presentation/game_controller.dart';
import 'package:pairly/features/statistics/domain/statistics_models.dart';
import 'package:pairly/features/statistics/presentation/statistics_controller.dart';

/// İstatistikler, Kişisel Rekorlar, Son 5 Oyun ve Boş Durum ekranı.
///
/// Stitch tasarımlarını (`statistics_light_original.html`, `statistics_dark.html`,
/// `statistics_empty_light.html`, `statistics_empty_dark.html`) temel alır.
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({
    super.key,
    required this.onStartGameRequested,
  });

  /// Boş durumda "Oyuna Başla" butonuna tıklandığında tetiklenen aksiyon.
  final VoidCallback onStartGameRequested;

  @override
  Widget build(BuildContext context) {
    final stats = NotifierScope.watch<StatisticsController>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Geri Dön',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(AppConstants.statisticsLabel),
      ),
      body: SafeArea(
        child: stats.isEmpty
            ? _EmptyStatisticsView(onStartGamePressed: onStartGameRequested)
            : _FilledStatisticsView(stats: stats),
      ),
    );
  }
}

class _EmptyStatisticsView extends StatelessWidget {
  const _EmptyStatisticsView({
    required this.onStartGamePressed,
  });

  final VoidCallback onStartGamePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.surface;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final primaryAccent = isDark ? AppColors.darkPrimary : AppColors.primary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Kart İllüstrasyonu
              SizedBox(
                width: 176,
                height: 164,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.translate(
                      offset: const Offset(-14, 4),
                      child: Transform.rotate(
                        angle: -0.2,
                        child: Container(
                          width: 98,
                          height: 132,
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: border),
                          ),
                          child: Icon(
                            Icons.spa_outlined,
                            size: 28,
                            color: textSecondary.withValues(alpha: 0.45),
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(12, -2),
                      child: Transform.rotate(
                        angle: 0.1,
                        child: Container(
                          width: 98,
                          height: 132,
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: border),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: isDark ? 0.3 : 0.05,
                                ),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: primaryAccent.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.psychology_alt_outlined,
                                  color: primaryAccent,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(3, (_) {
                                  return Container(
                                    width: 4,
                                    height: 4,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: border,
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Henüz oyun kaydın yok',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'İlk oyununu tamamladığında istatistiklerin burada görünecek.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 28),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: PairlyButton(
                  label: AppConstants.startGameLabel,
                  icon: Icons.play_arrow_rounded,
                  onPressed: onStartGamePressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilledStatisticsView extends StatelessWidget {
  const _FilledStatisticsView({required this.stats});

  final StatisticsController stats;

  static const List<String> _turkishMonths = [
    'Oca',
    'Şub',
    'Mar',
    'Nis',
    'May',
    'Haz',
    'Tem',
    'Ağu',
    'Eyl',
    'Eki',
    'Kas',
    'Ara',
  ];

  String _formatDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDay = DateTime(date.year, date.month, date.day);
    final timePart =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    final diffDays = today.difference(targetDay).inDays;
    if (diffDays == 0) {
      return 'Bugün, $timePart';
    }
    if (diffDays == 1) {
      return 'Dün, $timePart';
    }
    final monthName = _turkishMonths[(date.month - 1).clamp(0, 11)];
    return '${date.day} $monthName, $timePart';
  }

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

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.defaultPadding,
        8,
        AppConstants.defaultPadding,
        28,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Genel Özet İstatistik Kartı
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: border),
                ),
                child: Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: _OverviewStatColumn(
                              label: 'TOPLAM OYUN',
                              value: '${stats.totalGames}',
                              valueColor: textPrimary,
                            ),
                          ),
                          VerticalDivider(color: border, width: 16),
                          Expanded(
                            child: _OverviewStatColumn(
                              label: 'TAMAMLANAN',
                              value: '${stats.completedGames}',
                              valueColor: primaryAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Divider(height: 1, color: border),
                    const SizedBox(height: 14),
                    _OverviewStatColumn(
                      label: 'EŞLEŞME',
                      value: '${stats.totalMatches}',
                      valueColor: textPrimary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 2. Kişisel Rekorlar Bölümü (5 Zorluk)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kişisel Rekorlar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  Text(
                    '5 Zorluk',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: border),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: List.generate(GameDifficulty.values.length, (idx) {
                    final diff = GameDifficulty.values[idx];
                    final record = stats.recordFor(diff);
                    final isHighlighted = diff == GameDifficulty.medium;

                    return Column(
                      children: [
                        if (idx > 0) Divider(height: 1, color: border),
                        _PersonalRecordRow(
                          difficulty: diff,
                          record: record,
                          isHighlighted: isHighlighted,
                        ),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              // 3. Son Oyunlar Bölümü (Son 5 Kayıt)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Son Oyunlar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  Text(
                    'Son 5 Kayıt',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: border),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: List.generate(stats.recentGames.length, (idx) {
                    final session = stats.recentGames[idx];
                    return Column(
                      children: [
                        if (idx > 0) Divider(height: 1, color: border),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                                child: Text(
                                  '${idx + 1}.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: textSecondary,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 6,
                                      children: [
                                        Text(
                                          '${session.difficulty.label} Seviye',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: textPrimary,
                                          ),
                                        ),
                                        Text(
                                          '•',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: textSecondary,
                                          ),
                                        ),
                                        Text(
                                          _formatDateLabel(session.completedAt),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      session.difficulty.gridSummary,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    GameController.formatSeconds(
                                      session.durationSeconds,
                                    ),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: textPrimary,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    child: Text(
                                      '•',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: textSecondary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${session.moves} Hamle',
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
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewStatColumn extends StatelessWidget {
  const _OverviewStatColumn({
    required this.label,
    required this.value,
    required this.valueColor,
  });

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
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: muted,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _PersonalRecordRow extends StatelessWidget {
  const _PersonalRecordRow({
    required this.difficulty,
    required this.record,
    required this.isHighlighted,
  });

  final GameDifficulty difficulty;
  final PersonalRecord? record;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.darkPrimary : AppColors.primary;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final bestTimeText = record != null
        ? GameController.formatSeconds(record!.bestTimeSeconds)
        : '--:--';
    final fewestMovesText = record != null ? '${record!.fewestMoves}' : '--';

    return Container(
      color: isHighlighted ? primaryAccent.withValues(alpha: 0.05) : null,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkBackground
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isHighlighted
                    ? primaryAccent.withValues(alpha: 0.45)
                    : border,
              ),
            ),
            child: Text(
              difficulty.gridBadge,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w600,
                color: isHighlighted ? primaryAccent : textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  difficulty.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                Text(
                  '${difficulty.totalCards} Kart',
                  style: TextStyle(
                    fontSize: 11,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'EN İYİ SÜRE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    bestTimeText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: record != null && isHighlighted
                          ? primaryAccent
                          : textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 22,
                color: border,
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),
              SizedBox(
                width: 68,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'EN AZ HAMLE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      fewestMovesText,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: record != null && isHighlighted
                            ? primaryAccent
                            : textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

