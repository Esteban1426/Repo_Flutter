import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_appnotas/BotonAnimado.dart';
import 'package:flutter_application_appnotas/TituloAnimado.dart';
import 'package:flutter_application_appnotas/Login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: ImagenesPricipal(),
  ));
}

class ImagenesPricipal extends StatefulWidget {
  const ImagenesPricipal({Key? key});

  @override
  State<ImagenesPricipal> createState() => WidgetImagenes();
}

class WidgetImagenes extends State<ImagenesPricipal> {
  late String imageUrl;
  final storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    imageUrl = '';
    getImageUrl();
  }

  Future<void> getImageUrl() async {
    final ref = storage.ref().child('logo.jpg');
    try {
      final url = await ref.getDownloadURL();
      print("URL de descarga obtenida: $url");
      setState(() {
        imageUrl = url;
      });
    } catch (e) {
      print("Error al obtener la URL de descarga: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF5D7CEA),
        appBar: AppBar(
          title: Text('Notas Uniagustiniana'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50.0),
              TituloAnimado(),
              /* Text(
                '¡Bienvenido estudiante!',
                style: TextStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ), */
              SizedBox(
                height: 400.0,
                child: imageUrl.isNotEmpty
                    ? Image(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : Placeholder(),
              ),
              SizedBox(height: 20.0),
                BotonAnimado(
                TextoBoton: 'Iniciar',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
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