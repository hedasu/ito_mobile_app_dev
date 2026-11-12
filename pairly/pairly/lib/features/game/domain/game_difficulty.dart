/// Hafıza oyunu zorluk seviyeleri.
///
/// Beş seviyeli matris yapısını temsil eder:
/// - Başlangıç: 3x2 (3 çift, 6 kart)
/// - Kolay: 3x4 (6 çift, 12 kart)
/// - Orta: 4x4 (8 çift, 16 kart)
/// - Zor: 4x5 (10 çift, 20 kart)
/// - Uzman: 4x6 (12 çift, 24 kart)
enum GameDifficulty {
  beginner(
    id: 'beginner',
    label: 'Başlangıç',
    levelTitle: 'Başlangıç (3x2)',
    gridBadge: '3×2',
    gridLabel: '3x2 Izgara',
    columns: 3,
    rows: 2,
    pairsCount: 3,
  ),
  easy(
    id: 'easy',
    label: 'Kolay',
    levelTitle: 'Kolay Seviye (3x4)',
    gridBadge: '3×4',
    gridLabel: '3x4 Izgara',
    columns: 3,
    rows: 4,
    pairsCount: 6,
  ),
  medium(
    id: 'medium',
    label: 'Orta',
    levelTitle: 'Orta Seviye (4x4)',
    gridBadge: '4×4',
    gridLabel: '4x4 Izgara',
    columns: 4,
    rows: 4,
    pairsCount: 8,
  ),
  hard(
    id: 'hard',
    label: 'Zor',
    levelTitle: 'Zor Seviye (4x5)',
    gridBadge: '4×5',
    gridLabel: '4x5 Izgara',
    columns: 4,
    rows: 5,
    pairsCount: 10,
  ),
  expert(
    id: 'expert',
    label: 'Uzman',
    levelTitle: 'Uzman Seviye (4x6)',
    gridBadge: '4×6',
    gridLabel: '4x6 Izgara',
    columns: 4,
    rows: 6,
    pairsCount: 12,
  );

  const GameDifficulty({
    required this.id,
    required this.label,
    required this.levelTitle,
    required this.gridBadge,
    required this.gridLabel,
    required this.columns,
    required this.rows,
    required this.pairsCount,
  });

  final String id;
  final String label;
  final String levelTitle;
  final String gridBadge;
  final String gridLabel;
  final int columns;
  final int rows;
  final int pairsCount;

  /// Toplam kart sayısı (`pairsCount * 2`).
  int get totalCards => pairsCount * 2;

  /// Zorluk seçimi ekranındaki alt bilgi metni (ör. `8 Çift · 16 Kart`).
  String get subtitle => '$pairsCount Çift · $totalCards Kart';

  /// İstatistikler son oyunlar listesindeki ızgara etiketi (ör. `4x4 Grid`).
  String get gridSummary => '${columns}x$rows Grid';

  static GameDifficulty fromId(String id) {
    for (final item in GameDifficulty.values) {
      if (item.id == id) {
        return item;
      }
    }
    return GameDifficulty.medium;
  }
}

