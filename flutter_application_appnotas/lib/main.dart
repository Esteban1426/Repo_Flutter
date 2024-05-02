import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_appnotas/Login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(FirestoreImageDisplay());
}

class FirestoreImageDisplay extends StatefulWidget {
  const FirestoreImageDisplay({Key? key});

  @override
  State<FirestoreImageDisplay> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<FirestoreImageDisplay> {
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
              Text(
                '¡Bienvenido estudiante!',
                style: TextStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 300.0,
                child: imageUrl.isNotEmpty
                    ? Image(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : Placeholder(), // Placeholder cuando no hay imagen
              ),
              SizedBox(height: 20.0),
              AnimatedButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isPressed = !_isPressed;
        });
        if (_isPressed) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (_isPressed) {
            return Colors.white;
          }
          return Color.fromARGB(255, 255, 38, 0);
        }),
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.transparent,
        ),
        child: Text(
          'Iniciar',
          style: TextStyle(
            fontSize: 18.0,
            color: _isPressed ? Color.fromARGB(255, 255, 0, 0) : Colors.white,
          ),
        ),
      ),
    );
  }
}
