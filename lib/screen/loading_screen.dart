import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_flutter/blocs/blocs.dart';
import 'package:gps_flutter/screen/gps_access_screen.dart';
import 'package:gps_flutter/screen/login_screen.dart';
import 'package:gps_flutter/screen/map_screen.dart';
import 'package:gps_flutter/ui/home/home_page.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GpsBloc, GpsState>(builder: (contex, state) {
        return state.isAllGranted ? const LoginScreen() : const GpsAccessScreen();
      })
      ,
    );
  }
}
