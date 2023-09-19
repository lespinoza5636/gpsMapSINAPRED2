import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_flutter/helpers/image_to_bytes.dart';
import 'package:gps_flutter/utils/maps_styles.dart';

class HomeController extends ChangeNotifier{

  //Mis variables
  static bool agregado = false;
  static Type accion =Type.polyne;

  final Map<MarkerId, Marker> _markers = {};
  final Map<PolylineId, Polyline> _polylines = {};
  final Map<PolygonId, Polygon> _polygons = {};

  Set<Marker> get markers => _markers.values.toSet();

  Set<Polyline> get polylines => _polylines.values.toSet();

  Set<Polygon> get polygons => _polygons.values.toSet();


  final _markersController = StreamController<String>.broadcast();
  Stream<String> get onMarkerTap => _markersController.stream;

  final _polygonController = StreamController<String>.broadcast();
  Stream<String> get onPolygonTap => _polygonController.stream;

  Position? _initialPosition;
  Position? get initialPosition => _initialPosition;
  final _homeIcon = Completer<BitmapDescriptor>();

  bool _loading = true;
  bool get loading => _loading;

  late bool _gpsEnable;
  bool get gpsEnable => _gpsEnable;

  StreamSubscription? _gpssubscription, _positionSubscription;
  String _polygonId = '0';
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
      if(_gpsEnable==true){
        _initLocationUpdates();
      }
       
    });

    _initLocationUpdates();
  }

  Future<void> _initLocationUpdates() async{
    bool initialized = false;
    await _positionSubscription?.cancel();
    _positionSubscription= Geolocator.getPositionStream().listen((position) {
      if(!initialized){
        _setInitialPosition(position);
        initialized = true;
        notifyListeners();
      }
      
    },
    onError: (e){
      print("${e.runtimeType}");
      if(e is LocationServiceDisabledException)
      {
        _gpsEnable = false;
        notifyListeners();
      }
    });
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

  void newPolygon(){
    _polygonId = DateTime.now().millisecondsSinceEpoch.toString();
  }

  void onTap(LatLng position) async{
    
    if (accion == Type.point){
      if(!agregado)
      {
        final id = _markers.length.toString();
        final markerId = MarkerId(id);

        final icon = await _homeIcon.future;

        final marker=Marker(
          markerId: markerId, 
          position: position,
          draggable: true,
          icon: icon,
          onTap: (){
            //_markersController.sink.add(id);
          }
          ); 
        _markers[markerId] = marker;
        agregado = true;
      }
    }


//#############################################################################
    if (accion == Type.polyne)
    {
      final id = _polygons.length.toString();
      final PolygonId polygonId = PolygonId(_polygonId);
      late Polygon polygon;

      if(_polygons.containsKey(polygonId)){
      final tmp = _polygons[polygonId]!;
      polygon = tmp.copyWith(
        pointsParam: [...tmp.points, position]
      );
    }
    else{
      polygon = Polygon(
        polygonId: polygonId,
        points: [position],
        strokeWidth: 1,
        fillColor: Colors.black.withOpacity(0.4),
        onTap: () {
          _polygonController.sink.add(id);
        }
      );
    }
      _polygons[polygonId] = polygon;
  }
  //##################################################################################
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _positionSubscription?.cancel();
    _gpssubscription?.cancel();
    _markersController.close();
    _polygonController.close();
    super.dispose();
  }
}

enum Type {
    point,
    polyne,
}