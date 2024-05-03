import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_appnotas/BotonAnimado.dart';

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
    List<TextEditingController> Controladores = [
      nota1,
      nota2,
      nota3,
      nota4,
      nota5,
    ];

    List<double> notas = [];

    for (TextEditingController Controlador in Controladores) {
      if (Controlador.text.isNotEmpty) {
        notas.add(double.parse(Controlador.text));
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
      return 0.0;
    }

    double sumatoria = notas.reduce((value, element) => value + element);
    return sumatoria / notas.length;
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
                width: 200,
                height: 200,
                child: imagenUrl.isNotEmpty
                    ? Image(
                        image: NetworkImage(imagenUrl),
                        fit: BoxFit.cover,
                      )
                    : Placeholder(), // Cambiado a Placeholder para evitar error de carga
              ),
              Text(
                'INGRESA TUS NOTAS',
                style: TextStyle(fontSize: 24.0),
              ),
              SizedBox(height: 20.0),
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
                    BotonAnimado(
                      TextoBoton: 'Calcular Promedio',
                      onPressed: () {
                        double promedio = calcularPromedio();
                        if (promedio == 0.0) {
                          // Muestra una alerta si todas las notas son 0.0
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Error"),
                                content: Text("No se necesita calcular el promedio si todas las notas son 0.0."),
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
                        } else if (promedio != 0.0) {
                          // Muestra el promedio si es diferente de 0.0
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
                        }
                      },
                      contexto: context,
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
