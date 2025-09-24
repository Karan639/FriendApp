import 'package:equatable/equatable.dart';

abstract class DashboardBlocEvent extends Equatable {
 @override
 List<Object> get props => [];
}

class LoadEnergyData extends DashboardBlocEvent{}

class RefreshEnergyData extends DashboardBlocEvent{}

