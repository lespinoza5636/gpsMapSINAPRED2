import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_flutter/blocs/blocs.dart';

class GpsAccessScreen extends StatelessWidget {
  const GpsAccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<GpsBloc, GpsState>(builder: (context, state) {
          return !state.gpsActivo
              ? const _EnableGpsMessage()
              : const _AccessButton();
        }),
        //_AccessButton()
      ),
    );
  }
}

//pedir acceso GPS
class _AccessButton extends StatelessWidget {
  const _AccessButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Es necesario el acceso al GPS',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
        ),
        MaterialButton(
          child: const Text(
            'Solicitar acceso',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.black,
          shape: const StadiumBorder(),
          elevation: 0,
          splashColor: Colors.transparent,
          onPressed: () {
            final gpsBloc = BlocProvider.of<GpsBloc>(context);
            gpsBloc.askGpsAccess();
          },
        )
      ],
    );
  }
}

//Pedir que active el GPS
class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Debe habilitar el GPS',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
        ),
        ElevatedButton(onPressed: (){
          final controller = context.read<GpsBloc>();
          controller.turnOnGPS();
        },
        child: const Text("Encender el GPS"))
      ],
    );
  }
}