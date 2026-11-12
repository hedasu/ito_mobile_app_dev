import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:pairly/features/game/domain/deck_generator.dart';
import 'package:pairly/features/game/domain/game_difficulty.dart';
import 'package:pairly/features/game/domain/memory_card_item.dart';

/// Hafıza oyununun tüm durumunu, kart eşleştirme algoritmasını,
/// süre ve hamle sayaçlarını UI'dan bağımsız olarak yöneten [ChangeNotifier].
class GameController extends ChangeNotifier {
  GameController({
    GameDifficulty initialDifficulty = GameDifficulty.medium,
    this.mismatchDelay = const Duration(milliseconds: 700),
    this.enableAutoTimer = true,
    this.onGameStarted,
    this.onMatchFound,
    this.onCardFlipped,
    this.onMismatch,
    this.onGameWon,
    this.random,
  }) : _difficulty = initialDifficulty {
    startNewGame(difficulty: initialDifficulty, notifyStartCallback: false);
  }

  final Duration mismatchDelay;
  final bool enableAutoTimer;
  final VoidCallback? onGameStarted;
  final VoidCallback? onMatchFound;
  final VoidCallback? onCardFlipped;
  final VoidCallback? onMismatch;
  final VoidCallback? onGameWon;
  final Random? random;

  GameDifficulty _difficulty;
  List<MemoryCardItem> _cards = const [];
  final List<int> _flippedIndices = [];

  int _moves = 0;
  int _matches = 0;
  int _elapsedSeconds = 0;
  bool _isPaused = false;
  bool _isBoardLocked = false;
  bool _isCompleted = false;
  bool _hasRegisteredStart = false;

  Timer? _timer;
  Timer? _mismatchTimer;

  GameDifficulty get difficulty => _difficulty;
  List<MemoryCardItem> get cards => List.unmodifiable(_cards);
  int get moves => _moves;
  int get matches => _matches;
  int get totalPairs => _difficulty.pairsCount;
  int get elapsedSeconds => _elapsedSeconds;
  bool get isPaused => _isPaused;
  bool get isBoardLocked => _isBoardLocked;
  bool get isCompleted => _isCompleted;

  /// `0.0` ile `1.0` arasında tamamlanma oranı.
  double get progressRatio =>
      totalPairs == 0 ? 0.0 : (_matches / totalPairs).clamp(0.0, 1.0);

  /// Yüzdelik gösterim metni (ör. `%62.5` veya `%100`).
  String get progressPercentageText {
    final pct = progressRatio * 100;
    if (pct == pct.roundToDouble()) {
      return '%${pct.toInt()}';
    }
    return '%${pct.toStringAsFixed(1)}';
  }

  /// `MM:SS` biçiminde biçimlendirilmiş süre metni.
  String get formattedTime => formatSeconds(_elapsedSeconds);

  static String formatSeconds(int totalSeconds) {
    final mins = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  /// Seçilen zorluk seviyesinde (veya mevcut seviyede) kartları yeniden karıştırıp
  /// yeni bir oyun başlatır.
  void startNewGame({
    GameDifficulty? difficulty,
    List<MemoryCardItem>? customDeck,
    bool notifyStartCallback = true,
  }) {
    _cancelTimers();
    if (difficulty != null) {
      _difficulty = difficulty;
    }

    _cards =
        customDeck ?? DeckGenerator.generateDeck(_difficulty, random: random);
    _flippedIndices.clear();
    _moves = 0;
    _matches = 0;
    _elapsedSeconds = 0;
    _isPaused = false;
    _isBoardLocked = false;
    _isCompleted = false;
    _hasRegisteredStart = false;

    if (enableAutoTimer) {
      _startPeriodicTimer();
    }

    if (notifyStartCallback) {
      _hasRegisteredStart = true;
      onGameStarted?.call();
    }

    notifyListeners();
  }

  /// Belirtilen [index] konumundaki kartı çevirir ve eşleşme kontrolü yapar.
  void onCardTap(int index) {
    if (_isPaused || _isBoardLocked || _isCompleted) return;
    if (index < 0 || index >= _cards.length) return;

    final tappedCard = _cards[index];
    if (tappedCard.isFlipped || tappedCard.isMatched) return;

    if (!_hasRegisteredStart) {
      _hasRegisteredStart = true;
      onGameStarted?.call();
    }

    _cards = List<MemoryCardItem>.from(_cards)
      ..[index] = tappedCard.copyWith(isFlipped: true);
    _flippedIndices.add(index);
    onCardFlipped?.call();

    if (_flippedIndices.length < 2) {
      notifyListeners();
      return;
    }

    // İkinci kart açıldı: hamle sayısını artır ve kontrol et
    _moves++;
    _isBoardLocked = true;

    final firstIndex = _flippedIndices[0];
    final secondIndex = _flippedIndices[1];
    final firstCard = _cards[firstIndex];
    final secondCard = _cards[secondIndex];

    if (firstCard.pairId == secondCard.pairId) {
      // Başarılı eşleşme
      _cards = List<MemoryCardItem>.from(_cards)
        ..[firstIndex] = firstCard.copyWith(isFlipped: true, isMatched: true)
        ..[secondIndex] = secondCard.copyWith(isFlipped: true, isMatched: true);
      _flippedIndices.clear();
      _matches++;
      _isBoardLocked = false;

      onMatchFound?.call();

      if (_matches >= totalPairs) {
        _isCompleted = true;
        _cancelTimers();
        notifyListeners();
        onGameWon?.call();
        return;
      }

      notifyListeners();
    } else {
      // Yanlış eşleşme: kartları açık göster, kısa süre sonra kapat
      notifyListeners();
      onMismatch?.call();

      _mismatchTimer?.cancel();
      _mismatchTimer = Timer(mismatchDelay, () {
        if (_cards.isEmpty) return;
        _cards = List<MemoryCardItem>.from(_cards)
          ..[firstIndex] = _cards[firstIndex].copyWith(isFlipped: false)
          ..[secondIndex] = _cards[secondIndex].copyWith(isFlipped: false);
        _flippedIndices.clear();
        _isBoardLocked = false;
        notifyListeners();
      });
    }
  }

  /// Oyunu duraklatır veya devam ettirir.
  void togglePause() {
    if (_isCompleted) return;
    _isPaused = !_isPaused;
    notifyListeners();
  }

  void setPaused(bool paused) {
    if (_isCompleted || _isPaused == paused) return;
    _isPaused = paused;
    notifyListeners();
  }

  /// Birim testlerinde veya manuel tetiklemelerde süreyi 1 saniye ilerletir.
  void tickSecond() {
    if (_isPaused || _isCompleted) return;
    _elapsedSeconds++;
    notifyListeners();
  }

  void _startPeriodicTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      tickSecond();
    });
  }

  void _cancelTimers() {
    _timer?.cancel();
    _timer = null;
    _mismatchTimer?.cancel();
    _mismatchTimer = null;
  }

  @override
  void dispose() {
    _cancelTimers();
    super.dispose();
  }
}
