# Pairly — Stitch tasarım referansları

Bu klasör Flutter kaynak kodu DEĞİLDİR. HTML dosyaları yalnızca görsel ve yerleşim referansıdır.

## Ekran haritası

| Ekran | Açık tema | Koyu tema |
|---|---|---|
| Ana sayfa | **Eksik: dışa aktarılması gerekiyor** | `screens/home_dark.html` |
| Zorluk seçimi (modal bottom sheet) | `screens/difficulty_light.html` | `screens/difficulty_dark.html` |
| Oyun | `screens/game_light.html` | `screens/game_dark.html` |
| Sonuç | `screens/result_light.html` | `screens/result_dark.html` |
| İstatistikler | `screens/statistics_light_original.html` | `screens/statistics_dark.html` |
| İstatistikler boş durum | `screens/statistics_empty_light.html` | `screens/statistics_empty_dark.html` |

## Tasarım tokenları
- `design_tokens/DESIGN_light.md` ve `DESIGN_dark.md` Stitch çıkışlarıdır.
- Bunların renkleri daha önceki `PROJECT.md` içinde yer alan bazı değerlerden farklıdır. Flutter'da tek bir merkezi AppTheme'e kararlaştırılan değerler taşınmalıdır; mevcut değerler sessizce karıştırılmamalıdır.
- Bazı HTML örnekleri oyun sayacı/kart sayısı açısından tutarsız statik örnekler gösterebilir; gerçek veriler Flutter GameController'dan gelmelidir.
- HTML'deki simüle edilmiş iOS saat/durum çubuğu ve home indicator gerçek Flutter widget'larıyla tekrar çizilmemelidir; SafeArea ve platform sistem çubukları kullanılmalıdır.
- Zorluk seçimi ayrı bir ekran değil `showModalBottomSheet()` olarak uygulanacak.
- Beş seviye: Başlangıç 3x2, Kolay 3x4, Orta 4x4, Zor 4x5, Uzman 4x6.
- Logo projenin `assets/images/pairly_logo.png` dosyasında bulunmalıdır; bu referans paketi özgün logo varlığını içermez.

## Geliştirme önerisi
1. Mevcut PROJECT.md, tema ve mimariyi incele.
2. Eksik Light Mode ana sayfa HTML'ini ekle veya mevcut Stitch ekran görüntüsünü geçici referans kullan.
3. Önce sadece HomeScreen, tema ve ortak widget'ları uygula; flutter analyze/test çalıştır.
4. Sonra bottom sheet, oyun ekranı, sonuç ve istatistikleri sırayla uygula.
5. Web HTML, Tailwind ve simüle edilmiş mobil çerçeveleri Flutter projesine runtime bağımlılığı olarak ekleme.
