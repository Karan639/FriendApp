import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleapp/blocs/authBloc/auth_bloc_events.dart';
import 'package:simpleapp/blocs/authBloc/auth_bloc_states.dart';
import 'package:simpleapp/data/api_services.dart';

class AuthBloc extends Bloc<AuthBlocEvents,AuthState> {
  final ApiServices apiServices;

  AuthBloc(this.apiServices) : super(AuthInitial()){
    on<LoginWithCredentials>(onLoginWithCredentials);
    on<CheckAuthStatus>(onCheckAuthStatus);
    on<LogoutRequested> (onLogoutRequested);
  }

    // Check if user is already logged in
  Future<void> onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final storedUser = await apiServices.getStoredUser();
      if (storedUser != null && storedUser.isTokenValid) {
        emit(AuthAuthenticated(storedUser));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }

  Future<void> onLoginWithCredentials(LoginWithCredentials event, Emitter<AuthState> emit)async{
    emit(AuthLoading());
    try{
      final user = await apiServices.loginWithCredentials(event.username, event.password);
      emit(AuthAuthenticated( user));
    }
    catch(error){
      emit(AuthError(error.toString()));
    }
  }

  // Future<void> onLoginWithGoogle(LoginWithGoogle event, Emitter<AuthState> emit)async{
  //   emit(AuthLoading());
  //   try{
  //     final user = await apiServices.loginWithGoogle();
  //     emit(AuthAuthenticated(user));
  //   }
  //   catch(e){
  //     emit(AuthError(e.toString()));
  //   }
  // }

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