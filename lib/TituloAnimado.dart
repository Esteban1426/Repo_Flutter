import 'package:flutter/material.dart';


class TituloAnimado extends StatefulWidget {
  @override
  TituloAnimadoEstado createState() => TituloAnimadoEstado();
}

class TituloAnimadoEstado extends State<TituloAnimado>
    with SingleTickerProviderStateMixin {
  late AnimationController Controlador;

  @override
  void initState() {
    super.initState();
    Controlador = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    Controlador.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: AnimatedBuilder(
        animation: Controlador,
        builder: (BuildContext context, Widget? child) {
          return Center(
            child: Text(
              'Bienvenidos Estudiantes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 60.0,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(Controlador.value),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    Controlador.dispose();
    super.dispose();
  }
}