/// Uygulama genelinde kullanılan sabit değerler.
abstract final class AppConstants {
  static const String appName = 'Pairly';
  static const String appSubtitle = 'Kart Eşleştirme Oyunu';
  static const String logoAssetPath = 'assets/images/pairly_logo.png';

  // Ana Sayfa (HomeScreen) metinleri
  static const String homeTitle = 'Hafızanı keşfet';
  static const String homeDescription = 'Kartları eşleştir, zihnini dinlendir.';
  static const String startGameLabel = 'Oyuna Başla';
  static const String statisticsLabel = 'İstatistikler';

  // Zorluk seviyelerine göre çift ve kart sayıları
  static const int easyPairsCount = 4;
  static const int mediumPairsCount = 8;
  static const int hardPairsCount = 12;

  // Varsayılan kenar boşlukları ve köşe yarıçapları
  static const double defaultPadding = 24.0;
  static const double maxContentWidth = 360.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonHeight = 56.0;
}

