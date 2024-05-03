import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_appnotas/Login.dart';
import 'package:flutter_application_appnotas/BotonAnimado.dart';

class Registro extends StatefulWidget {
  @override
  EstadoRegistro createState() => EstadoRegistro();
}

class EstadoRegistro extends State<Registro> {
  final Autenticacion = FirebaseAuth.instance;
  final BaseDatos = FirebaseDatabase(databaseURL: 'https://proyecto-appnotasflutter-default-rtdb.firebaseio.com/').ref();
  final _Key = GlobalKey<FormState>();

  TextEditingController nombre = TextEditingController();
  TextEditingController carrera = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController telefono = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmarP = TextEditingController();

  Future<void> _registro() async {
    try {
      final NuevoUser = await Autenticacion.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      if (NuevoUser != null) {
        await BaseDatos.child('usuarios').child(NuevoUser.user!.uid).set({
          'nombre': nombre.text,
          'carrera': carrera.text,
          'email': email.text,
          'telefono': telefono.text,
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Registro exitoso"),
              content: Text("Usuario registrado correctamente."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error de registro"),
            content: Text("Hubo un error al registrar el usuario: $e"),
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

  late String imagenUrl;
  final storage = FirebaseStorage.instance;
  @override
  void initState() {
    super.initState();
    imagenUrl = '';
    getImageUrl();
  }

  Future<void> getImageUrl() async {
    final ref = storage.ref().child('usuario.jpg');
    try {
      final url = await ref.getDownloadURL();
      print("URL de descarga obtenida: $url");
      setState(() {
        imagenUrl = url;
      });
    } catch (e) {
      print("Error al obtener la URL de descarga: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _Key,
          child: Column(
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: imagenUrl.isNotEmpty
                    ? Image(
                        image: NetworkImage(imagenUrl),
                        fit: BoxFit.cover,
                      )
                    : Placeholder(),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: nombre,
                decoration: InputDecoration(
                  hintText: 'Nombre',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: carrera,
                decoration: InputDecoration(
                  hintText: 'Carrera',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu Carrera';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  hintText: 'Correo electrónico',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu correo electrónico';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: telefono,
                decoration: InputDecoration(
                  hintText: 'Telefono',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu número de teléfono';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: password,
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu contraseña';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: confirmarP,
                decoration: InputDecoration(
                  hintText: 'Confirma Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value != password.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              BotonAnimado(
                TextoBoton: 'REGISTRAR',
                onPressed: () {
                  if (_Key.currentState!.validate()) {
                    _registro();
                  }
                },
                contexto: context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
