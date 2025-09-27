import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleapp/blocs/authBloc/auth_bloc.dart';
import 'package:simpleapp/blocs/authBloc/auth_bloc_events.dart';
import 'package:simpleapp/blocs/authBloc/auth_bloc_states.dart';
import 'package:simpleapp/blocs/dashboardBloc/dashboard_bloc.dart';
import 'package:simpleapp/blocs/dashboardBloc/dashboard_bloc_event.dart';
import 'package:simpleapp/ui/settings/components/privacy_policy.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            // SizedBox(height: 24),
            
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
                            child: Text(state.user.username.toUpperCase()),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(state.user.username, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                //Text(state.user.email, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
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
              _buildSettingsTile('Notifications', 'Manage notification preferences', Icons.notifications, () => 
              AppSettings.openAppSettings(type: AppSettingsType.notification)
              ),
              _buildSettingsTile('Data Refresh', 'Auto-refresh dashboard data', Icons.refresh, () => 
                  context.read<DashboardBloc>().add(LoadEnergyData())),
              _buildSettingsTile('Theme', 'Choose app theme', Icons.palette, () => _showComingSoon(context)),
              _buildSettingsTile('Logout', 'Logout user from App', Icons.logout, () => 
                context.read<AuthBloc>().add(LogoutRequested()))
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
              _buildSettingsTile('Help & Support', 'Get help and support', Icons.help, () => _openEmailApp(context)),
              _buildSettingsTile('About', 'App version and info', Icons.info, () => _showAboutDialog(context)),
              _buildSettingsTile('Privacy Policy', 'View privacy policy', Icons.privacy_tip, () => 
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()))),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Padding(
      padding: EdgeInsets.only( bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
          SizedBox(height: 12),
          Card(child: Column(children: children)),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600),),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('This feature is coming soon!'), backgroundColor: Colors.green),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Oscillation Energy LLP',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(Icons.wb_sunny, size: 50, color: Colors.green),
      children: [Text('A comprehensive solar energy monitoring and management application.')],
    );
  }

  Future<void> _openEmailApp(BuildContext context)async{
    final Uri gmailUri = Uri.parse(
    "mailto:support@myapp.com?subject=Help%20&%20Support&body=Hello,%20I%20need%20help%20with...",
  );

  const String gmailPackage = "com.google.android.gm";

    if (await canLaunchUrl(gmailUri)) {
      await launchUrl(
        gmailUri,
        mode: LaunchMode.externalApplication,
        webViewConfiguration: const WebViewConfiguration(headers: {
          "android.intent.extra.PACKAGE_NAME": gmailPackage,
        }),
      );
    }else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open email app'), backgroundColor: Colors.green)
      );
      debugPrint("Could not open email app");
    }
  }
}