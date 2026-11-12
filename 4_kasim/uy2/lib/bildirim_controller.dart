import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// Cihazda yerel bildirim göstermek için kullanılan paket.

import 'package:firebase_messaging/firebase_messaging.dart';

// Firebase'den gelen mesajları almak ve yönetmek için kullanılır.

class YerelBildirimYoneticisi {
  // Bildirim işlemlerini tek sınıfta topluyoruz.

  static final FlutterLocalNotificationsPlugin _yerelBildirim =
      FlutterLocalNotificationsPlugin();
  // static: Sınıf üzerinden erişilebilir.
  // final: Başka bir nesne atanamaz.
  // FlutterLocalNotificationsPlugin(): Bildirim yöneticisi nesnesi.
  // _: Değişkeni kütüphane içinde private yapar.

  static Future<void> kurulum() async {
    // Bildirim eklentisini başlatmak için kullanılan fonksiyon.

    const androidAyarlar = AndroidInitializationSettings('@mipmap/ic_launcher');
    // Android başlangıç ayarlarını oluşturur.
    // @mipmap/ic_launcher: Uygulamanın ikon kaynağı.

    const iosAyarlar = DarwinInitializationSettings();
    // iOS için başlangıç ayarlarını oluşturur.

    const ayarlar = InitializationSettings(
      android: androidAyarlar,
      iOS: iosAyarlar,
    );
    // Android ve iOS ayarlarını tek nesnede birleştirir.

    await _yerelBildirim.initialize(settings: ayarlar);
    // initialize(): Bildirim eklentisini başlatır.
    // await: Başlatma işleminin bitmesini bekler.
  }

  static Future<void> bildirimGoster(RemoteMessage message) async {
    // Firebase'den gelen mesajı parametre olarak alır.
    // RemoteMessage: Gelen Firebase mesajının veri tipi.

    const androidDetay = AndroidNotificationDetails(
      'softito_kanal_id',
      // Bildirim kanalının benzersiz kimliği.

      'Softito Bildirimleri',
      // Bildirim kanalının kullanıcıya görünen adı.

      importance: Importance.max,
      // En yüksek kanal önem seviyesi.

      priority: Priority.high,
      // Bildirimin önceliğini yüksek yapar.

      playSound: true,
      // Bildirim sesi etkinleştirilir.
    );

    const detaylar = NotificationDetails(android: androidDetay);
    // NotificationDetails: Platform bildirim ayarlarını tutar.
    // android: Android için oluşturduğumuz ayarları verir.
    // detaylar: show() fonksiyonuna aktaracağımız nesne.

    await _yerelBildirim.show(
      // show(): Yerel bildirimi göstermeyi ister.
      // await: Bildirim gösterme işleminin sonucunu bekler.

      id: message.hashCode,
      // id: Bildirimin sayısal kimliği.
      // hashCode: message nesnesinden bir int değer üretir.

      title: message.notification?.title ?? 'Yeni Bildirim',
      // title: Bildirim başlığı.
      // ?.: notification null değilse title değerine eriş.
      // ??: Başlık null ise 'Yeni Bildirim' yaz.

      body: message.notification?.body ?? '',
      // body: Bildirimin içeriği.
      // İçerik null ise boş metin kullan.

      notificationDetails: detaylar,
      // Daha önce oluşturduğumuz bildirim ayarlarını kullan.
    );
  }
}
