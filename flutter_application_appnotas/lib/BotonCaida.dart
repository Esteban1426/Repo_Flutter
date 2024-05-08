import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; 

class BotonCaida extends StatefulWidget {
  final String TextoBoton;
  final VoidCallback onPressed;
  final BuildContext contexto;

  BotonCaida({required this.TextoBoton, required this.onPressed, required this.contexto});

  @override
  EstadoBotonAnimacion createState() => EstadoBotonAnimacion();
}

class EstadoBotonAnimacion extends State<BotonCaida> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return BounceInDown( 
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
            BounceInDown( 
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