import 'dart:io';
import 'package:blackhole/Domain/Repositories/user_repository.dart';
import 'package:blackhole/Domain/Usecases/usecases.dart';
import 'package:blackhole/Domain/domain_layer.dart';

class ForgotParams extends NoParams {
  final String email;

  ForgotParams({required this.email}) : super();

  @override
  List<Object> get props => [email, ...super.props];
}

class LoginParams extends ForgotParams {
  final String password;

  LoginParams({required super.email, required this.password});

  @override
  List<Object> get props => [password, ...super.props];
}

class GetUser implements UseCase<ResponseEntity<UserEntity>, NoParams> {
  final UserRepository repository;
  GetUser(this.repository);

  @override
  Future<ResponseEntity<UserEntity>> call(NoParams noParams) async => repository.userInfo();
}

class CheckToken implements UseCase<bool, NoParams> {
  final UserRepository repository;
  CheckToken(this.repository);

  @override
  Future<bool> call(NoParams params) async => repository.hasToken();
}

class Login implements UseCase<ResponseEntity<UserEntity>, LoginParams> {
  final UserRepository repository;

  Login(this.repository);

  @override
  Future<ResponseEntity<UserEntity>?> call(LoginParams params) async => repository.login(email: params.email, password: params.password);
}
