import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:simpleapp/blocs/QueryBloc/query_bloc.dart';
import 'package:simpleapp/blocs/authBloc/auth_bloc.dart';
import 'package:simpleapp/blocs/authBloc/auth_bloc_states.dart';
import 'package:simpleapp/blocs/dashboardBloc/dashboard_bloc.dart';
import 'package:simpleapp/data/api_services.dart';
import 'package:simpleapp/ui/mainUIpage.dart';
import 'package:simpleapp/ui/utils/login_page.dart';
final getIt = GetIt.instance;

void main() async{
  runApp(const MyApp());
}

void setupDependencies() {
  getIt.registerSingleton<ApiServices>(ApiServices(Dio()));
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<ApiServices>()));
  getIt.registerFactory<DashboardBloc>(() => DashboardBloc(getIt<ApiServices>()));
  getIt.registerFactory<QueryBloc>(() => QueryBloc(getIt<ApiServices>()));
}

class ApiService {
}
class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
        BlocProvider<DashboardBloc>(create: (_) => getIt<DashboardBloc>()),
        BlocProvider<QueryBloc>(create: (_) => getIt<QueryBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Solar Energy App',
        theme: ThemeData(primarySwatch: Colors.green),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return Mainpage();
            }
            return LoginPage();
          },
        ),
      ),
    );
  }
}



