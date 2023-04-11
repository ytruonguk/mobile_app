import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  LoginButtonPressed({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];

  @override
  String toString() => 'LoginButtonPressed { username: $username, password: $password}';
}

class EmailChanged extends LoginEvent {
  final String email;

  EmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends LoginEvent {
  final String password;
  PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}
