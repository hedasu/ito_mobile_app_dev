// FLUTTER KÜTÜPHANESİ

import 'package:flutter/material.dart';
// Flutter'ın görsel bileşenlerini (Widget) kullanmamızı sağlar.

import '../models/bildirim_modeli.dart';

// BildirimModeli sınıfını projeye dahil eder.
// ../ : Bir üst klasöre çıkmayı sağlar.

// BİLDİRİM LİSTESİ KARTI

class BildirimListesiKarti extends StatelessWidget {
  // StatelessWidget: Kendi içinde değişen durum tutmayan widget.
  // extends: Flutter'ın StatelessWidget sınıfından özellik alır.

  final List<BildirimModeli> bildirimler;
  // List: Birden fazla elemanı tutar.
  // BildirimModeli: Listedeki elemanların veri türüdür.
  // bildirimler: Gelen bildirimlerin listesi.

  final String? token;
  // String?: Metin veya null olabilir.
  // token: Firebase'in cihaza/uygulama kurulumuna verdiği FCM tokeni.

  final bool konuyaAboneMi;
  // bool: true veya false değer alır.
  // Kullanıcının bildirim konusuna abone olup olmadığını belirtir.

  final ValueChanged<bool> onAboneDegisti;
  // ValueChanged<bool>: bool değer alan bir callback fonksiyonudur.
  // Switch değiştiğinde yeni true/false değerini dışarıya gönderir.

  // CONSTRUCTOR (YAPICI METOT)

  const BildirimListesiKarti({
    super.key,
    // super.key: Widget'ın key bilgisini üst sınıfa gönderir.
    // Flutter'ın widget'ları tanımasına yardımcı olur.

    required this.bildirimler,
    // required: Parametreyi vermek zorundayız.
    // this.bildirimler: Gelen değeri sınıfın değişkenine atar.

    required this.token,
    // Token null olabilir ama parametreyi vermek zorunludur.

    required this.konuyaAboneMi,
    // Abonelik durumunu dışarıdan alır.

    required this.onAboneDegisti,
    // Switch değiştiğinde çalışacak fonksiyonu dışarıdan alır.
  });

  // EKRANI OLUŞTURMA

  @override
  // Üst sınıftaki build metodunu yeniden tanımlar.
  Widget build(BuildContext context) {
    // build(): Ekranda gösterilecek widget ağacını oluşturur.
    // BuildContext: Widget'ın ağaçtaki konumunu temsil eder.

    return Card(
      // Card: İçeriği kart şeklinde gösterir.

      elevation: 0,
      // Kartın gölge yüksekliğidir.
      // 0: Gölge yok.

      shape: RoundedRectangleBorder(
<<<<<<< HEAD:4_kasim/zelal/lib/widgets/bildirim_listesi_karti.dart
        borderRadius: BorderRadius.circular(16),
=======
        // Kartın kenar şeklini belirler.

        borderRadius: BorderRadiusGeometry.circular(16),
        // Kartın köşelerini 16 birim yuvarlatır.

>>>>>>> 63d764712eaba5d313e49e2207ec1641fdf9dea8:4_kasım/zelal/lib/widgets/bildirim_listesi_karti.dart
        side: BorderSide(color: Colors.grey.shade300),
        // Kartın kenarına açık gri çizgi ekler.
      ),

      child: Padding(
        // Padding: İçerikle kartın kenarı arasında boşluk bırakır.

        padding: const EdgeInsets.all(16),
        // Kartın dört tarafından 16 birim boşluk bırakır.

        child: Column(
          // Column: Widget'ları dikey olarak alt alta dizer.

          crossAxisAlignment: CrossAxisAlignment.stretch,
          // Çocukların yatay eksende mevcut genişliği doldurmasını sağlar.

          children: [
            // 1. BAŞLIK VE ABONELİK ANAHTARI

            Row(
              // Row: Widget'ları yatay olarak yan yana dizer.

              children: [
                const Icon(
                  Icons.notifications_active_outlined,
                  // Bildirim simgesi.

                  color: Color(0xFF006C4A),
                  // Simgenin rengi.
                ),

                const SizedBox(width: 8),
                // İkon ile yazı arasında 8 birim boşluk.

                const Expanded(
                  // Expanded: Row içinde kalan kullanılabilir alanı kaplar.

                  child: Text(
                    'FCM Bildirim Merkezi',
                    // Kartın başlık metni.

                    style: TextStyle(
                      fontSize: 16,
                      // Yazı boyutu.

                      fontWeight: FontWeight.bold,
                      // Yazıyı kalın yapar.

                      color: Color(0xFF0F172A),
                      // Yazının rengi.
                      // NOT: Orijinal kodda 0xFFF172A yazıyordu.
                      // Eksik hex değeri olduğu için düzeltildi.
                    ),
                  ),
                ),

                Switch(
                  // Switch: Açma/kapama anahtarıdır.

                  value: konuyaAboneMi,
                  // true: Anahtar açık.
                  // false: Anahtar kapalı.

                  onChanged: onAboneDegisti,
                  // Anahtara basılınca fonksiyonu çalıştırır.
                  // Yeni true/false değerini dışarıya gönderir.
                  // Abonelik işlemini kendi başına yapmaz.

                  activeColor: const Color.fromARGB(15, 160, 40, 50),
                  // Switch açıkken kullanılan renk.
                  // fromARGB: Alpha, Red, Green, Blue.
                  // İlk sayı (15): Saydamlık, 0-255 arası.
                  // 15 çok saydam bir renktir.
                ),
              ],
            ),
<<<<<<< HEAD:4_kasim/zelal/lib/widgets/bildirim_listesi_karti.dart
            Text(
              konuyaAboneMi ? 'tüm sınıf yayını aktif' : 'yayın kapalı',
=======

            // 2. ABONELİK DURUMU
            Text(
              konuyaAboneMi ? 'tüm sınıf yayını aktif' : 'Yayın Kapalı',
              // Ternary operatör: koşul ? doğruysa : yanlışsa
              // true ise: "tüm sınıf yayını aktif"
              // false ise: "Yayın Kapalı"

>>>>>>> 63d764712eaba5d313e49e2207ec1641fdf9dea8:4_kasım/zelal/lib/widgets/bildirim_listesi_karti.dart
              style: TextStyle(
                fontSize: 12,
                // Yazı boyutu.

                color: konuyaAboneMi
                    ? const Color.fromARGB(15, 24, 59, 17)
                    : Colors.grey.shade600,
                // Aboneyse ilk renk kullanılır.
                // Abone değilse gri renk kullanılır.
                // NOT: İlk renkte alpha 15, yani neredeyse görünmez.

                fontWeight: FontWeight.w600,
                // Yazıyı yarı kalın yapar.
              ),
            ),

            const SizedBox(height: 12),
            // Altına 12 birim boşluk bırakır.

            // 3. FCM TOKEN GÖSTERME ALANI
            Container(
              // Container: İçeriği bir kutu içinde gösterir.

              padding: const EdgeInsets.all(10),
              // Kutunun içinde dört taraftan 10 birim boşluk.

              decoration: BoxDecoration(
                // Kutunun arka planını ve köşelerini düzenler.

                color: const Color(0xFF0F172A),
                // Koyu arka plan rengi.

                borderRadius: BorderRadius.circular(8),
                // Kutunun köşelerini yuvarlatır.
              ),

              child: Column(
                // İçindeki yazıları alt alta yerleştirir.

                crossAxisAlignment: CrossAxisAlignment.start,
                // Yazıları yatay eksende sola hizalar.

                children: [
                  const Text(
<<<<<<< HEAD:4_kasim/zelal/lib/widgets/bildirim_listesi_karti.dart
                    "Cihazın FCM tokeni",
=======
                    'Cihazın FCM tokeni',
                    // Token alanının başlığı.

>>>>>>> 63d764712eaba5d313e49e2207ec1641fdf9dea8:4_kasım/zelal/lib/widgets/bildirim_listesi_karti.dart
                    style: TextStyle(
                      color: Color.fromARGB(255, 26, 40, 52),
                      // Yazı rengi.
                      // NOT: Koyu arka planda bu renk zor görünür.

                      fontSize: 11,
                      // Küçük yazı boyutu.
                    ),
                  ),

                  const SizedBox(height: 2),
                  // Başlık ile token arasında 2 birim boşluk.

                  SelectableText(
<<<<<<< HEAD:4_kasim/zelal/lib/widgets/bildirim_listesi_karti.dart
                    token ?? 'token alınıyor.',
=======
                    // SelectableText: Seçilebilir ve kopyalanabilir metin.

                    token ?? 'token alınıyor',
                    // ?? : Null kontrolü yapar.
                    // Token varsa tokeni gösterir.
                    // Token null ise "token alınıyor" yazar.

>>>>>>> 63d764712eaba5d313e49e2207ec1641fdf9dea8:4_kasım/zelal/lib/widgets/bildirim_listesi_karti.dart
                    style: const TextStyle(
                      color: Color(0xFF388888),
                      // Token yazısının rengi.

                      fontSize: 11,
                      // Yazı boyutu.

                      fontFamily: 'monospace',
                      // Her karakterin aynı genişlikte olduğu yazı tipi.
                      // Token gibi teknik metinlerde okunabilirliği artırır.
                    ),
                  ),
                ],
              ),
            ),

            // 4. GELEN BİLDİRİMLER BAŞLIĞI
            const SizedBox(height: 14),
            // Üst bölümden 14 birim boşluk bırakır.

            Text(
              'Gelen Bildirimler (${bildirimler.length}):',
              // ${}: String içine değişken veya ifade yerleştirir.
              // bildirimler.length: Listede kaç bildirim olduğunu verir.
              // Örnek: "Gelen Bildirimler (3):"

              style: const TextStyle(
                fontWeight: FontWeight.bold,
                // Kalın yazı.

                fontSize: 14,
                // Yazı boyutu.

                color: Color.fromARGB(0, 5, 249, 253),
                // NOT: Alpha 0 olduğu için yazı tamamen görünmez!
                // Görünmesi için alpha değerini 255 yapmalıyız.
              ),
            ),

            const SizedBox(height: 8),
            // Başlık ile bildirim listesi arasında boşluk.

            // 5. BİLDİRİMLERİ LİSTELEME
            bildirimler.isEmpty
                // isEmpty: Listenin boş olup olmadığını kontrol eder.
                // true: Liste boş.
                // false: Listede eleman var.
                ? Container(
<<<<<<< HEAD:4_kasim/zelal/lib/widgets/bildirim_listesi_karti.dart
                    padding: const EdgeInsets.all(24),
=======
                    // Liste boşsa bu kutu gösterilir.

                    padding: const EdgeInsets.all(10),
                    // Kutunun iç boşluğu.

>>>>>>> 63d764712eaba5d313e49e2207ec1641fdf9dea8:4_kasım/zelal/lib/widgets/bildirim_listesi_karti.dart
                    alignment: Alignment.center,
                    // İçeriği ortalar.

                    child: Text(
                      'Henüz gelen bildirim yok',
                      // Liste boşken gösterilen mesaj.

                      textAlign: TextAlign.center,
                      // Metni ortalar.

                      style: TextStyle(
                        fontSize: 12,
                        // Yazı boyutu.

                        color: Colors.grey.shade500,
                        // Açık gri yazı rengi.
                      ),
                    ),
                  )
                : ListView.separated(
                    // Liste boş değilse burası çalışır.
                    // ListView.separated: Elemanları aralarına
                    // ayırıcı çizgi koyarak listeler.

                    shrinkWrap: true,
                    // Liste sadece içindeki elemanlar kadar yer kaplar.

                    physics: const NeverScrollableScrollPhysics(),
                    // Listenin kendi içinde kaydırılmasını kapatır.

                    itemCount: bildirimler.length,
<<<<<<< HEAD:4_kasim/zelal/lib/widgets/bildirim_listesi_karti.dart
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final b = bildirimler[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          backgroundColor: Color.fromARGB(0, 123, 238, 230),
                          child: Icon(
                            Icons.mark_email_unread_outlined,
                            color: Color.fromARGB(0, 123, 25, 25),
                            size: 20,
                          ),
                        ),
                        title: Text(
                          b.baslik,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(b.icerik),
                        trailing: Text(
                          //padLeft: 2 basamaklı değilse başına 0 koyar
                          '${b.tarih.hour.toString().padLeft(2, '0')}:${b.tarih.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      );
                    },
=======
                    // Kaç eleman oluşturulacağını belirler.
                    // Örnek: 5 bildirim varsa 5 eleman.

                    separatorBuilder: (_, _) => const Divider(height: 1),
                    // separatorBuilder: Elemanlar arasına ayırıcı ekler.
                    // Divider: İnce yatay çizgi.
                    // _: Kullanılmayan parametre.

                    itemBuilder: (context, index) {},
                    // itemBuilder: Her bildirim için widget oluşturur.
                    // context: Widget'ın ağaçtaki konumu.
                    // index: Listedeki elemanın sıra numarası (0'dan başlar).
                    // Örnek: bildirimler[index]
                    //
                    // DİKKAT: Bu fonksiyon şu anda boş!
                    // Her eleman için bir Widget döndürmesi gerekir.
                    // Bu haliyle liste elemanları çizilemez.
>>>>>>> 63d764712eaba5d313e49e2207ec1641fdf9dea8:4_kasım/zelal/lib/widgets/bildirim_listesi_karti.dart
                  ),
          ],
        ),
      ),
    );
  }
}
