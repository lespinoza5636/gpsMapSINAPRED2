import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_flutter/screen/screens.dart';
import 'package:gps_flutter/blocs/blocs.dart';


void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GpsBloc())
      ],
      child: const MappsApp(),
    )
    );
}

class MappsApp extends StatelessWidget {
  const MappsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MapsApp',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: const LoadingScreen(),
      ),
    );
  }
}
