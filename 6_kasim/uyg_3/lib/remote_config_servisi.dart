import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigServisi {
  final FirebaseRemoteConfig _rc = FirebaseRemoteConfig.instance;

  Future<void> baslat() async {
    await _rc.setConfigSettings(
      RemoteConfigSettings(
      fetchTimeout : const Duration(seconds: 10),
      minimumFetchInterval : Duration.zero, 
      ),
    );
  
    await _rc.setDefaults(const{
      'kampanya_aktif' : false,
      'kampanya_metni' : 'Bugun beratta kampanya var 3 kere ders anlatacakmış',
      
    })
  
  
  
  
  }
}
