import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleapp/blocs/QueryBloc/query_bloc_event.dart';
import 'package:simpleapp/blocs/QueryBloc/query_bloc_state.dart';
import 'package:simpleapp/data/api_services.dart';

class QueryBloc extends Bloc<QueryBlocEvent, QueryBlocState> {
  final ApiServices _apiService;

  QueryBloc(this._apiService) : super(QueryInitial()) {
    on<SubmitQuery>(_onSubmitQuery);
    on<LoadQueries>(_onLoadQueries);
  }

  Future<void> _onSubmitQuery(SubmitQuery event, Emitter<QueryBlocState> emit) async {
    emit(QuerySubmitting());
    try {
      await _apiService.submitQuery(event.subject, event.description);
      emit(QuerySubmitted());
      emit(QueryInitial()); // Reset to initial state
    } catch (e) {
      emit(QueryError(e.toString()));
    }
  }

    Future<void> _onLoadQueries(LoadQueries event, Emitter<QueryBlocState> emit) async {
    emit(QueryLoading());
    try {
      final queries = await _apiService.getQueries(status: event.status);
      emit(QueryLoaded(queries));
    } catch (e) {
      emit(QueryError(e.toString()));
    }
  }
}