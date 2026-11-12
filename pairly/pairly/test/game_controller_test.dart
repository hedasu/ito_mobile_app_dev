import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pairly/features/game/domain/deck_generator.dart';
import 'package:pairly/features/game/domain/game_difficulty.dart';
import 'package:pairly/features/game/domain/memory_card_item.dart';
import 'package:pairly/features/game/presentation/game_controller.dart';
import 'package:pairly/features/statistics/presentation/statistics_controller.dart';

void main() {
  group('GameDifficulty ve DeckGenerator birim testleri', () {
    test('Beş zorluk seviyesi doğru matris ve kart sayılarına sahiptir', () {
      expect(GameDifficulty.beginner.columns, 3);
      expect(GameDifficulty.beginner.rows, 2);
      expect(GameDifficulty.beginner.totalCards, 6);

      expect(GameDifficulty.easy.columns, 3);
      expect(GameDifficulty.easy.rows, 4);
      expect(GameDifficulty.easy.totalCards, 12);

      expect(GameDifficulty.medium.columns, 4);
      expect(GameDifficulty.medium.rows, 4);
      expect(GameDifficulty.medium.totalCards, 16);

      expect(GameDifficulty.hard.columns, 4);
      expect(GameDifficulty.hard.rows, 5);
      expect(GameDifficulty.hard.totalCards, 20);

      expect(GameDifficulty.expert.columns, 4);
      expect(GameDifficulty.expert.rows, 6);
      expect(GameDifficulty.expert.totalCards, 24);
    });

    test('DeckGenerator her zorluk seviyesinde tam çiftlerden oluşan deste üretir', () {
      for (final difficulty in GameDifficulty.values) {
        final deck = DeckGenerator.generateDeck(difficulty, random: Random(42));
        expect(deck.length, difficulty.totalCards);

        final counts = <String, int>{};
        for (final card in deck) {
          counts[card.pairId] = (counts[card.pairId] ?? 0) + 1;
          expect(card.isFlipped, isFalse);
          expect(card.isMatched, isFalse);
        }

        expect(counts.length, difficulty.pairsCount);
        for (final count in counts.values) {
          expect(count, 2);
        }
      }
    });
  });

  group('GameController oyun kuralları birim testleri', () {
    List<MemoryCardItem> createDeterministicDeck() {
      return const [
        MemoryCardItem(
          id: 0,
          pairId: 'a',
          symbol: '🌸',
          icon: Icons.local_florist,
          accentColor: Colors.pink,
        ),
        MemoryCardItem(
          id: 1,
          pairId: 'a',
          symbol: '🌸',
          icon: Icons.local_florist,
          accentColor: Colors.pink,
        ),
        MemoryCardItem(
          id: 2,
          pairId: 'b',
          symbol: '🍋',
          icon: Icons.wb_sunny,
          accentColor: Colors.amber,
        ),
        MemoryCardItem(
          id: 3,
          pairId: 'b',
          symbol: '🍋',
          icon: Icons.wb_sunny,
          accentColor: Colors.amber,
        ),
        MemoryCardItem(
          id: 4,
          pairId: 'c',
          symbol: '☕',
          icon: Icons.coffee,
          accentColor: Colors.brown,
        ),
        MemoryCardItem(
          id: 5,
          pairId: 'c',
          symbol: '☕',
          icon: Icons.coffee,
          accentColor: Colors.brown,
        ),
      ];
    }

    test('Eşleşen iki kart açıldığında açık kalır, hamle ve eşleşme artar', () {
      final controller = GameController(
        initialDifficulty: GameDifficulty.beginner,
        enableAutoTimer: false,
      );
      addTearDown(controller.dispose);

      controller.startNewGame(
        difficulty: GameDifficulty.beginner,
        customDeck: createDeterministicDeck(),
      );

      controller.onCardTap(0);
      expect(controller.cards[0].isFlipped, isTrue);
      expect(controller.moves, 0);

      controller.onCardTap(1);
      expect(controller.cards[0].isMatched, isTrue);
      expect(controller.cards[1].isMatched, isTrue);
      expect(controller.moves, 1);
      expect(controller.matches, 1);
      expect(controller.isBoardLocked, isFalse);
    });

    test('Yanlış eşleşmede kartlar gecikme sonrasında otomatik kapanır', () async {
      final controller = GameController(
        initialDifficulty: GameDifficulty.beginner,
        mismatchDelay: const Duration(milliseconds: 50),
        enableAutoTimer: false,
      );
      addTearDown(controller.dispose);

      controller.startNewGame(
        difficulty: GameDifficulty.beginner,
        customDeck: createDeterministicDeck(),
      );

      controller.onCardTap(0); // pair 'a'
      controller.onCardTap(2); // pair 'b'

      expect(controller.moves, 1);
      expect(controller.matches, 0);
      expect(controller.cards[0].isFlipped, isTrue);
      expect(controller.cards[2].isFlipped, isTrue);
      expect(controller.isBoardLocked, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 80));

      expect(controller.cards[0].isFlipped, isFalse);
      expect(controller.cards[2].isFlipped, isFalse);
      expect(controller.isBoardLocked, isFalse);
    });

    test('Duraklatma sırasında kart açılamaz ve süre ilerlemez', () {
      final controller = GameController(
        initialDifficulty: GameDifficulty.beginner,
        enableAutoTimer: false,
      );
      addTearDown(controller.dispose);

      controller.startNewGame(
        difficulty: GameDifficulty.beginner,
        customDeck: createDeterministicDeck(),
      );

      controller.tickSecond();
      expect(controller.elapsedSeconds, 1);

      controller.togglePause();
      expect(controller.isPaused, isTrue);

      controller.tickSecond();
      expect(controller.elapsedSeconds, 1);

      controller.onCardTap(0);
      expect(controller.cards[0].isFlipped, isFalse);
    });

    test('Tüm çiftler eşleştiğinde oyun tamamlanır ve onGameWon tetiklenir', () {
      var wonTriggered = false;
      final controller = GameController(
        initialDifficulty: GameDifficulty.beginner,
        enableAutoTimer: false,
        onGameWon: () => wonTriggered = true,
      );
      addTearDown(controller.dispose);

      controller.startNewGame(
        difficulty: GameDifficulty.beginner,
        customDeck: createDeterministicDeck(),
      );

      controller.onCardTap(0);
      controller.onCardTap(1);
      controller.onCardTap(2);
      controller.onCardTap(3);
      controller.onCardTap(4);
      controller.onCardTap(5);

      expect(controller.matches, 3);
      expect(controller.moves, 3);
      expect(controller.isCompleted, isTrue);
      expect(controller.progressPercentageText, '%100');
      expect(wonTriggered, isTrue);
    });
  });

  group('StatisticsController birim testleri', () {
    test('Kişisel rekorlar ve son 5 oyun kaydı doğru güncellenir', () async {
      final stats = StatisticsController();
      expect(stats.isEmpty, isTrue);

      await stats.recordGameStarted();
      await stats.recordMatchFound();
      final outcome1 = await stats.recordGameCompleted(
        difficulty: GameDifficulty.medium,
        durationSeconds: 90,
        moves: 20,
      );

      expect(stats.isEmpty, isFalse);
      expect(stats.completedGames, 1);
      expect(outcome1.isNewBestTime, isTrue);
      expect(stats.recordFor(GameDifficulty.medium)?.bestTimeSeconds, 90);
      expect(stats.recordFor(GameDifficulty.medium)?.fewestMoves, 20);

      // Daha hızlı bir oyun tamamlandığında rekor güncellenmeli
      final outcome2 = await stats.recordGameCompleted(
        difficulty: GameDifficulty.medium,
        durationSeconds: 76,
        moves: 18,
      );

      expect(outcome2.isNewBestTime, isTrue);
      expect(outcome2.timeImprovementSeconds, 14);
      expect(stats.recordFor(GameDifficulty.medium)?.bestTimeSeconds, 76);
      expect(stats.recordFor(GameDifficulty.medium)?.fewestMoves, 18);

      // Toplamda 6 oyun eklendiğinde son oyunlar listesi en fazla 5 kayıt tutmalı
      for (var i = 0; i < 5; i++) {
        await stats.recordGameCompleted(
          difficulty: GameDifficulty.beginner,
          durationSeconds: 30 + i,
          moves: 6 + i,
        );
      }

      expect(stats.recentGames.length, 5);
    });
  });
}

