import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; 

class Zoom extends StatefulWidget {
  final String TextoBoton;
  final VoidCallback onPressed;
  final BuildContext contexto;

  Zoom({required this.TextoBoton, required this.onPressed, required this.contexto});

  @override
  EstadoBotonAnimacion createState() => EstadoBotonAnimacion();
}

class EstadoBotonAnimacion extends State<Zoom> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return ZoomIn( 
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _isPressed = !_isPressed;
          });
          widget.onPressed();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (_isPressed) {
              return Colors.white;
            }
            return Color.fromARGB(255, 255, 38, 0);
          }),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10), 
            ZoomIn( 
              child: Text(
                widget.TextoBoton,
                style: TextStyle(
                  fontSize: 18.0,
                  color: _isPressed ? Color.fromARGB(255, 255, 0, 0) : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}