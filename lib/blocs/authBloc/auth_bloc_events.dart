import 'package:equatable/equatable.dart';

abstract class AuthBlocEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckAuthStatus extends AuthBlocEvents {} // New event for checking stored auth


class LoginWithCredentials extends AuthBlocEvents {
  final String username;
  final String password;
  LoginWithCredentials(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

class LoginWithGoogle extends AuthBlocEvents {}

class LogoutRequested extends AuthBlocEvents {}
