// DOSYA VE KÜTÜPHANELER

import 'dart:io';
// Telefonda bulunan dosyalarla işlem yapmamızı sağlar.
// File sınıfını kullanmak için gereklidir.

import 'package:firebase_storage/firebase_storage.dart';
// Dosyaları Firebase Storage'a yüklemek, indirme linkini almak
// ve silmek için kullanılır.

import 'package:image_picker/image_picker.dart';

// Telefonun galerisinden veya kamerasından fotoğraf seçmemizi sağlar.

// FIREBASE STORAGE SINIFI

class StorageService {
  // StorageService: Dosya işlemlerini yöneten sınıfımız.

  final FirebaseStorage _storage = FirebaseStorage.instance;
  // Firebase Storage sistemine erişmemizi sağlar.
  // instance: Firebase Storage'ın mevcut örneğini verir.
  // final: Değişkene sonradan başka bir değer atanamaz.
  // _: Değişkenin bulunduğu Dart kütüphanesine özel olduğunu belirtir.

  final ImagePicker _picker = ImagePicker();
  // Kameradan veya galeriden fotoğraf seçmek için kullanılır.

  // 1. TELEFONDAN GÖRSEL SEÇME

  Future<File?> gorselSec({bool kameradan = false}) async {
    // Future: İşlem zaman alabilir.
    // File: Seçilen dosyayı temsil eder.
    // ?: Sonuç null olabilir (kullanıcı fotoğraf seçmeyebilir).
    // bool: true veya false değer alır.
    // kameradan = false: Varsayılan olarak galeriyi açar.
    // async: İçerisinde await kullanabilmemizi sağlar.

    final XFile? xFile = await _picker.pickImage(
      // XFile: image_picker tarafından seçilen dosyanın türüdür.
      // ?: Kullanıcı seçim yapmazsa null dönebilir.
      // await: Fotoğraf seçme işleminin bitmesini bekler.
      // pickImage(): Fotoğraf seçme ekranını açar.

      source: kameradan ? ImageSource.camera : ImageSource.gallery,
      // source: Fotoğrafın nereden seçileceğini belirler.
      // ? : Ternary (üçlü koşul) operatörüdür.
      // kameradan true ise kamera açılır.
      // kameradan false ise galeri açılır.

      imageQuality: 80,
      // Fotoğraf kalitesini 0-100 arasında ayarlar.
      // 80: Dosya boyutunu azaltmak için kaliteyi düşürebilir.

      maxWidth: 1200,
      // Fotoğrafın genişliğini en fazla 1200 piksel yapar.
      // Daha büyük fotoğraflar küçültülür.
    );

    if (xFile == null) return null;
    // Kullanıcı fotoğraf seçmeden çıkarsa null döndürür.
    // Böylece olmayan dosyayla işlem yapmayız.

    return File(xFile.path);
    // xFile.path: Seçilen fotoğrafın cihazdaki dosya yoludur.
    // File(): Bu yolu Dart'ın File nesnesine dönüştürür.
    // return: Oluşturulan File nesnesini geri döndürür.
  }

  // 2. DOSYAYI FIREBASE STORAGE'A YÜKLEME

  UploadTask yuklemeBaslat({
    required File dosya,
    // required: Bu parametreyi vermek zorundayız.
    // File dosya: Yüklenecek dosyadır.

    required String dosyaAdi,
    // String: Metin türüdür.
    // dosyaAdi: Firebase'e kaydedilecek dosyanın adıdır.

    String klasor = 'yuklemeler',
    // Klasör belirtilmezse 'yuklemeler' kullanılır.
  }) {
    // UploadTask: Yükleme işlemini temsil eder.
    // Yükleme ilerlemesini takip etmemizi sağlar.

    final Reference ref = _storage.ref().child('$klasor/$dosyaAdi');
    // Reference: Firebase Storage'daki dosya konumunu temsil eder.
    // _storage.ref(): Storage'ın kök konumuna erişir.
    // child(): Belirtilen dosya yolunu oluşturur.
    // $ : String içine değişkenin değerini yerleştirir.

    // Örnek:
    // klasor = 'profil'
    // dosyaAdi = 'resim.jpg'
    // Oluşan yol: profil/resim.jpg

    final metadata = SettableMetadata(
      // Metadata: Dosyaya ait ek bilgilerdir.

      contentType: '*',
      // Dosyanın içerik türünü belirtir.
      // NOT: '*' geçerli bir MIME türü değildir.
      // JPEG için 'image/jpeg', PNG için 'image/png' kullanılır.

      customMetadata: {'ekleyen': 'Zelal Dartan'},
      // Dosyaya özel bilgi ekler.
      // 'ekleyen': Anahtar (key)
      // 'Zelal Dartan': Değer (value)
    );

    return ref.putFile(dosya, metadata);
    // putFile(): Dosyayı Firebase Storage'a yüklemeyi başlatır.
    // dosya: Yüklenecek dosya.
    // metadata: Dosyanın ek bilgileri.
    // return: Yükleme görevini (UploadTask) geri döndürür.
  }

  // 3. YÜKLENEN DOSYANIN URL'SİNİ ALMA

  Future<String> urlGetir(Reference ref) async {
    // Future<String>: İşlem bitince String döndürür.
    // String: Dosyanın indirme bağlantısıdır.
    // Reference ref: Firebase'deki dosyanın konumudur.

    return await ref.getDownloadURL();
    // getDownloadURL(): Dosyanın indirme bağlantısını getirir.
    // await: Bağlantının alınmasını bekler.
    // return: URL'yi geri döndürür.
  }

  // 4. FIREBASE STORAGE'DAN DOSYA SİLME

  Future<void> dosyaSil(String dosyaYolu) async {
    // Future<void>: İşlem zaman alır, geriye değer döndürmez.
    // dosyaYolu: Silinecek dosyanın Firebase'deki konumudur.

    final Reference ref = _storage.ref().child(dosyaYolu);
    // Silinecek dosyanın Firebase Storage referansını bulur.
    // Örnek dosyaYolu: 'yuklemeler/resim.jpg'

    await ref.delete();
    // delete(): Dosyayı Firebase Storage'dan siler.
    // await: Silme işleminin tamamlanmasını bekler.
  }
}
