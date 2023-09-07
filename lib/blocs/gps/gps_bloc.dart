import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  GpsBloc() : super(const GpsState(gpsActivo: false, gpsPermiso: false)) {
    on<GpsYPermisoEevento>((event, emit) => emit(state.copyWith(
        gpsActivo: event.gpsActivo, gpsPermiso: event.gpsPermiso)));

    _init();
  }

  get gpsServiceSuscription => null;

  Future<void> turnOnGPS() => Geolocator.openLocationSettings();
  
  Future<void> _init() async {
    final isEnabled = await _checkGpsStatus();
    final isGranted = await _isPermissionGranted();
    print('isEnable: $isEnabled, isGranted: $isGranted');

    final gpsInitStatus = await Future.wait([
      _checkGpsStatus(),
      _isPermissionGranted(),
    ]);

    add(GpsYPermisoEevento(gpsActivo: gpsInitStatus[0], gpsPermiso: gpsInitStatus[1]));
  }

  Future<bool> _isPermissionGranted() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }

  Future<bool> _checkGpsStatus() async {
    final isEnable = await Geolocator.isLocationServiceEnabled();
    Geolocator.getServiceStatusStream().listen((event) {
      final isEnabled = (event.index == 1) ? true : false;
      add(GpsYPermisoEevento(
          gpsActivo: isEnabled, gpsPermiso: state.gpsPermiso));
      //TODO: disparar eventos...
    });
    return isEnable;
  }

  Future<void> askGpsAccess() async {
    final status = await Permission.location.request();

    switch (status) {
      case PermissionStatus.granted:
        add(GpsYPermisoEevento(gpsActivo: state.gpsActivo, gpsPermiso: true));
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.provisional:
        add(GpsYPermisoEevento(gpsActivo: state.gpsActivo, gpsPermiso: false));
        openAppSettings();
    }
  }

  @override
  Future<void> close() {
    gpsServiceSuscription?.cancel();
    return super.close();
  }
}
