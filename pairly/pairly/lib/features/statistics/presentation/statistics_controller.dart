import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:pairly/features/game/domain/game_difficulty.dart';
import 'package:pairly/features/statistics/data/statistics_repository.dart';
import 'package:pairly/features/statistics/domain/statistics_models.dart';

/// Oyun istatistiklerini, kişisel rekorları ve son 5 oyun geçmişini
/// yöneten [ChangeNotifier] controller'ı.
class StatisticsController extends ChangeNotifier {
  StatisticsController({StatisticsRepository? repository})
      : _repository = repository ?? StatisticsRepository();

  final StatisticsRepository _repository;

  StatisticsSnapshot _snapshot = const StatisticsSnapshot();

  StatisticsSnapshot get snapshot => _snapshot;
  int get totalGames => max(_snapshot.totalGamesStarted, _snapshot.completedGames);
  int get completedGames => _snapshot.completedGames;
  int get totalMatches => _snapshot.totalMatches;
  bool get isEmpty => _snapshot.isEmpty;
  List<GameSessionRecord> get recentGames => _snapshot.recentGames;

  PersonalRecord? recordFor(GameDifficulty difficulty) =>
      _snapshot.personalRecords[difficulty];

  Future<void> loadStatistics() async {
    _snapshot = await _repository.load();
    notifyListeners();
  }

  /// Yeni bir oyun başlatıldığında toplam oyun sayacını artırır.
  Future<void> recordGameStarted() async {
    _snapshot = StatisticsSnapshot(
      totalGamesStarted: _snapshot.totalGamesStarted + 1,
      completedGames: _snapshot.completedGames,
      totalMatches: _snapshot.totalMatches,
      personalRecords: _snapshot.personalRecords,
      recentGames: _snapshot.recentGames,
    );
    notifyListeners();
    await _repository.save(_snapshot);
  }

  /// Her başarılı eşleşmede toplam eşleşme sayısını artırır.
  Future<void> recordMatchFound() async {
    _snapshot = StatisticsSnapshot(
      totalGamesStarted: max(_snapshot.totalGamesStarted, 1),
      completedGames: _snapshot.completedGames,
      totalMatches: _snapshot.totalMatches + 1,
      personalRecords: _snapshot.personalRecords,
      recentGames: _snapshot.recentGames,
    );
    notifyListeners();
    await _repository.save(_snapshot);
  }

  /// Oyun tamamlandığında rekorları ve son 5 oyunu günceller,
  /// sonuç ekranı için [GameCompletionOutcome] döndürür.
  Future<GameCompletionOutcome> recordGameCompleted({
    required GameDifficulty difficulty,
    required int durationSeconds,
    required int moves,
    DateTime? completedAt,
  }) async {
    final existingRecord = _snapshot.personalRecords[difficulty];
    final isNewBestTime = existingRecord == null ||
        durationSeconds < existingRecord.bestTimeSeconds;
    final isNewFewestMoves =
        existingRecord == null || moves < existingRecord.fewestMoves;

    final updatedRecord = PersonalRecord(
      difficulty: difficulty,
      bestTimeSeconds: existingRecord == null
          ? durationSeconds
          : min(durationSeconds, existingRecord.bestTimeSeconds),
      fewestMoves: existingRecord == null
          ? moves
          : min(moves, existingRecord.fewestMoves),
    );

    final updatedRecords = Map<GameDifficulty, PersonalRecord>.from(
      _snapshot.personalRecords,
    )..[difficulty] = updatedRecord;

    final newSession = GameSessionRecord(
      difficulty: difficulty,
      durationSeconds: durationSeconds,
      moves: moves,
      matches: difficulty.pairsCount,
      completedAt: completedAt ?? DateTime.now(),
    );

    final updatedRecent = <GameSessionRecord>[
      newSession,
      ..._snapshot.recentGames,
    ].take(5).toList();

    final newCompleted = _snapshot.completedGames + 1;
    final newTotalStarted = max(_snapshot.totalGamesStarted, newCompleted);

    _snapshot = StatisticsSnapshot(
      totalGamesStarted: newTotalStarted,
      completedGames: newCompleted,
      totalMatches: _snapshot.totalMatches,
      personalRecords: updatedRecords,
      recentGames: updatedRecent,
    );

    notifyListeners();
    await _repository.save(_snapshot);

    return GameCompletionOutcome(
      isNewBestTime: isNewBestTime,
      isNewFewestMoves: isNewFewestMoves,
      previousBestTimeSeconds: existingRecord?.bestTimeSeconds,
      bestRecordAfterGame: updatedRecord,
    );
  }
}

