import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
final getIt = GetIt.instance;

void main() async{
  runApp(const MyApp());
}

// void setupDependencies() {
//   getIt.registerSingleton<ApiService>(ApiService(Dio()));
//   getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<ApiService>()));
//   getIt.registerFactory<DashboardBloc>(() => DashboardBloc(getIt<ApiService>()));
//   getIt.registerFactory<QueryBloc>(() => QueryBloc(getIt<ApiService>()));
// }
class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    MaterialApp(
      title: "Solar Energy App",
      theme: ThemeData(primarySwatch: Colors.green),
      home: MainPage(),
    );
  }
}



