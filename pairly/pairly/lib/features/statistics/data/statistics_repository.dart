import 'dart:convert';

import 'package:pairly/core/storage/storage_backend.dart';
import 'package:pairly/features/game/domain/game_difficulty.dart';
import 'package:pairly/features/statistics/domain/statistics_models.dart';

/// İstatistik verilerinin tüm anlık görüntüsü.
class StatisticsSnapshot {
  const StatisticsSnapshot({
    this.totalGamesStarted = 0,
    this.completedGames = 0,
    this.totalMatches = 0,
    this.personalRecords = const {},
    this.recentGames = const [],
  });

  final int totalGamesStarted;
  final int completedGames;
  final int totalMatches;
  final Map<GameDifficulty, PersonalRecord> personalRecords;
  final List<GameSessionRecord> recentGames;

  bool get isEmpty => completedGames == 0 && recentGames.isEmpty;

  Map<String, dynamic> toJson() => {
        'totalGamesStarted': totalGamesStarted,
        'completedGames': completedGames,
        'totalMatches': totalMatches,
        'personalRecords': personalRecords.values
            .map((record) => record.toJson())
            .toList(),
        'recentGames': recentGames.map((game) => game.toJson()).toList(),
      };

  factory StatisticsSnapshot.fromJson(Map<String, dynamic> json) {
    final recordsMap = <GameDifficulty, PersonalRecord>{};
    final rawRecords = json['personalRecords'];
    if (rawRecords is List) {
      for (final item in rawRecords) {
        if (item is Map<String, dynamic>) {
          final record = PersonalRecord.fromJson(item);
          recordsMap[record.difficulty] = record;
        }
      }
    }

    final recentList = <GameSessionRecord>[];
    final rawRecent = json['recentGames'];
    if (rawRecent is List) {
      for (final item in rawRecent) {
        if (item is Map<String, dynamic>) {
          recentList.add(GameSessionRecord.fromJson(item));
        }
      }
    }

    return StatisticsSnapshot(
      totalGamesStarted: json['totalGamesStarted'] as int? ?? 0,
      completedGames: json['completedGames'] as int? ?? 0,
      totalMatches: json['totalMatches'] as int? ?? 0,
      personalRecords: recordsMap,
      recentGames: recentList,
    );
  }
}

/// İstatistik verilerini yerel depolamadan okuyan ve yazan repository.
class StatisticsRepository {
  static const String _storageKey = 'pairly_statistics_v1';

  Future<StatisticsSnapshot> load() async {
    final raw = await readStorageValue(_storageKey);
    if (raw == null || raw.isEmpty) {
      return const StatisticsSnapshot();
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return StatisticsSnapshot.fromJson(decoded);
      }
    } catch (_) {}
    return const StatisticsSnapshot();
  }

  Future<void> save(StatisticsSnapshot snapshot) async {
    await writeStorageValue(_storageKey, jsonEncode(snapshot.toJson()));
  }
}

