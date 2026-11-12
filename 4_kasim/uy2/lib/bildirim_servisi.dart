import 'package:firebase_messaging/firebase_messaging.dart';

// en üstte olmak zorunda.izin fonksiyonunu arka planda yaklaama fonksiyonu
@pragma ('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  print("Arka planda bildirim geldi:${message.notifications?.title}")
}

//izin fonksiyonu
class BildirimServisi {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  Future<void> baslat() async{
    NotificationSettings settings = await _fcm.requestPermission(alert: 
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus==AuthorizationStatus.authorized){
      print("Kullanıcı bildirim iznini verdi");
    }
    final token= await _fcm.getToken();
    print('Cihazın FCM tokenı: $token');
  }
}

