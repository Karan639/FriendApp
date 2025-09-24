import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleapp/blocs/authBloc/auth_bloc.dart';
import 'package:simpleapp/blocs/authBloc/auth_bloc_states.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            
            // User Profile Section
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            child: Text(state.user.name[0].toUpperCase()),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(state.user.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                Text(state.user.email, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
            SizedBox(height: 24),
            
            // App Settings
            _buildSettingsSection('App Settings', [
              _buildSettingsTile('Notifications', 'Manage notification preferences', Icons.notifications, () => _showComingSoon(context)),
              _buildSettingsTile('Data Refresh', 'Auto-refresh dashboard data', Icons.refresh, () => _showComingSoon(context)),
              _buildSettingsTile('Theme', 'Choose app theme', Icons.palette, () => _showComingSoon(context)),
            ]),
            SizedBox(height: 24),
            
            // System Settings
            _buildSettingsSection('System Configuration', [
              _buildSettingsTile('Solar Panel Config', 'Configure solar panel settings', Icons.solar_power, () => _showComingSoon(context)),
              _buildSettingsTile('Energy Units', 'Set preferred energy units', Icons.straighten, () => _showComingSoon(context)),
              _buildSettingsTile('Location', 'Set installation location', Icons.location_on, () => _showComingSoon(context)),
            ]),
            SizedBox(height: 24),
            
            // Support & Info
            _buildSettingsSection('Support & Information', [
              _buildSettingsTile('Help & Support', 'Get help and support', Icons.help, () => _showComingSoon(context)),
              _buildSettingsTile('About', 'App version and info', Icons.info, () => _showAboutDialog(context)),
              _buildSettingsTile('Privacy Policy', 'View privacy policy', Icons.privacy_tip, () => _showComingSoon(context)),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
        SizedBox(height: 12),
        Card(child: Column(children: children)),
      ],
    );
  }

  Widget _buildSettingsTile(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('This feature is coming soon!'), backgroundColor: Colors.orange),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Solar Energy App',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(Icons.wb_sunny, size: 50, color: Colors.orange),
      children: [Text('A comprehensive solar energy monitoring and management application.')],
    );
  }
}