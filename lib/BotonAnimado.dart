import 'package:flutter/material.dart';


class BotonAnimado extends StatefulWidget {
  final String TextoBoton;
  final VoidCallback onPressed;
  final BuildContext contexto;

  BotonAnimado({required this.TextoBoton, required this.onPressed, required this.contexto});

  @override
  EstadoBotonAnimacion createState() => EstadoBotonAnimacion();
}

class EstadoBotonAnimacion extends State<BotonAnimado> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isPressed = !_isPressed;
        });
        widget.onPressed(); // Llama a la función proporcionada al presionar el botón
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
          widget.TextoBoton,
          style: TextStyle(
            fontSize: 18.0,
            color: _isPressed ? Color.fromARGB(255, 255, 0, 0) : Colors.white,
          ),
        ),
      ),
    );
  }
}
