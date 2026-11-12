import 'package:flutter/material.dart';

/// Oyun tahtasındaki tek bir hafıza kartını temsil eden domain modeli.
class MemoryCardItem {
  const MemoryCardItem({
    required this.id,
    required this.pairId,
    required this.symbol,
    required this.icon,
    required this.accentColor,
    this.isFlipped = false,
    this.isMatched = false,
  });

  /// Kartın deste içindeki benzersiz indeksi/kimliği.
  final int id;

  /// Eşleşen iki kartın paylaştığı ortak çift kimliği.
  final String pairId;

  /// Kartın ön yüzünde gösterilecek sembol/emoji.
  final String symbol;

  /// Alternatif/destekleyici ikon.
  final IconData icon;

  /// Sembol vurgu rengi.
  final Color accentColor;

  /// Kartın şu anda açık (çevrilmiş) olup olmadığı.
  final bool isFlipped;

  /// Kartın eşleşmesinin tamamlanıp tamamlanmadığı.
  final bool isMatched;

  /// Kartın ön yüzünün görünür olup olmadığı.
  bool get isFaceUp => isFlipped || isMatched;

  MemoryCardItem copyWith({
    int? id,
    String? pairId,
    String? symbol,
    IconData? icon,
    Color? accentColor,
    bool? isFlipped,
    bool? isMatched,
  }) {
    return MemoryCardItem(
      id: id ?? this.id,
      pairId: pairId ?? this.pairId,
      symbol: symbol ?? this.symbol,
      icon: icon ?? this.icon,
      accentColor: accentColor ?? this.accentColor,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}

