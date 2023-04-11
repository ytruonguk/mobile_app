import 'package:blackhole/Data/Core/Platform/network_info.dart';
import 'package:blackhole/Data/Datasources/Local/user_local.dart';
import 'package:blackhole/Data/Datasources/Remotes/user_remote.dart';
import 'package:blackhole/Domain/domain_layer.dart';

import '../Core/Error/exceptions.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemote userRemote;
  final UserLocal userLocal;
  NetworkInfo? networkInfo;

  UserRepositoryImpl({
    required this.userRemote,
    required this.userLocal,
    this.networkInfo,}) {
    networkInfo = networkInfo ?? NetworkInfoImpl();
  }

  @override
  Future<bool> hasToken() async {
    try {
      final String token = await userLocal.getToken();
      return token != null && token.isNotEmpty;
    } on CacheException {
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<ResponseEntity<UserEntity>?> login({required String email, required String password}) async {
    final bool connected = await networkInfo?.isConnected() ?? false;
    if (connected) {
    try {
    final ResponseEntity<UserEntity> response =
    await userRemote.login(email: email, password: password);
    if(response.token != null) {
      final String token = response.token ?? '';
      userLocal.saveToken(token: token);
    }
    return response;
    } on Exception {
    return null;
    } catch (_) {
    throw Error();
    }
    }
    return null;
  }

  @override
  Future<ResponseEntity<UserEntity>> userInfo() {
    // TODO: implement userInfo
    throw UnimplementedError();
  }
}