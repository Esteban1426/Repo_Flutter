import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class GestorNotas extends StatefulWidget {
  @override
  _GestorNotasState createState() => _GestorNotasState();
}

class _GestorNotasState extends State<GestorNotas> {
  TextEditingController nota1Controller = TextEditingController();
  TextEditingController nota2Controller = TextEditingController();
  TextEditingController nota3Controller = TextEditingController();
  TextEditingController nota4Controller = TextEditingController();
  TextEditingController nota5Controller = TextEditingController();

  double calcularPromedio() {
    List<TextEditingController> controllers = [
      nota1Controller,
      nota2Controller,
      nota3Controller,
      nota4Controller,
      nota5Controller,
    ];

    List<double> notas = [];

    for (TextEditingController controller in controllers) {
      if (controller.text.isNotEmpty) {
        notas.add(double.parse(controller.text));
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
      return 0.0; // Devolver 0.0 para indicar que el cálculo del promedio falló
    }

    double sumatoria = notas.reduce((value, element) => value + element);
    return sumatoria / notas.length;
  }

  late String imageUrl;
  final storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    imageUrl = '';
    getImageUrl();
  }

  Future<void> getImageUrl() async {
    final ref = storage.ref().child('calculadora.jpg');
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
                child: imageUrl.isNotEmpty
                    ? Image(
                        image: NetworkImage(imageUrl),
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
                      controller: nota1Controller,
                      decoration: InputDecoration(
                        hintText: 'Agrega nota 1',
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: nota2Controller,
                      decoration: InputDecoration(
                        hintText: 'Agrega nota 2',
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: nota3Controller,
                      decoration: InputDecoration(
                        hintText: 'Agrega nota 3',
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: nota4Controller,
                      decoration: InputDecoration(
                        hintText: 'Agrega nota 4',
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: nota5Controller,
                      decoration: InputDecoration(
                        hintText: 'Agrega nota 5',
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        double promedio = calcularPromedio();
                        if (promedio != 0.0) {
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
