import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_appnotas/Registro.dart';
import 'package:flutter_application_appnotas/GestorNotas.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
      ),
      body: SingleChildScrollView(
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text;

      // Iniciar sesión con email y contraseña utilizando Firebase Authentication
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Si el inicio de sesión es exitoso, muestra una alerta y navega a la siguiente pantalla
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Inicio de Sesión Exitoso"),
            content: Text("¡Bienvenido! Has iniciado sesión correctamente."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => GestorNotas()),
                  );
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Si ocurre un error durante el inicio de sesión, muestra un mensaje de error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error al Iniciar Sesión"),
            content: Text("Hubo un error al iniciar sesión. Por favor, inténtalo de nuevo."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  late String imageUrl;
  final storage = FirebaseStorage.instance;
  @override
  void initState() {
    super.initState();
    // Set the initial value of imageUrl to an empty string
    imageUrl = '';
    //Retrieve the image from Firebase Storage
    getImageUrl();
  }

  Future<void> getImageUrl() async {
    // Get the reference to the image file in Firebase Storage
    final ref = storage.ref().child('logo.jpg');
    // Get the imageUrl to download URL
    try {
      final url = await ref.getDownloadURL();
      print("URL de descarga obtenida: $url"); // Print for debugging
      setState(() {
        imageUrl = url;
      });
    } catch (e) {
      print("Error al obtener la URL de descarga: $e"); // Print for debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: imageUrl.isNotEmpty
                ? Image(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  )
                : Placeholder(), // Placeholder when no image available
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Correo Electrónico',
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Contraseña',
            ),
            obscureText: true,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _signInWithEmailAndPassword(context),
            child: Text('Iniciar Sesión'),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Registro()),
              );
            },
            child: Text('¿No tienes una cuenta? Regístrate'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
