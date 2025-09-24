import 'package:equatable/equatable.dart';

abstract class QueryBlocEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SubmitQuery extends QueryBlocEvent {
  final String category;
  final String title;
  final String description;
  
  SubmitQuery(this.category, this.title, this.description);
  @override
  List<Object> get props => [category, title, description];
}