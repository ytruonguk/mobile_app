import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class UserEntity extends Equatable {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? avatar;
  final String? phone;

  UserEntity(
      {this.firstName,
      this.lastName,
      this.email,
      this.avatar,
      required this.phone,
      required this.id});

  @override
  List<Object?> get props => [id, firstName, lastName, email, avatar, phone];
}

class UserFailure extends UserEntity {
  UserFailure(
      {super.firstName,
      super.lastName,
      super.email,
      super.avatar,
      required super.phone,
      required super.id});

  @override
  List<Object?> get props => [];
}
