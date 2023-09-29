import 'package:flutter/material.dart';
import 'package:gps_flutter/ui/home/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: usernameController, // Controlador para el nombre de usuario
                decoration: const InputDecoration(
                  labelText: 'Ingrese su nombre de usuario',
                ),
              ),
              TextFormField(
                controller: passwordController, // Controlador para la contraseña
                decoration: const InputDecoration(
                  labelText: 'Ingrese su contraseña',
                ),
                obscureText: true, // Ocultar la contraseña
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  String username = usernameController.text;
                  String password = passwordController.text;
                  bool loggedIn = getUser(username, password);

                  if (loggedIn) {
                    Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(builder: (context) => const HomePage()), // Reemplaza 'HomeScreen()' con la pantalla que desees mostrar
                                            );
                  } else { 
                    ScaffoldMessenger.of(context).showSnackBar( const
                      SnackBar(
                        content: Text('Usuario o contraseña incorrectos. Por favor, inténtelo de nuevo.'),
                      ),
                    );
                  }
                },
                child: Text('Iniciar Sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool getUser(String user, String pass) {
    if (user == "lmanuel" && pass == "1234") {
      return true;
    }
    return false;
  }
}
