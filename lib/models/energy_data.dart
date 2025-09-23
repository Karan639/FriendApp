import 'package:equatable/equatable.dart';

class EnergyData extends Equatable {
  final double dailyEnergyGeneration;
  final String sunriseTime;
  final String sunsetTime;
  final double dailyEnergySavings;
  final double powerGenerated;
  final double earnings;

  const EnergyData({
    required this.dailyEnergyGeneration,
    required this.sunriseTime,
    required this.sunsetTime,
    required this.dailyEnergySavings,
    required this.powerGenerated,
    required this.earnings,
  });

  factory EnergyData.fromJson(Map<String, dynamic> json) {
    return EnergyData(
      dailyEnergyGeneration:
          (json['daily_energy_generation'] ?? 0.0).toDouble(),
      sunriseTime: json['sunrise_time'] ?? '06:00',
      sunsetTime: json['sunset_time'] ?? '18:00',
      dailyEnergySavings: (json['daily_energy_savings'] ?? 0.0).toDouble(),
      powerGenerated: (json['power_generated'] ?? 0.0).toDouble(),
      earnings: (json['earnings'] ?? 0.0).toDouble(),
    );
  }

  @override
  List<Object> get props => [
        dailyEnergyGeneration,
        sunriseTime,
        sunsetTime,
        dailyEnergySavings,
        powerGenerated,
        earnings
      ];
}
