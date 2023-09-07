part of 'gps_bloc.dart';

sealed class GpsEvent extends Equatable {
  const GpsEvent();

  @override
  List<Object> get props => [];
}

class GpsYPermisoEevento extends GpsEvent {
  final bool gpsActivo;
  final bool gpsPermiso;

  const GpsYPermisoEevento({required this.gpsActivo, required this.gpsPermiso});
}
