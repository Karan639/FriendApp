import 'package:equatable/equatable.dart';

abstract class QueryBlocState extends Equatable{
  @override
  List<Object> get props => [];
}

class QueryInitial extends QueryBlocState {}

class QuerySubmitting extends QueryBlocState {}

class QuerySubmitted extends QueryBlocState {}

class QueryError extends QueryBlocState {
  final String message;
  QueryError(this.message);

  @override
  List<Object> get props => [message];
}


