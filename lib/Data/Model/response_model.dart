import 'package:blackhole/Domain/domain_layer.dart';

class ResponseModel<T> extends ResponseEntity<T> {
  final bool status;
  final String message;
  final int? total;
  final String? token;
  final T? result;

  const ResponseModel({
    required this.status,
    required this.message,
    this.result,
    this.total,
    this.token,}) : super(status: status, message: message, result: result, token: token, total: total);

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel<T>(
      status: json['status'] as bool ?? false,
      message: json['message'] as String,
      token: json['token'] as String,
      result: _dataFromJson(json),
      total: json['total'] as int,);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'status': this.status,
    'message': this.message,
    'token': this.token,
    'result': this.result,
    'total': this.total,
  };

  static T? _dataFromJson<T>(Map<String, dynamic> json) {
    return json['result'] == null ? null : json['result'] as T;
  }
}