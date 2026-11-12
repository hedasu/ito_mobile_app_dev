# Pairly — Teknik İçerik ve Sunum Notları Arşivi (`content_notes.md`)

> Bu belge, görsel ağırlıklı web sunumundan (`presentation/index.html`) sadeleştirme amacıyla çıkarılan tüm teknik detayları, sınıf/dosya referanslarını, mimari açıklamaları ve doğrulama sonuçlarını eksiksiz olarak korur. Bir sonraki aşamada hazırlanacak olan **ayrıntılı konuşma metni** için ana referans kaynağıdır.

---

## 1. Bölüm: Giriş ve Proje Kimliği
- **Proje Adı:** Pairly — Minimalist Mobil Kart Eşleştirme (Hafıza) Oyunu
- **Slogan:** *"Hafızanı keşfet, zihnini dinlendir."*
- **Temel Yaklaşım:** İskandinav minimalizmi estetiğiyle tasarlanmış, reklamsız, bildirim veya karmaşık menü barındırmayan dingin bir mobil hafıza deneyimi.
- **Teknoloji Yığını:**
  - **Framework:** Flutter & Material 3 (`useMaterial3: true`)
  - **Programlama Dili:** Dart 3 (`sdk: ^3.11.0`)
  - **Mimari:** Feature-Based + Lightweight Clean Architecture
  - **Durum Yönetimi:** Yerleşik `ChangeNotifier`, `ListenableBuilder` ve `InheritedNotifier` (`NotifierScope`)
  - **Hedef Platformlar:** Android, iOS ve Web (Chrome `390×844` mobil görünüm)
- **Resmî Varlıklar:** `assets/images/pairly_logo.png` (`PairlyLogo` widget'ı ile `lib/core/widgets/pairly_logo.dart` içinde sarmalanmıştır).

---

## 2. Bölüm: Proje Amacı ve Mühendislik Hedefleri
1. **Sade Kullanıcı Deneyimi (Dingin ve Odaklı Deneyim):**
   - Geleneksel mobil oyunlardaki karmaşık menüler, agresif geri sayımlar ve göz yoran parlak renkler yerine zihinsel berraklığı destekleyen bir arayüz hedeflenmiştir.
   - Göz yormayan taş/kırık beyaz (`#F7F7F5`) ve adaçayı yeşili (`#5A6D5E`) renk paleti kullanılmıştır.
   - Yalnızca temel oyun metriklerine (Süre, Hamle, Eşleşme) odaklanılmıştır.
   - Arayüz tamamen Türkçe ve sezgiseldir.
2. **Bağımsız ve Sürdürülebilir Yazılım (Sıfır Harici Paket Prensibi):**
   - `pubspec.yaml` dosyasında ekstra üçüncü parti durum yönetimi (`provider`, `bloc`, `riverpod`) veya yerel depolama (`shared_preferences`, `hive`) paketi kullanılmadan tüm altyapı saf Flutter ve Dart ile kurulmuştur.
   - **Durum Yönetimi:** Yerleşik `ChangeNotifier` ve özel `NotifierScope<T>` (`InheritedNotifier<T>`).
   - **Kalıcı Depolama:** Koşullu import (`dart.library.io` / `dart.library.js_interop`) ile mobil/masaüstünde JSON dosyası, Web'de `window.localStorage`.
   - **3B Animasyon:** `TweenAnimationBuilder` ve `Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(angle)`.
3. **Çalışan Mobil Oyun (Tamamlanmış MVP Kapsamı):**
   - `PROJECT.md` dokümanında belirlenen tüm temel gereksinimler uçtan uca çalışan ve test edilmiş bir ürün olarak tamamlanmıştır.
   - 5 kademeli zorluk matrisi (6 karttan 24 karta kadar).
   - Gerçek zamanlı süre (`MM:SS`), hamle, ilerleme yüzdesi, duraklatma modalı ve yeniden başlatma.
   - Kişisel rekor takibi (her zorluk için en iyi süre ve en az hamle) ve son 5 oyun geçmişi.

---

## 3. Bölüm: Kullanıcı Deneyimi (UX) ve 5 Seviyeli Oyun Akışı
- **5 Adımlı Ekran Akışı:**
  1. **Ana Sayfa (`HomeScreen` — `lib/features/home/presentation/home_screen.dart`):**
     - Resmî `PairlyLogo`, açılı ikili kart illüstrasyonu (`HomeHeroCards`), *"Hafızanı keşfet"* başlığı, `"Oyuna Başla"` birincil butonu, `"İstatistikler"` ikincil butonu ve sağ üstte Ayarlar/Tema (`SettingsBottomSheet`) erişimi.
  2. **Zorluk Seçimi (`DifficultyBottomSheet` — `lib/features/difficulty/presentation/difficulty_bottom_sheet.dart`):**
     - Ayrı bir sayfa karmaşası yaratmak yerine `showModalBottomSheet` ile açılan ergonomik 5 seviyeli matris seçici. Varsayılan olarak **Orta (4×4)** seviyesi seçili gelir.
  3. **Oyun Ekranı (`GameScreen` — `lib/features/game/presentation/game_screen.dart`):**
     - Üst barda geri dönüş, tıklanabilir zorluk rozeti, ayarlar ve yeniden başlatma butonları.
     - Canlı Süre (`MM:SS`), Hamle ve Eşleşme (`X / N`) kartları, tamamlanma oranı (`%`) ilerleme çubuğu.
     - Dinamik kart ızgarası ve alt kısımda `"Duraklat"` butonu.
     - Duraklatıldığında açılan odak kartında `"Devam Et"` ve `"Ana Sayfaya Dön"` aksiyonları bulunur.
  4. **Sonuç Ekranı (`ResultScreen` — `lib/features/result/presentation/result_screen.dart`):**
     - Tüm çiftler eşleştiğinde otomatik açılır.
     - `"Tebrikler! Oyunu tamamladın."` mesajı, Süre ve Hamle özet kartları, rekor kırıldıysa `"Yeni En İyi Süre!"` rozeti ve önceki rekora göre saniye farkı (`"Önceki rekorunu X sn geliştirdin"`).
     - `"Tekrar Oyna"` (aynı zorlukta yeni deste başlatır) ve `"Ana Sayfa"` butonları.
  5. **İstatistikler Ekranı (`StatisticsScreen` — `lib/features/statistics/presentation/statistics_screen.dart`):**
     - Genel özet metrikler (Toplam Oyun, Tamamlanan, Eşleşme).
     - 5 zorluk seviyesi için **Kişisel Rekorlar** (En İyi Süre ve En Az Hamle).
     - **Son Oyunlar** listesi (en fazla son 5 tamamlanan oyun kaydı).
     - Henüz tamamlanan oyun yoksa **Boş Durum (Empty State)** ekranı (*"Henüz oyun kaydın yok"*) ve doğrudan `"Oyuna Başla"` aksiyonu.
- **5 Zorluk Seviyesi (`GameDifficulty` enum — `lib/features/game/domain/game_difficulty.dart`):**
  - **Başlangıç:** `3×2` matris • 3 Çift • 6 Kart
  - **Kolay:** `3×4` matris • 6 Çift • 12 Kart
  - **Orta (Varsayılan):** `4×4` matris • 8 Çift • 16 Kart
  - **Zor:** `4×5` matris • 10 Çift • 20 Kart
  - **Uzman:** `4×6` matris • 12 Çift • 24 Kart

---

## 4. Bölüm: Oyun Algoritması (Fisher-Yates & Eşleştirme Mantığı)
- **Deste Üretimi ve Karıştırma (`DeckGenerator` — `lib/features/game/domain/deck_generator.dart`):**
  - 12 sembollük havuzdan (`🌸`, `🍋`, `☕`, `🥑`, `🌿`, `🌲`, `🍄`, `🦋`, `🐚`, `🌙`, `🍓`, `🔔`) seçilen zorluğun `pairsCount` değeri kadar sembol alınır.
  - Her sembol listeye ikişer kez eklenerek çiftler oluşturulur.
  - **Fisher-Yates Shuffle Algoritması:** Listenin son elemanından başlayarak `0..i` aralığında rastgele bir indis seçilir ve yer değiştirilir (`O(n)` zaman karmaşıklığı, her permütasyon için eşit olasılık).
  - Birim testlerinde deterministik doğrulama yapılabilmesi için opsiyonel `Random? random` parametresi desteklenir.
- **Kart Eşleştirme ve Durum Makinesi (`GameController.onCardTap` — `lib/features/game/presentation/game_controller.dart`):**
  - **Koruma Kontrolleri (Guard Clauses):** Oyun duraklatılmışsa (`_isPaused`), tahta kilitliyse (`_isBoardLocked`), oyun bitmişse (`_isCompleted`) veya tıklanan kart zaten açık/eşleşmişse tıklama yoksayılır.
  - **İlk Kart Açılışı:** Kart `isFlipped: true` yapılır, `_flippedIndices` listesine eklenir ve `notifyListeners()` çağrılır.
  - **İkinci Kart Açılışı:** Hamle sayısı (`_moves++`) artırılır ve üçüncü bir kartın açılmasını engellemek için `_isBoardLocked = true` yapılır.
  - **Karşılaştırma (`firstCard.pairId == secondCard.pairId`):**
    - **Doğru Eşleşme:** Her iki kart `isMatched: true` olarak işaretlenir, `_matches++` artırılır, kilit kaldırılır. Eğer `_matches >= totalPairs` ise zamanlayıcılar durdurulur ve `onGameWon` tetiklenir.
    - **Yanlış Eşleşme:** Kartlar oyuncunun görebilmesi için `mismatchDelay` (`700 ms`) boyunca açık kalır; süre sonunda `Timer` ile her iki kart `isFlipped: false` yapılarak kapatılır ve tahta kilidi açılır.

---

## 5. Bölüm: State Management (`ChangeNotifier` & `NotifierScope`)
- **Mimari Tercih:** Harici paket kullanmadan Flutter'ın yerleşik reaktif sınıfları kullanılmıştır.
- **`NotifierScope<T>` (`lib/core/state/notifier_scope.dart`):**
  - `InheritedNotifier<T>` sınıfını genişleten 30 satırlık jenerik sarmalayıcıdır.
  - `NotifierScope.watch<T>(context)`: `dependOnInheritedWidgetOfExactType` kullanarak ilgili controller'daki `notifyListeners()` çağrılarına abone olur ve widget'ı yeniden çizer.
  - `NotifierScope.read<T>(context)`: `getElementForInheritedWidgetOfExactType` kullanarak yeniden çizim tetiklemeden yalnızca aksiyon çağırmak için kullanılır (ör. buton `onPressed` içinde).
- **Uygulamadaki 3 Ana Controller:**
  1. **`GameController` (`lib/features/game/presentation/game_controller.dart`):**
     - `GameScreen` yaşam döngüsüne bağlıdır (`ListenableBuilder` ile dinlenir). Kart listesini, açık kartları, `Timer.periodic` ile saniye sayacını, hamle/eşleşme metriklerini ve duraklatma (`isPaused`) durumunu yönetir.
  2. **`StatisticsController` (`lib/features/statistics/presentation/statistics_controller.dart`):**
     - Uygulama kökünde (`PairlyApp`) `NotifierScope` ile sağlanır. Toplam oyun, tamamlanan oyun, toplam eşleşme, 5 zorluk seviyesi için `PersonalRecord` (en iyi süre / en az hamle) ve son 5 oyun (`GameSessionRecord`) listesini yönetir.
  3. **`AppSettingsController` (`lib/core/state/app_settings_controller.dart`):**
     - Uygulama kökünde `NotifierScope` ile sağlanır. `ThemeMode` (`light`, `dark`, `system`), ses (`soundEnabled`) ve titreşim (`hapticEnabled`) tercihlerini anlık günceller ve kalıcı olarak saklar.

---

## 6. Bölüm: Yazılım Mimarisi (Feature-Based + Lightweight Clean Architecture)
- **Gereksiz Soyutlamadan Kaçınma:** Küçük ve orta ölçekli bir mobil projede aşırı mühendislik (over-engineering) yaratacak boş interface'ler veya gereksiz katmanlar yerine pratik ve modüler bir yapı kurulmuştur.
- **Ana Modüller:**
  - **`core/` Modülü:** Uygulama genelinde paylaşılan sabitler (`AppConstants`), geri bildirim servisi (`FeedbackService`), durum sarmalayıcısı (`NotifierScope`, `AppSettingsController`), platformlar arası yerel depolama (`StorageBackend`), tema sistemi (`AppColors`, `AppTheme`) ve ortak widget'lar (`PairlyLogo`, `PairlyButton`, `SettingsBottomSheet`).
  - **`features/` Modülü:** Her özellik kendi sorumluluk alanında izole edilmiştir:
    - `home/` (`presentation`: `HomeScreen`, `HomeHeroCards`)
    - `difficulty/` (`presentation`: `DifficultyBottomSheet`)
    - `game/` (`domain`: `GameDifficulty`, `MemoryCardItem`, `DeckGenerator` + `presentation`: `GameController`, `GameScreen`, `MemoryCardWidget`)
    - `result/` (`presentation`: `ResultScreen`)
    - `statistics/` (`domain`: `StatisticsData`, `PersonalRecord`, `GameSessionRecord`, `GameCompletionOutcome` + `data`: `StatisticsRepository` + `presentation`: `StatisticsController`, `StatisticsScreen`)
- **3 Katmanlı Sorumluluk Ayrımı:**
  1. **Presentation Katmanı:** Ekranlar, yeniden kullanılabilir widget'lar ve `ChangeNotifier` tabanlı controller sınıfları.
  2. **Domain Katmanı:** UI bağımlılığı olmayan saf Dart veri modelleri, enum yapıları ve deste karıştırma kuralları.
  3. **Data & Core Storage Katmanı:** `StatisticsRepository` ve koşullu import (`storage_backend_io.dart` / `storage_backend_web.dart`) ile JSON serileştirme ve yerel diske/tarayıcıya kayıt.

---

## 7. Bölüm: Arayüz Tasarımı, Renk Sistemi ve Responsive Yapı
- **Google Stitch Referanslarından Dart Widget'larına Dönüşüm:**
  - `design_references/` altındaki HTML/Tailwind tasarımları doğrudan kopyalanmamış; simüle edilmiş iOS durum çubukları yerine gerçek `SafeArea`, `Scaffold` ve Material 3 bileşenleri kullanılmıştır.
- **Merkezi Tema ve Renk Tokenları (`AppColors` & `AppTheme`):**
  - **Light Mode:** Arka plan `#F7F7F5` (kırık beyaz/taş), Kart yüzeyi `#FFFFFF`, Ana vurgu `#5A6D5E` (adaçayı yeşili), İkincil vurgu `#8A9A86`, Birincil metin `#252925`, İkincil metin `#6B726A`.
  - **Dark Mode:** Arka plan `#171D1A` (derin orman/arduvaz), Kart yüzeyi `#252E28`, Ana vurgu `#A5BBA6` (yumuşak adaçayı), Birincil metin `#F1F4EF`, İkincil metin `#8E9B90`.
- **Responsive Izgara (`LayoutBuilder`):**
  - `GameScreen` içinde `LayoutBuilder` ile kullanılabilir ekran genişliği ve yüksekliği ölçülür; sütun/satır sayısına göre `childAspectRatio` dinamik hesaplanarak `3×2`'den `4×6`'ya kadar tüm kart ızgaralarının kaydırma gerektirmeden ekrana tam sığması sağlanır.
- **3B Kart Çevirme Animasyonu (`MemoryCardWidget`):**
  - `TweenAnimationBuilder<double>` (`280 ms`, `Curves.easeInOutCubic`) ve `Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(angle)` ile perspektifli Y ekseni dönüşü uygulanmıştır.

---

## 8. Bölüm: Testler, Kalite Doğrulaması ve Platform Desteği
- **Statik Kod Analizi (`flutter analyze`):**
  - `flutter_lints` kurallarıyla çalıştırılmış ve **0 hata / 0 uyarı (`No issues found!`)** sonucu doğrulanmıştır.
- **Otomatik Testler (`flutter test` — Toplam 11/11 Başarılı):**
  - **`test/game_controller_test.dart` (7 Birim Testi):**
    1. 5 zorluk seviyesinin matris boyutları, kart ve çift sayıları.
    2. `DeckGenerator` tarafından her zorlukta tam çiftlerin üretilmesi.
    3. Doğru eşleşmede kartların açık kalması, hamle ve eşleşme sayacının artması.
    4. Yanlış eşleşmede `mismatchDelay` sonrasında kartların otomatik kapanması.
    5. Duraklatma (`isPaused`) durumunda kart tıklamalarının ve süre sayacının kilitlenmesi.
    6. Tüm çiftler eşleştiğinde `isCompleted` durumu ve `onGameWon` geri çağrımı.
    7. `StatisticsController` kişisel rekor hesaplaması ve geçmişin son 5 oyunla sınırlandırılması.
  - **`test/widget_test.dart` (4 Widget Testi):**
    1. `HomeScreen` bileşenlerinin (logo, başlık, butonlar) doğru render edilmesi.
    2. `"Oyuna Başla"` → `DifficultyBottomSheet` (5 seviye) → `GameScreen` geçişi, `"Duraklat"` modalı ve `"Ana Sayfaya Dön"` işlevi.
    3. `StatisticsScreen` boş durum mesajı ve oyun tamamlandığında rekorların listelenmesi.
    4. Light/Dark tema geçişi ve küçük ekran (`320×480`) taşmasız render testi.
- **Platform Desteği ve Şeffaf Teknik Raporlama (`FeedbackService`):**
  - Harici ses paketi eklenmediği için Flutter'ın yerleşik `SystemSound.play(SystemSoundType.click)` ve `HapticFeedback` API'leri kullanılmıştır.
  - Bu API'ler fiziksel Android ve iOS cihazlarda doğal sistem sesi ve dokunsal titreşim üretir; Flutter Web ve masaüstü tarayıcılarda ise işletim sistemi/tarayıcı kısıtlamaları nedeniyle hata fırlatmadan sessiz (`no-op`) olarak çalışır.

---

## 9. Bölüm: Canlı Demo Akışı ve Yedek Sunum Modu
- **4 Aşamalı Canlı Demo Senaryosu:**
  1. **Başlat:** Ana sayfadan sağ üstteki Ayarlar/Tema geçişini göster; ardından `"Oyuna Başla"` butonuna basarak 5 seviyeli `DifficultyBottomSheet` üzerinden **Başlangıç (3×2)** veya **Orta (4×4)** seviyesini başlat.
  2. **Eşleştir:** Kartların 3B dönüşünü, yanlış eşleşmede `700 ms` sonra otomatik kapanmasını, doğru eşleşmede onay (`✓`) rozetini ve `"Duraklat"` → `"Devam Et"` / `"Ana Sayfaya Dön"` kontrolünü göster.
  3. **Tamamla:** Tüm çiftleri eşleştirerek `ResultScreen` ekranına geç; süre/hamle özetini ve `"Yeni En İyi Süre!"` rozetini göster.
  4. **İstatistikleri İncele:** `StatisticsScreen` ekranına geçerek 5 zorluk seviyesi için Kişisel Rekorlar tablosunu ve Son 5 Oyun geçmişini göster.
- **Yedek (Fallback) Görsel Galerisi:**
  - Sunum bilgisayarında Flutter/Chrome penceresi açılmazsa, 9. slayttaki interaktif ekran seçici üzerinden gerçek uygulama ekran görüntüleri (`flutter_app_game.png`, `flutter_app_pause.png`) ve tasarım referansları doğrudan gösterilebilir.

