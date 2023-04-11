import '../domain_layer.dart';

abstract class UserRepository {
  Future<ResponseEntity<UserEntity>?> login(
      {required String email, required String password,});

  Future<ResponseEntity<UserEntity>> userInfo();

  Future<bool> hasToken();
}
