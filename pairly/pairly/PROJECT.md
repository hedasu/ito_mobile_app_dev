# Pairly — Kart Eşleştirme Oyunu

## 1. Proje Tanımı
Pairly, Flutter ile geliştirilecek, minimal ve kullanıcı dostu bir mobil hafıza oyunudur. Oyuncular kapalı kartları açarak aynı sembolleri eşleştirmeye çalışır.

**Hedef platform:** Android ve iOS

## 2. Teknolojiler
- **Framework:** Flutter
- **Programlama Dili:** Dart
- **UI Tasarımı:** Google Stitch
- **Geliştirme Ortamı:** Google Antigravity
- **State Management:** ChangeNotifier
- **Veri Saklama:** Yerel depolama
- **Backend:** Yok (MVP)

## 3. Temel Özellikler
- Kolay: 4 çift / 8 kart
- Orta: 8 çift / 16 kart
- Zor: 12 çift / 24 kart
- Kart çevirme animasyonu
- Kart eşleştirme algoritması
- Süre ve hamle sayacı
- Eşleşme ilerleme göstergesi
- Oyun sonuç ekranı
- İstatistikler ve kişisel rekorlar
- Yeniden oynama

## 4. Ekranlar
1. **HomeScreen:** Ana sayfa
2. **DifficultyScreen:** Zorluk seçimi
3. **GameScreen:** Oyun alanı
4. **ResultScreen:** Oyun sonucu
5. **StatisticsScreen:** İstatistikler

## 5. Tasarım Sistemi
- **Stil:** Minimal, sade ve modern
- **Arka Plan:** `#F7F7F5`
- **Ana Renk:** `#657568`
- **Metin:** `#252925`
- **Kartlar:** Yuvarlatılmış köşeler
- **UI:** Material 3
- **Dil:** Türkçe
- **Responsive:** Farklı mobil ekran boyutları

Google Stitch tasarımları temel alınacaktır.

## 6. Yazılım Mimarisi

**Feature-Based + Lightweight Clean Architecture**

Özellikler kendi klasörlerinde geliştirilecek. Gerektiğinde üç katman kullanılacak:

- **Presentation:** Ekranlar, widget'lar, controller'lar
- **Domain:** Oyun kuralları, entity'ler, servisler
- **Data:** Yerel veri saklama ve repository'ler

Gereksiz abstraction, interface veya use case katmanları oluşturulmayacak.

### Klasör Yapısı

```text
lib/
├── core/
│   ├── theme/
│   ├── constants/
│   └── widgets/
│
├── features/
│   ├── home/
│   │   └── presentation/
│   ├── difficulty/
│   │   └── presentation/
│   ├── game/
│   │   ├── presentation/
│   │   ├── domain/
│   │   └── data/
│   ├── result/
│   │   └── presentation/
│   └── statistics/
│       ├── presentation/
│       ├── domain/
│       └── data/
│
└── main.dart
```

## 7. Geliştirme Kuralları
- Kodlar modüler, okunabilir ve test edilebilir olmalı.
- Oyun mantığı UI'dan bağımsız tutulmalı.
- State management için ChangeNotifier kullanılmalı.
- Tekrarlanan bileşenler reusable widget olmalı.
- Gereksiz paket ve bağımlılıklardan kaçınılmalı.
- Dart ve Flutter naming convention kurallarına uyulmalı.
- Oyun mantığı için birim testleri yazılmalı.
- Stitch tasarımına sadık kalınmalı.
- Öncelik çalışan MVP olmalı.

## 8. Geliştirme Aşamaları
1. Flutter proje kurulumu
2. Mimari ve klasör yapısı
3. Tema sistemi
4. Stitch ekranlarının Flutter'a aktarılması
5. Kart eşleştirme mantığı
6. Animasyonlar ve sayaçlar
7. Yerel istatistik sistemi
8. Test ve optimizasyon

## 9. Proje Hedefi
Profesyonel yazılım geliştirme prensiplerine uygun, sürdürülebilir, akıcı ve minimal bir Flutter mobil oyunu oluşturmak.