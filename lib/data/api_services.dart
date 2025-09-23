
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simpleapp/models/user.dart';

class ApiServices {
  final Dio dio;
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  ApiServices(this.dio){
    dio.options.baseUrl = "";
    dio.options.connectTimeout = Duration(seconds: 30);
  }

  // auth API's
  Future<User> loginWithCredentials(String email, String password)async{
    try{
      final response  = await dio.post('/',data: {
        'email':email,
        'password':password
      });
      return User.fromJson(response.data['user']);
    }
    catch(error){
      throw Exception('Login failed ${error.toString()}');
    }
  }

  Future<User> loginWithGoogle()async{
    try{
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    }
  }
}