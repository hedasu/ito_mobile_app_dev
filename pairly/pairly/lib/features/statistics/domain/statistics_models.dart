import 'package:pairly/features/game/domain/game_difficulty.dart';

/// Belirli bir zorluk seviyesindeki kişisel en iyi derece (rekor).
class PersonalRecord {
  const PersonalRecord({
    required this.difficulty,
    required this.bestTimeSeconds,
    required this.fewestMoves,
  });

  final GameDifficulty difficulty;
  final int bestTimeSeconds;
  final int fewestMoves;

  Map<String, dynamic> toJson() => {
        'difficulty': difficulty.id,
        'bestTimeSeconds': bestTimeSeconds,
        'fewestMoves': fewestMoves,
      };

  factory PersonalRecord.fromJson(Map<String, dynamic> json) {
    return PersonalRecord(
      difficulty: GameDifficulty.fromId(json['difficulty'] as String? ?? ''),
      bestTimeSeconds: json['bestTimeSeconds'] as int? ?? 0,
      fewestMoves: json['fewestMoves'] as int? ?? 0,
    );
  }
}

/// Tamamlanan bir oyun kaydı.
class GameSessionRecord {
  const GameSessionRecord({
    required this.difficulty,
    required this.durationSeconds,
    required this.moves,
    required this.matches,
    required this.completedAt,
  });

  final GameDifficulty difficulty;
  final int durationSeconds;
  final int moves;
  final int matches;
  final DateTime completedAt;

  Map<String, dynamic> toJson() => {
        'difficulty': difficulty.id,
        'durationSeconds': durationSeconds,
        'moves': moves,
        'matches': matches,
        'completedAt': completedAt.toIso8601String(),
      };

  factory GameSessionRecord.fromJson(Map<String, dynamic> json) {
    return GameSessionRecord(
      difficulty: GameDifficulty.fromId(json['difficulty'] as String? ?? ''),
      durationSeconds: json['durationSeconds'] as int? ?? 0,
      moves: json['moves'] as int? ?? 0,
      matches: json['matches'] as int? ?? 0,
      completedAt: DateTime.tryParse(json['completedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

/// Oyun sonunda rekor kıyaslaması için özet sonuç bilgisi.
class GameCompletionOutcome {
  const GameCompletionOutcome({
    required this.isNewBestTime,
    required this.isNewFewestMoves,
    this.previousBestTimeSeconds,
    this.bestRecordAfterGame,
  });

  final bool isNewBestTime;
  final bool isNewFewestMoves;
  final int? previousBestTimeSeconds;
  final PersonalRecord? bestRecordAfterGame;

  /// Önceki süreden kaç saniye daha hızlı tamamlandığı (varsa).
  int? get timeImprovementSeconds {
    if (!isNewBestTime ||
        previousBestTimeSeconds == null ||
        bestRecordAfterGame == null) {
      return null;
    }
    final diff = previousBestTimeSeconds! - bestRecordAfterGame!.bestTimeSeconds;
    return diff > 0 ? diff : null;
  }
}

