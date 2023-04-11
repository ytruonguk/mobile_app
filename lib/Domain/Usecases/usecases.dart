import 'package:equatable/equatable.dart';

export 'user_usecase.dart';

abstract class UseCase<Type, Params> {
  Future<Type?> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

class PagingParams extends NoParams {
  final int page;
  final int limit;

  PagingParams({required this.page, required this.limit}) : super();

  @override
  List<Object> get props => [page, limit];
}

class DetailParams extends NoParams {
  final int id;

  DetailParams({required this.id}) : super();

  @override
  List<Object> get props => [id, ...super.props];
}
