part of 'gps_bloc.dart';

class GpsState extends Equatable {
  final bool gpsActivo;
  final bool gpsPermiso;

  bool get isAllGranted => gpsActivo && gpsPermiso;

  //constructor
  const GpsState({required this.gpsActivo, required this.gpsPermiso});

  GpsState copyWith({
    bool? gpsActivo,
    bool? gpsPermiso,
  }) =>
      GpsState(
          gpsActivo: gpsActivo ?? this.gpsActivo,
          gpsPermiso: gpsPermiso ?? this.gpsPermiso);

  @override
  List<Object> get props => [gpsActivo, gpsPermiso];

  @override
  String toString() => '{GpsAcitvo $gpsActivo, Permiso de acceso $gpsPermiso}';
}
