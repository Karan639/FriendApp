import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleapp/blocs/QueryBloc/query_bloc_event.dart';
import 'package:simpleapp/blocs/QueryBloc/query_bloc_state.dart';
import 'package:simpleapp/data/api_services.dart';

class QueryBloc extends Bloc<QueryBlocEvent, QueryBlocState> {
  final ApiServices _apiService;

  QueryBloc(this._apiService) : super(QueryInitial()) {
    on<SubmitQuery>(_onSubmitQuery);
  }

  Future<void> _onSubmitQuery(SubmitQuery event, Emitter<QueryBlocState> emit) async {
    emit(QuerySubmitting());
    try {
      await _apiService.submitQuery(event.category, event.title, event.description);
      emit(QuerySubmitted());
      emit(QueryInitial()); // Reset to initial state
    } catch (e) {
      emit(QueryError(e.toString()));
    }
  }
}