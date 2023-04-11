import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'LoginLoading';
}

class LoginSuccess extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginValid extends LoginState {
  final bool isEmailValid;
  final bool isPasswordValid;

  bool get isFormValid => isEmailValid && isPasswordValid;

  const LoginValid({this.isEmailValid = false, this.isPasswordValid = false});

  LoginValid update({bool? isEmailValid, bool? isPasswordValid}) => LoginValid(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid);
  @override
  List<Object> get props => [isEmailValid, isPasswordValid];
}

class InitialLoginState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginFailure extends LoginState {
  final String message;

  const LoginFailure({required this.message});
  @override
  List<Object> get props => [message];

  @override
  String toString() => 'LoginFailure { error: $message }';
}
