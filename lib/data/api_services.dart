
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simpleapp/models/energy_data.dart';
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
      // ensure google sign in is initialisede
      await googleSignIn.initialize();

      // perform the authentication(replace signin())
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate(
        // optional hint at scopes u want
        scopeHint: ['email', 'password'],
      );
      //if(googleUser == null) throw Exception("Google sign-in cancelled");

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final response = await dio.post('/',data: {
        'Idtoken': googleAuth.idToken,
      });

      return User.fromJson(response.data['user']);
    }
    catch(error){
      throw Exception('Google login Failed: ${error.toString()}');
    }
  }

  Future<void> logout() async{
    await googleSignIn.signOut();
  }

  // Dashboard APIs
  Future<EnergyData> getEnergyData() async {
    try {
      final response = await dio.get('/dashboard/energy-data');
      return EnergyData.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch energy data: ${e.toString()}');
    }
  }

  // query api
  Future<void> submitQuery(String category, String title, String description)async{
    try{
      await dio.post('', data: {
        'category':category,
        'title': title,
        'description': description
      });
    }
    catch(error){
      throw Exception('Failed to submit query: ${error.toString()}');
    }
  }

}