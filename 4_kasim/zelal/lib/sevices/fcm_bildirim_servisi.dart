// Firebase'den gelen mesajları almak için kullanılır.
import 'package:firebase_messaging/firebase_messaging.dart';

// Gelen mesajları telefon ekranında bildirim olarak göstermek için kullanılır.
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ARKA PLAN BİLDİRİMLERİ

@pragma('vm:entry-point')
// Uygulama arka plandayken bu fonksiyonun korunmasını sağlar.
Future<void> fcmBackgroundHandler(RemoteMessage message) async {
  // Future<void>: İşlem zaman alabilir, geriye değer döndürmez.
  // RemoteMessage: Firebase'den gelen mesajın türüdür.
  // async: Asenkron işlem yapabilmemizi sağlar.
  // Şu an fonksiyon boş, yani gelen mesaja ek işlem yapmıyoruz.
}

// BİLDİRİM SİSTEMİ SINIFI

class FcmBildirimSistemi {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  // Firebase mesajlaşma sistemine erişmemizi sağlar.
  // instance: FirebaseMessaging'in mevcut örneğini verir.
  // final: Değişkene sonradan başka bir değer atanamaz.
  // _: Değişkenin bulunduğu Dart kütüphanesine özel olduğunu belirtir.

  final FlutterLocalNotificationsPlugin _localPlugin =
      FlutterLocalNotificationsPlugin();
  // Telefon ekranında yerel bildirim göstermek için kullanılır.

  // 1. BİLDİRİM SİSTEMİNİ BAŞLATMA

  Future<void> baslat({
    required Function(RemoteMessage message) onMesajGeldi,
    // required: Bu parametrenin verilmesi zorunludur.
    // Function: Dışarıdan bir fonksiyon alır.
    // onMesajGeldi: Mesaj geldiğinde çalışacak fonksiyon.
  }) async {
    await _fcm.requestPermission(
      alert: true, // Bildirim gösterme izni.
      badge: true, // Uygulama ikonunda sayı gösterme izni.
      sound: true, // Bildirim sesi izni.
    );
    // await: İşlemin tamamlanmasını bekler.
    // Kullanıcıdan bildirim izni ister.

    // ANDROID VE IOS AYARLARI

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
      // Android bildirimlerinde kullanılacak uygulama ikonu.
    );

    const iosSettings = DarwinInitializationSettings();
    // iPhone için bildirim başlangıç ayarları.

    const initSettings = InitializationSettings(
      android: androidSettings, // Android ayarlarını ekler.
      iOS: iosSettings, // iOS ayarlarını ekler.
    );
    // İki platformun ayarlarını birleştirir.

    await _localPlugin.initialize(initSettings);
    // Yerel bildirim sistemini kullanıma hazırlar.

    // UYGULAMA AÇIKKEN MESAJ DİNLEME

    FirebaseMessaging.onMessage.listen((message) {
      // onMessage: Uygulama ön plandayken gelen mesajları yakalar.
      // listen: Mesaj gelmesini dinler.
      // message: Firebase'den gelen mesajdır.

      _yerelBildirimGoster(message);
      // Gelen mesajı telefon ekranında bildirim olarak gösterir.

      onMesajGeldi(message);
      // Dışarıdan verilen fonksiyonu çalıştırır.
      // Örneğin ekrandaki mesaj listesini güncelleyebilir.
    });

    // ARKA PLAN MESAJLARI

    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);
    // Uygulama arka plandayken gelen mesajları
    // fcmBackgroundHandler fonksiyonuna yönlendirir.
  }

<<<<<<< HEAD:4_kasim/zelal/lib/sevices/fcm_bildirim_servisi.dart
  Future<String?> tokenAl() async {
    try {
      return await _fcm.getToken();
    } catch (_) {
      return null;
    }
  }
=======
  // 2. BİR KONUYA ABONE OLMA
>>>>>>> 63d764712eaba5d313e49e2207ec1641fdf9dea8:4_kasım/zelal/lib/sevices/fcm_bildirim_servisi.dart

  Future<void> konuyaAboneOl(String konu) async {
    // String konu: Abone olunacak konunun adıdır.

    await _fcm.subscribeToTopic(konu);
    // Belirtilen konunun bildirimlerine abone olur.
    // Örnek: konuyaAboneOl('dersler');
    // 'dersler' konusuna gönderilen bildirimleri alabiliriz.
  }

  // 3. BİR KONUDAN AYRILMA

  Future<void> konudanAyril(String konu) async {
    await _fcm.unsubscribeFromTopic(konu);
    // Belirtilen konunun aboneliğinden çıkar.
    // Örnek: konudanAyril('dersler');
    // Artık bu konuya gönderilen bildirimleri almayız.
  }

  // 4. GELEN MESAJI TELEFONDA GÖSTERME

  Future<void> _yerelBildirimGoster(RemoteMessage message) async {
    // Firebase'den gelen mesajı bildirim olarak gösterir.
    // _: Bu fonksiyon bulunduğu kütüphaneye özeldir.

    // ANDROID BİLDİRİM AYARLARI

    const androidDetails = AndroidNotificationDetails(
      'softito_fcm_channel_id',
      // Bildirim kanalının benzersiz kimliği (ID).

      'SoftIto Bildirimleri',
      // Telefonun ayarlarında görünen bildirim kanalı adı.

      channelDescription: 'Fcm Push Bildirimleri',
      // Bildirim kanalının açıklaması.

      importance: Importance.max,
      // Bildirimin önem seviyesini en yüksek yapar.

      priority: Priority.high,
      // Android'de bildirimin önceliğini yüksek yapar.
    );

    // ANDROID VE IOS BİLDİRİM DETAYLARI

    const details = NotificationDetails(
      android: androidDetails,
      // Android için hazırladığımız ayarları kullanır.

      iOS: DarwinNotificationDetails(),
      // iPhone için bildirim detaylarını belirler.
    );

    // BİLDİRİMİ EKRANDA GÖSTERME

    await _localPlugin.show(
      message.hashCode,
      // Bildirime bir ID verir.
      // hashCode: Mesaj nesnesinden elde edilen sayısal değer.

      message.notification?.title ?? 'Yeni Bildirim',
      // Bildirimin başlığını gösterir.
      // ?. : Değer null ise hata vermeden devam eder.
      // ?? : Başlık null ise 'Yeni Bildirim' yazar.

      message.notification?.body ?? '',
      // Bildirimin açıklama metnini gösterir.
      // Açıklama null ise boş metin kullanır.

      details,
      // Yukarıda hazırladığımız bildirim ayarlarını uygular.
    );
  }
}
