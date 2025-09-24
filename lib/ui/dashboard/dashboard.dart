import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleapp/blocs/dashboardBloc/dashboard_bloc.dart';
import 'package:simpleapp/blocs/dashboardBloc/dashboard_bloc_event.dart';
import 'package:simpleapp/blocs/dashboardBloc/dashboard_bloc_state.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadEnergyData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<DashboardBloc>().add(RefreshEnergyData());
        },
        child: BlocBuilder<DashboardBloc, DashboardBlocState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is DashboardLoaded) {
              final data = state.energyData;
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Today\'s Energy Overview',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    
                    // Daily Energy Generation - Bold Section
                    Card(
                      elevation: 4,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(colors: [Colors.orange.shade400, Colors.orange.shade600]),
                        ),
                        child: Column(
                          children: [
                            Text('Daily Energy Generation',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            SizedBox(height: 8),
                            Text('${data.dailyEnergyGeneration.toStringAsFixed(2)} kWh',
                              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    // Other metrics
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                      children: [
                        _buildMetricCard('Sunrise Time', data.sunriseTime, Icons.wb_sunny, Colors.amber),
                        _buildMetricCard('Sunset Time', data.sunsetTime, Icons.brightness_3, Colors.indigo),
                        _buildMetricCard('Daily Savings', '\$${data.dailyEnergySavings.toStringAsFixed(2)}', Icons.savings, Colors.green),
                        _buildMetricCard('Power Generated', '${data.powerGenerated.toStringAsFixed(1)} kW', Icons.flash_on, Colors.yellow),
                        _buildMetricCard('Total Earnings', '\$${data.earnings.toStringAsFixed(2)}', Icons.monetization_on, Colors.teal),
                      ],
                    ),
                  ],
                ),
              );
            } else if (state is DashboardError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    ElevatedButton(
                      onPressed: () => context.read<DashboardBloc>().add(LoadEnergyData()),
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey), textAlign: TextAlign.center),
            SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}