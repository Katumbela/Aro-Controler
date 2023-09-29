import 'package:flutter/material.dart';



class ControlesPage extends StatefulWidget {
  final Function enviarComando;

  ControlesPage({required this.enviarComando});

  @override
  _ControlesPageState createState() => _ControlesPageState();
}


class _ControlesPageState extends State<ControlesPage> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Controles'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                widget.enviarComando('1'); // Enviar comando para ligar
              },
              child: Text('Ligar'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                widget.enviarComando('0'); // Enviar comando para desligar
              },
              child: Text('Desligar'),
            ),
          ],
        ),
      ),
    );
  }
}
