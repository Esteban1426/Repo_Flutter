import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa el paquete Firestore

class GestorNotas extends StatefulWidget {
  @override
  estadoGestor createState() => estadoGestor();
}

class estadoGestor extends State<GestorNotas> {
  TextEditingController nota1 = TextEditingController();
  TextEditingController nota2 = TextEditingController();
  TextEditingController nota3 = TextEditingController();
  TextEditingController nota4 = TextEditingController();
  TextEditingController nota5 = TextEditingController();

  double calcularPromedio() {
    List<TextEditingController> controladores = [nota1, nota2, nota3, nota4, nota5];
    List<double> notas = [];
    
    for (TextEditingController controlador in controladores) {
      if (controlador.text.isNotEmpty) {
        notas.add(double.parse(controlador.text));
      }
    }
    
    if (notas.length < 2) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Debe ingresar al menos 2 notas."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cerrar"),
              ),
            ],
          );
        },
      );
    } else {
      double promedio = notas.reduce((value, element) => value + element) / notas.length;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Promedio de notas"),
            content: Text("El promedio es: $promedio"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cerrar"),
              ),
            ],
          );
        },
      );

      guardarNotasFirestore(notas);
    }
    return 0.0;
  }

  Future<void> guardarNotasFirestore(List<double> notas) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference notasRef = firestore.collection('Datos');
      await notasRef.add({
        'nota1': notas.length > 0 ? notas[0] : null,
        'nota2': notas.length > 1 ? notas[1] : null,
        'nota3': notas.length > 2 ? notas[2] : null,
        'nota4': notas.length > 3 ? notas[3] : null,
        'nota5': notas.length > 4 ? notas[4] : null
      });

      print('Notas guardadas en Firestore correctamente.');
    } catch (e) {
      print('Error al guardar las notas en Firestore: $e');
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
    final ref = storage.ref().child('calculadora.jpg');
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
        title: Text('Gestor Notas'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 250,
                height: 250,
                child: imagenUrl.isNotEmpty
                    ? Image(
                        image: NetworkImage(imagenUrl),
                        fit: BoxFit.cover,
                      )
                    : Placeholder(),
              ),
              SizedBox(height: 60.0),
                Text(
                  'INGRESA TUS NOTAS',
                  style: TextStyle(fontSize: 24.0),
                ),
              SizedBox(height: 40.0),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: nota1,
                      decoration: InputDecoration(
                        hintText: 'Agrega nota 1',
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: nota2,
                      decoration: InputDecoration(
                        hintText: 'Agrega nota 2',
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: nota3,
                      decoration: InputDecoration(
                        hintText: 'Agrega nota 3',
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: nota4,
                      decoration: InputDecoration(
                        hintText: 'Agrega nota 4',
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: nota5,
                      decoration: InputDecoration(
                        hintText: 'Agrega nota 5',
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: calcularPromedio,
                      child: Text('Calcular Promedio'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
