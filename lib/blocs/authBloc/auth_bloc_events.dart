import 'package:equatable/equatable.dart';

abstract class AuthBlocEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginWithCredentials extends AuthBlocEvents {
  final String email;
  final String password;
  LoginWithCredentials(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class LoginWithGoogle extends AuthBlocEvents {}

class LogoutRequested extends AuthBlocEvents {}
