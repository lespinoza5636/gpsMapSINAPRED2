import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_flutter/ui/home/home_controller.dart';
import 'package:provider/provider.dart';

class MapView extends StatelessWidget {
  const MapView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
        builder: (_, controller, gpsMessageWidget) {

     if(!controller.gpsEnable){
       return gpsMessageWidget!;
     } 

     final initialCameraPosition = CameraPosition(
     target: LatLng(
      controller.initialPosition!.latitude, 
     controller.initialPosition!.longitude)
     , zoom: 19
       
     );


        return SafeArea(
        child: Column(
     children: [
       Expanded(
         child: 
         GoogleMap(
           markers:  controller.markers,
           polylines: controller.polylines,
           polygons: controller.polygons,
           onMapCreated: controller.onMapCreated,
           initialCameraPosition: initialCameraPosition,
         myLocationButtonEnabled: true,
         myLocationEnabled: true,
         onTap: controller.onTap,
         )
       ),
     ],
        ),
        
      );
        },
        child: Center(
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             const Text(
               "Cuando use la App habilite el GPS",
               textAlign: TextAlign.center,
             ),
             const SizedBox(height: 10,),
             ElevatedButton(
               onPressed:(){
                 final controller = context.read<HomeController>();
                 controller.turnOnGPS();
               }, 
               child: const Text("Encender el GPS"))
           ],
         ),
       ),
      );
  }
}