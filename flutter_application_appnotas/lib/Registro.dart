import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_appnotas/Login.dart';

class Registro extends StatefulWidget {
  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final _auth = FirebaseAuth.instance;
  final _database =
      FirebaseDatabase(databaseURL: 'https://proyecto-appnotasflutter-default-rtdb.firebaseio.com/')
          .ref();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nombreController = TextEditingController();
  TextEditingController _CarreraController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _registro() async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (newUser != null) {
        await _database.child('usuarios').child(newUser.user!.uid).set({
          'nombre': _nombreController.text,
          'carrera': _CarreraController.text,
          'email': _emailController.text,
          'telefono': _telefonoController.text,
        });

        // Registro exitoso, muestra una alerta
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
      // Error en el registro, muestra una alerta
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
    final ref = storage.ref().child('usuario.jpg');
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
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
              SizedBox(height: 20.0),
              TextFormField(
                controller: _nombreController,
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
                controller: _CarreraController,
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
                controller: _emailController,
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
                controller: _telefonoController,
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
                controller: _passwordController,
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
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  hintText: 'Confirma Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _registro();
                  }
                },
                child: Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
