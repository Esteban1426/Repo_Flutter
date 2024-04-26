import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Notas Uniagustiniana'),
        ),
        body: Container(
          decoration: BoxDecoration( 
            color: Colors.blue, 
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50.0), 
                Text(
                  'Bienvenidos Estudiantes',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, 
                  ),
                ),
                SizedBox(height: 20.0),
                AnimatedButton(), 
              ],
            ),
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

class _AnimatedButtonState extends State
 {
  bool _isPressed = false; 

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isPressed = !_isPressed; 
        });
        
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (_isPressed) {
            return Colors.white; 
          }
          return Colors.blue; 
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
          'Inicio',
          style: TextStyle(
            fontSize: 18.0,
            color: _isPressed ? Colors.blue : Colors.white, 
          ),
        ),
      ),
    );
  }
}