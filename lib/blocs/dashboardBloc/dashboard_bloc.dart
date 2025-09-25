import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpleapp/blocs/dashboardBloc/dashboard_bloc_event.dart';
import 'package:simpleapp/blocs/dashboardBloc/dashboard_bloc_state.dart';
import 'package:simpleapp/data/api_services.dart';
import 'package:simpleapp/models/energy_data.dart';

class DashboardBloc extends Bloc<DashboardBlocEvent,DashboardBlocState> {
  final ApiServices apiServices;

  DashboardBloc(this.apiServices) : super(DashboardInitial()){
    on<LoadEnergyData>(onLoadEnergyData);
    on<RefreshEnergyData>(onRefreshEnergyData);
  }

  Future<void> onLoadEnergyData(LoadEnergyData event, Emitter<DashboardBlocState> emit)async{
    emit(DashboardLoading());
    try{
      final energyDataMap = await apiServices.getEnergyData();
      final energyData = EnergyData.fromJson(energyDataMap);
      emit(DashboardLoaded(energyData));
    }
    catch(error){
      emit(DashboardError(error.toString()));
    }
  }

  Future<void> onRefreshEnergyData(RefreshEnergyData event, Emitter<DashboardBlocState> emit)async{
    try{
      final energyDataMap = await apiServices.getEnergyData();
      final energyData = EnergyData.fromJson(energyDataMap);
      emit(DashboardLoaded(energyData));
    }
    catch(error){
      emit(DashboardError(error.toString()));
    }
  }
}