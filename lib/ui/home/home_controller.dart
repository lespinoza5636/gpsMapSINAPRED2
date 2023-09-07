import 'dart:async';

import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_flutter/helpers/image_to_bytes.dart';
import 'package:gps_flutter/utils/maps_styles.dart';

class HomeController extends ChangeNotifier{

  final Map<MarkerId, Marker> _markers = {};

  Set<Marker> get markers => _markers.values.toSet();
  final _markersController = StreamController<String>.broadcast();
  Stream<String> get onMarkerTap => _markersController.stream;

  Position? _initialPosition;
  CameraPosition get initialCameraPosition => CameraPosition(
    target: LatLng(_initialPosition!.latitude, 
          _initialPosition!.longitude)
          , zoom: 19
            
          );

  final _homeIcon = Completer<BitmapDescriptor>();

  bool _loading = true;
  bool get loading => _loading;

  late bool _gpsEnable;
  bool get gpsEnable => _gpsEnable;

  StreamSubscription? _gpssubscription, _positionSubscription;

  HomeController(){
    _init();
  }

  Future<void> _init() async {
    final value = await imageToBytes('https://i0.wp.com/eltallerdehector.com/wp-content/uploads/2022/06/6420b-pikachu-sentado-png.png?resize=800%2C800&ssl=1', width: 80, fromNetwork: true);
    final bitMap = BitmapDescriptor.fromBytes(value);
    _homeIcon.complete(bitMap);

    _gpsEnable = await Geolocator.isLocationServiceEnabled();

    _loading = false;
    _gpssubscription = Geolocator.getServiceStatusStream().listen((status) async {
      _gpsEnable = status == ServiceStatus.enabled;
      //await _getInitialPosition();
      notifyListeners();
    });

    await _initLocationUpdates();
    notifyListeners();
  }

  Future<void> _initLocationUpdates(){
    final completer = Completer();

    _positionSubscription= Geolocator.getPositionStream().listen((position) {
      if(!completer.isCompleted){
        _setInitialPosition(position);
        completer.complete();
      }
      
    },
    onError: (e){
      print("${e.runtimeType}");
    });

    return completer.future;
  }

  void _setInitialPosition(Position position)
  {
    if(_gpsEnable && _initialPosition == null){
      //_initialPosition = await Geolocator.getLastKnownPosition();
      _initialPosition = position;

    }
  }

  void onMapCreated(GoogleMapController controller){
    controller.setMapStyle(mapStyle);
  }

  Future<void> turnOnGPS() => Geolocator.openLocationSettings();

  void onTap(LatLng position) async{
    final id = _markers.length.toString();
    final markerId = MarkerId(id);

    final icon = await _homeIcon.future;

    final marker=Marker(
      markerId: markerId, 
      position: position,
      draggable: true,
      icon: icon,
      onTap: (){
        _markersController.sink.add(id);
      }
      ); 
    _markers[markerId] = marker;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _positionSubscription?.cancel();
    _gpssubscription?.cancel();
    _markersController.close();
    super.dispose();
  }
}