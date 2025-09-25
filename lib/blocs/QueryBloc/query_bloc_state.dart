import 'package:equatable/equatable.dart';
import 'package:simpleapp/models/query.dart';

abstract class QueryBlocState extends Equatable{
  @override
  List<Object> get props => [];
}

class QueryInitial extends QueryBlocState {}

class QuerySubmitting extends QueryBlocState {}

class QuerySubmitted extends QueryBlocState {}

class QueryLoading extends QueryBlocState{}

class QueryLoaded extends QueryBlocState{
  final List<Query> queries;
  QueryLoaded(this.queries);
  @override
  List<Object> get props => [queries];
}

class QueryError extends QueryBlocState {
  final String message;
  QueryError(this.message);

  @override
  List<Object> get props => [message];
}


