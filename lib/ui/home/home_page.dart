import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_flutter/ui/home/widgets/google_maps.dart';
import 'package:gps_flutter/ui/home/home_controller.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(create: 
    (_) {
      final controller =  HomeController();
      
      controller.onMarkerTap.listen((String id) {
      final markers = controller.markers.firstWhere(
          (marker) => marker.markerId.value == id
      );
       showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Información del Marcador'),
        content: Text('ID del Marcador: $id ${markers.position.latitude} ${markers.position.longitude}'), // Puedes personalizar el contenido aquí
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
            },
            child: const Text('Contestar instrumento',),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
            },
            child: Text('Cerrar', style: TextStyle(color: Colors.red[300]) ,),
          ),
        ],
      );
    },
  );
      });

controller.onPolygonTap.listen((String id) {
      final poligons = controller.polygons.firstWhere(
          (poligon) => poligon.polygonId.value == id
      );
       showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Información del Marcador'),
        content: Text('ID del Marcador: $id ${poligons.points[0].latitude} ${poligons.points[0].longitude}'), // Puedes personalizar el contenido aquí
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
            },
            child: const Text('Contestar instrumento',),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
            },
            child: Text('Cerrar', style: TextStyle(color: Colors.red[300]) ,),
          ),
        ],
      );
    },
  );
      });
      
      return controller;
    },
    child: Scaffold(
      appBar: AppBar(actions: [
        Builder(builder: (context)=>
        IconButton(onPressed: (){
          final controller = context.read<HomeController>();
          controller.newPolygon();

        }, icon: const Icon(Icons.add),
        )
    ),
    Builder(builder: (context)=>
        IconButton(onPressed: (){
        }, icon: const Icon(Icons.map),
        )
    )]),
      body: Selector<HomeController, bool>(
        selector: (_, controller) => controller.loading,
        builder: (context, loagind, loagindWidget)
        {
          if(loagind){
            return loagindWidget!;
          }
         return const MapView();
        },
      child: const Center(
              child: CircularProgressIndicator()),
      ),
      floatingActionButton: 
         Row(
          mainAxisAlignment: MainAxisAlignment.center,
           children: [
             FloatingActionButton(
                onPressed: (){
                  HomeController.accion = Type.polyne;
                },
                child: const Icon(Icons.pinch),
              ),
              const SizedBox(width: 8,),
              FloatingActionButton(
                onPressed: (){
                  HomeController.accion = Type.point;
                },
                child: const Icon(Icons.location_on),
            ),
           ],
         ),
    ));
  }
}

