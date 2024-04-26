import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _AnimatedContainterAppState();
}

class _AnimatedContainterAppState extends State<MyApp> {
  double _altura = 20;
  double _anchura = 20;
  Color _color = Colors.black;
  final BorderRadiusGeometry _borderRadius = BorderRadius.circular(5);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Ejemplo flutter 1'),
        ),
        body: Center(
          child: AnimatedContainer(
            width: _altura,
            height: _anchura,
            decoration: BoxDecoration(
              color: _color,
              borderRadius: _borderRadius,
            ),
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          setState(() {
            final aleatorio = Random();
            _altura = aleatorio.nextInt(350).toDouble();
            _anchura = aleatorio.nextInt(350).toDouble();
            _color = Color.fromRGBO(
              aleatorio.nextInt(256),
              aleatorio.nextInt(256),
              aleatorio.nextInt(256),
              1,
            );
          });
        }),
      ),  
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Has presionado este boton estas veces: ',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
