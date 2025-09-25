import 'package:equatable/equatable.dart';

abstract class QueryBlocEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SubmitQuery extends QueryBlocEvent {
  final String subject;
  final String description;
  
  SubmitQuery(this.subject, this.description);
  @override
  List<Object> get props => [subject, description];
}

class LoadQueries extends QueryBlocEvent {
  final String status;
  LoadQueries({this.status = 'OPEN'});
  @override
  List<Object> get props => [status];
}