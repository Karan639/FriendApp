import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:simpleapp/blocs/authBloc/auth_bloc.dart';
import 'package:simpleapp/blocs/authBloc/auth_bloc_events.dart';
import 'package:simpleapp/blocs/authBloc/auth_bloc_states.dart';
import 'package:simpleapp/ui/dashboard/dashboard.dart';
import 'package:simpleapp/ui/query/query_page.dart';
import 'package:simpleapp/ui/settings/settings.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0; // Start with Dashboard (index 0)
  
  final List<Widget> pages = [
    DashboardPage(),
    QueryPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solar Energy App'),
        backgroundColor: Colors.orange, // Changed to orange to match theme
        foregroundColor: Colors.white,
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return PopupMenuButton(
                  icon: CircleAvatar(
                    backgroundColor: Colors.orange.shade100,
                    child: Text(
                      state.user.username[0].toUpperCase(), // Fixed: using username
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: Text(state.user.username), // Fixed: using username
                        subtitle: Text(state.user.email), // This now works with getter
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.logout, color: Colors.red),
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
      body: IndexedStack( // Better performance than switching widgets
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20, 
              color: Colors.black.withOpacity(.1),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: GNav(
              rippleColor: Colors.orange.shade300,
              hoverColor: Colors.orange.shade100,
              gap: 8,
              activeColor: Colors.orange,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.orange.shade100,
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