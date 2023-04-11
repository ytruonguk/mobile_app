import 'package:blackhole/Data/Core/pref_db.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocal {
  Future<void> saveToken({required String token});

  Future<String> getToken();
}

class UserLocalDataSourceImpl implements UserLocal {
  static const String _CACHE_USER_INFO = 'CACHE_USER_INFO';

  @override
  Future<void> saveToken({required String token}) async =>
      PrefDb(await SharedPreferences.getInstance()).saveToken(token);

  @override
  Future<String> getToken() async =>
      PrefDb(await SharedPreferences.getInstance()).getToken();
}
