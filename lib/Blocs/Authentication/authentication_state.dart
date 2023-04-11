import 'package:blackhole/Domain/Entities/entities.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticateState extends Equatable {
  const AuthenticateState();
}

class AuthenticationUnauthenticated extends AuthenticateState {
  final UserEntity? user;
  const AuthenticationUnauthenticated({this.user});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'AuthenticationUnauthenticated';
}

class AuthenticationLoading extends AuthenticateState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'AuthenticationLoading';
}

class AuthenticationAuthenticated extends AuthenticateState {
  final UserEntity? user;
  const AuthenticationAuthenticated({this.user});

  @override
  List<Object?> get props => [user];

  @override
  String toString() => 'AuthenticationAuthenticated';
}

class InitialAuthenticationState extends AuthenticateState {
  @override
  List<Object> get props => [];
}