import 'package:equatable/equatable.dart';
import 'package:simpleapp/models/energy_data.dart';

abstract class DashboardBlocState extends Equatable{
  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardBlocState{}

class DashboardLoading extends DashboardBlocState{}

class DashboardLoaded extends DashboardBlocState{
  final EnergyData energyData;
  DashboardLoaded(this.energyData);

  @override
  List<Object> get props => [energyData];
}

class DashboardError extends DashboardBlocState{
  final String message;
  DashboardError(this.message);

  @override
  List<Object> get props => [message];
}