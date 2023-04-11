import 'package:blackhole/Domain/domain_layer.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends UserEntity {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'firstName')
  final String? firstName;

  @JsonKey(name: 'lastName')
  final String? lastName;

  @JsonKey(name: 'phone')
  final String phone;

  @JsonKey(name: 'avatar')
  final String? avatar;

  UserModel({
    required this.id,
    required this.email,
    required this.phone,
    this.avatar,
    this.firstName,
    this.lastName,
    }) : super(id: id, email: email, phone: phone, avatar: avatar, firstName: firstName, lastName: lastName);

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
