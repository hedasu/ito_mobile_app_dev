import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageServisi {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask yuklemeBaslat({
    required File dosya,
    required String hedefDizin,
    required String dosyaAdi,
  }) {
    final Reference ref = _storage.ref().child('$hedefDizin/$dosyaAdi');
    contentType: 'image/jpeg',
    customMetadata: (
      'yukleyen' : {'Faik fahri fuat furkan fahrettin tek kişilik dev kadro',
    },
    );

   return ref.putFile(dosya,metaData);
  }

task.snapshot.listen((TaskSnapshot snapshot){
  final double yuzde=snapshot.bytesTransferred / snapshot.totalBytes;
  print('yukleniyor %${(yuzde*100).toStringAsFixed}');
});

}
