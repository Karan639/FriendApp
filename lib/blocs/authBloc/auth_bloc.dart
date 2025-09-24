import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleapp/blocs/authBloc/auth_bloc_events.dart';
import 'package:simpleapp/blocs/authBloc/auth_bloc_states.dart';
import 'package:simpleapp/data/api_services.dart';

class AuthBloc extends Bloc<AuthBlocEvents,AuthState> {
  final ApiServices apiServices;

  AuthBloc(this.apiServices) : super(AuthInitial()){
    on<LoginWithCredentials>(onLoginWithCredentials);
    on<LoginWithGoogle> (onLoginWithGoogle);
    on<LogoutRequested> (onLogoutRequested);
  }

  Future<void> onLoginWithCredentials(LoginWithCredentials event, Emitter<AuthState> emit)async{
    emit(AuthLoading());
    try{
      final user = await apiServices.loginWithCredentials(event.email, event.password);
      emit(AuthAuthenticated( user));
    }
    catch(error){
      emit(AuthError(error.toString()));
    }
  }

  Future<void> onLoginWithGoogle(LoginWithGoogle event, Emitter<AuthState> emit)async{
    emit(AuthLoading());
    try{
      final user = await apiServices.loginWithGoogle();
      emit(AuthAuthenticated(user));
    }
    catch(e){
      emit(AuthError(e.toString()));
    }
  }

  Future<void> onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit)async{
    emit(AuthLoading());
    try{
      await apiServices.logout();
      emit(AuthInitial());
    }
    catch(e){
      emit(AuthError(e.toString()));
    }
  }
}