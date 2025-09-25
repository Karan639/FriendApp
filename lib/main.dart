import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simpleapp/blocs/QueryBloc/query_bloc.dart';
import 'package:simpleapp/blocs/authBloc/auth_bloc.dart';
import 'package:simpleapp/blocs/authBloc/auth_bloc_events.dart';
import 'package:simpleapp/blocs/authBloc/auth_bloc_states.dart';
import 'package:simpleapp/blocs/dashboardBloc/dashboard_bloc.dart';
import 'package:simpleapp/data/api_services.dart';
import 'package:simpleapp/data/storage_services.dart';
import 'package:simpleapp/ui/mainUIpage.dart';
import 'package:simpleapp/ui/utils/login_page.dart';
import 'package:simpleapp/ui/utils/splash_screen.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(MyApp());
}

Future<void> setupDependencies() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  
  getIt.registerSingleton<SharedPreferences>(sharedPrefs);
  getIt.registerSingleton<StorageService>(StorageService(sharedPrefs));
  getIt.registerSingleton<ApiServices>(ApiServices(Dio(), getIt<StorageService>()));
  
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<ApiServices>()));
  getIt.registerFactory<DashboardBloc>(() => DashboardBloc(getIt<ApiServices>()));
  getIt.registerFactory<QueryBloc>(() => QueryBloc(getIt<ApiServices>()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>()..add(CheckAuthStatus()),
        ),
        BlocProvider<DashboardBloc>(create: (_) => getIt<DashboardBloc>()),
        BlocProvider<QueryBloc>(create: (_) => getIt<QueryBloc>()),
      ],
      child: MaterialApp(
        title: 'Solar Energy App',
        theme: ThemeData(
          primarySwatch: Colors.green,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return SplashPage();
            } else if (state is AuthAuthenticated) {
              return Mainpage();
            } else {
              return LoginPage();
            }
          },
        ),
      ),
    );
  }
}