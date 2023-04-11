import 'package:equatable/equatable.dart';

abstract class ResponseEntity<T> extends Equatable {
  final bool status;
  final String? message;
  final T? result;
  final String? token;
  final int? total;

  const ResponseEntity({
    required this.status,
    this.message,
    this.result,
    this.token,
    this.total,
  });

  @override
  List<Object?> get props => [status, message, result, total];
}
