import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String username;
  final String token;
  final int expiration;

  const User(
    {required this.id,
    required this.username,
    required this.token,
    required this.expiration}
  );

  // create from stored JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'] ?? 0,
        username: json['username'],
        token: json['token'],
        expiration: json['expiration']);
  }

  factory User.fromLoginResponse(Map<String,dynamic> json, String username){
    return User(id: 0, // will be set when we get customer data
    username: username, 
    token: json['token'],
    expiration: int.parse(json['expiration']));
  }

  // check if token is still valid
  bool get isTokenValid{
    final now = DateTime.now().millisecondsSinceEpoch;
    final tokenExpiry = DateTime.now().millisecondsSinceEpoch + expiration;
    return now < tokenExpiry;
  }

  // convert to JSON for storage
  Map<String, dynamic> toJSON(){
    return {
      'id': id,
      'username': username,
      'token': token,
      'expiration': expiration,
      'loginTime': DateTime.now().millisecondsSinceEpoch
    };
  }

  // check if stored token is still valid
  static bool isStoredTokenValid(Map<String, dynamic> json){
    final loginTime = json['loginTime'] ?? 0;
    final expiration = json['expiration'] ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - loginTime) < expiration;
  }

  @override
  List<Object?> get props => [id, username, token, expiration];
}
