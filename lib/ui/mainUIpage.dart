import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:simpleapp/blocs/authBloc/auth_bloc.dart';
import 'package:simpleapp/blocs/authBloc/auth_bloc_events.dart';
import 'package:simpleapp/blocs/authBloc/auth_bloc_states.dart';
import 'package:simpleapp/ui/dashboard/dashboard.dart';
import 'package:simpleapp/ui/query/query_page.dart';
import 'package:simpleapp/ui/settings/settings.dart';

class Mainpage extends StatefulWidget{
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<Mainpage>{
  int currentIndex = 1;
  final List<Widget> pages =[
    DashboardPage(),
    QueryPage(),
    SettingsPage()
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solar Energy App'),
        backgroundColor: Colors.green,
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return PopupMenuButton(
                  icon: CircleAvatar(
                    child: Text(state.user.name[0].toUpperCase()),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: Text(state.user.name),
                        subtitle: Text(state.user.email),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Logout'),
                        onTap: () {
                          Navigator.pop(context);
                          context.read<AuthBloc>().add(LogoutRequested());
                        },
                      ),
                    ),
                  ],
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: GNav(
              rippleColor: Colors.green.shade300,
              hoverColor: Colors.green.shade100,
              gap: 8,
              activeColor: Colors.green,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.green.shade100,
              color: Colors.black,
              tabs: [
                GButton(icon: Icons.dashboard, text: 'Dashboard'),
                GButton(icon: Icons.help_outline, text: 'Query'),
                GButton(icon: Icons.settings, text: 'Settings'),
              ],
              selectedIndex: currentIndex,
              onTabChange: (index) => setState(() => currentIndex = index),
            ),
          ),
        ),
      ),
    );
  }
}