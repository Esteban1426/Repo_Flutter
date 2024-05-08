import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_appnotas/Registro.dart';
import 'package:flutter_application_appnotas/BotonAnimado.dart';
import 'package:flutter_application_appnotas/GestorNotas.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
      ),
      body: SingleChildScrollView(
        child: FormatoLogin(),
      ),
    );
  }
}

class FormatoLogin extends StatefulWidget {
  @override
  EstadoFormato createState() => EstadoFormato();
}

class EstadoFormato extends State<FormatoLogin> {
  final FirebaseAuth Autenticacion = FirebaseAuth.instance;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
  try {
    final String emailDato = email.text.trim();
    final String passwordDato = password.text;

    if (emailDato.isEmpty || passwordDato.isEmpty) {
      // Si el correo electrónico o la contraseña están vacíos, muestra un mensaje de error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Por favor, completa todos los campos."),
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
      return; // Salir del método sin intentar iniciar sesión
    }

    // Iniciar sesión con email y contraseña utilizando Firebase Authentication
    await Autenticacion.signInWithEmailAndPassword(
      email: emailDato,
      password: passwordDato,
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
            width: 400,
            height: 400,
            child: imageUrl.isNotEmpty
                ? Image(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  )
                : Placeholder(), // Placeholder when no image available
          ),
          TextField(
            controller: email,
            decoration: InputDecoration(
              labelText: 'Correo Electrónico',
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: password,
            decoration: InputDecoration(
              labelText: 'Contraseña',
            ),
            obscureText: true,
          ),
          SizedBox(height: 20),
          BotonAnimado(
            TextoBoton: 'Iniciar Sesion',
            onPressed: () {
              _signInWithEmailAndPassword(context);
            },
            contexto: context,
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
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
