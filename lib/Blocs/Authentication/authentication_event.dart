import 'package:blackhole/Domain/domain_layer.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class AppStarted extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class LoggedIn extends AuthenticationEvent {
  final String token;
  final UserEntity? user;

  const LoggedIn({required this.token, this.user});

  @override
  List<Object?> get props => [token, user];

  @override
  String toString() => 'LoggedIn { token: $token }';
}

class LoggedOut extends AuthenticationEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'LoggedOut';
}
