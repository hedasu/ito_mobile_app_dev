import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pairly/features/game/domain/game_difficulty.dart';
import 'package:pairly/features/game/domain/memory_card_item.dart';

/// Kart çifti şablonu.
class _CardSymbolTemplate {
  const _CardSymbolTemplate({
    required this.pairId,
    required this.symbol,
    required this.icon,
    required this.color,
  });

  final String pairId;
  final String symbol;
  final IconData icon;
  final Color color;
}

/// Zorluk seviyesine göre karıştırılmış hafıza kartı destesi üreten domain servisi.
abstract final class DeckGenerator {
  /// En yüksek zorluk seviyesi (Uzman: 12 çift / 24 kart) için 12 benzersiz sembol havuzu.
  static const List<_CardSymbolTemplate> _symbolPool = [
    _CardSymbolTemplate(
      pairId: 'sakura',
      symbol: '🌸',
      icon: Icons.local_florist_rounded,
      color: Color(0xFFE58C9A),
    ),
    _CardSymbolTemplate(
      pairId: 'lemon',
      symbol: '🍋',
      icon: Icons.wb_sunny_rounded,
      color: Color(0xFFE9B44C),
    ),
    _CardSymbolTemplate(
      pairId: 'coffee',
      symbol: '☕',
      icon: Icons.coffee_rounded,
      color: Color(0xFFB07D62),
    ),
    _CardSymbolTemplate(
      pairId: 'leaf',
      symbol: '🌿',
      icon: Icons.eco_rounded,
      color: Color(0xFF5A8F69),
    ),
    _CardSymbolTemplate(
      pairId: 'avocado',
      symbol: '🥑',
      icon: Icons.spa_rounded,
      color: Color(0xFF7A9A55),
    ),
    _CardSymbolTemplate(
      pairId: 'mushroom',
      symbol: '🍄',
      icon: Icons.park_rounded,
      color: Color(0xFFD06A5C),
    ),
    _CardSymbolTemplate(
      pairId: 'flower',
      symbol: '🌼',
      icon: Icons.filter_vintage_rounded,
      color: Color(0xFFE2A83E),
    ),
    _CardSymbolTemplate(
      pairId: 'bell',
      symbol: '🔔',
      icon: Icons.notifications_rounded,
      color: Color(0xFFD49B4B),
    ),
    _CardSymbolTemplate(
      pairId: 'pine',
      symbol: '🌲',
      icon: Icons.forest_rounded,
      color: Color(0xFF4B7F52),
    ),
    _CardSymbolTemplate(
      pairId: 'butterfly',
      symbol: '🦋',
      icon: Icons.auto_awesome_rounded,
      color: Color(0xFF6B9AC4),
    ),
    _CardSymbolTemplate(
      pairId: 'shell',
      symbol: '🐚',
      icon: Icons.waves_rounded,
      color: Color(0xFFC89D7C),
    ),
    _CardSymbolTemplate(
      pairId: 'moon',
      symbol: '🌙',
      icon: Icons.nightlight_round,
      color: Color(0xFF8E9AAF),
    ),
  ];

  /// Belirtilen [difficulty] için çiftleri oluşturur ve Fisher-Yates algoritmasıyla karıştırır.
  static List<MemoryCardItem> generateDeck(
    GameDifficulty difficulty, {
    Random? random,
  }) {
    final rng = random ?? Random();
    final selectedTemplates = _symbolPool.take(difficulty.pairsCount).toList();

    final rawCards = <_CardSymbolTemplate>[];
    for (final template in selectedTemplates) {
      rawCards
        ..add(template)
        ..add(template);
    }

    // Fisher-Yates karıştırma algoritması
    for (var i = rawCards.length - 1; i > 0; i--) {
      final j = rng.nextInt(i + 1);
      final temp = rawCards[i];
      rawCards[i] = rawCards[j];
      rawCards[j] = temp;
    }

    return List<MemoryCardItem>.generate(rawCards.length, (index) {
      final item = rawCards[index];
      return MemoryCardItem(
        id: index,
        pairId: item.pairId,
        symbol: item.symbol,
        icon: item.icon,
        accentColor: item.color,
      );
    });
  }
}
