import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:rc_control/control_button.dart';

class CommandPage extends StatefulWidget {
  final BluetoothConnection connection;

  const CommandPage({Key? key, required this.connection}) : super(key: key);

  @override
  _CommandPageState createState() => _CommandPageState();
}

class _CommandPageState extends State<CommandPage> {
  String text = '';
  bool isSoundEnabled = true;

  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }


  Future<void> _initializeTts() async {
    await flutterTts.setLanguage("pt-BR");
    await flutterTts.setPitch(0.9);
  }


  void _sendCommand(String command) {
    String commandText;
    switch (command) {
      case 'A':
        commandText = 'Para Frente';
        break;
      case 'a':
        commandText = 'Para Tráz';
        break;
      case 'B':
        commandText = 'Para Esquerda';
        break;
      case 'b':
        commandText = 'Para Direita';
        break;
      case 'C':
        commandText = 'Parar';
        break;
      case 'Z':
        commandText = 'Giro 180 Deg';
        break;
      case 'Y':
        commandText = 'JoyStick Left';
        break;
      case 'X':
        commandText = 'JoyStick Right';
        break;
      case 'S':
        commandText = 'Emitir Som';
        break;
      case 'L':
        commandText = 'Ligar Luzes';
        break;
      default:
        commandText = 'Comando Inválido';
    }

    if (command.isNotEmpty) {
      widget.connection.output.add(Uint8List.fromList(command.codeUnits));
      widget.connection.output.allSent;

      // Adicione a chamada para TTS aqui
      isSoundEnabled ? _speak(commandText) : null;
    }
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("pt-BR"); // Defina o idioma desejado
    await flutterTts.setPitch(0.9); // Ajuste conforme necessário
    await flutterTts.speak(text);
  }

  void _mainActionForControlButton(String command) {
    _sendCommand(command);
  }
  void _mainActionForControlButto(String command) {
    // _sendCommand(command);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return Scaffold(
      backgroundColor: Color(0xFF2A2656),
      body: RotatedBox(
        quarterTurns: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width:
                            40.0, // Ajuste conforme necessário para o tamanho desejado
                            height:
                            40.0, // Ajuste conforme necessário para o tamanho desejado
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF07234F), // Substitua pela cor hexa desejada
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            // Adicione qualquer conteúdo desejado aqui, como um ícone ou texto
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.arrow_back, color: Colors.white,)),
                          ),

                        ],
                      )
                  ),

                  Row(
                    children: [
                      Icon(
                        isSoundEnabled ? Icons.volume_up_outlined : Icons.volume_off, color: Colors.white,),
                      Switch(
                        value: isSoundEnabled,
                        onChanged: (value) {
                          setState(() {
                            isSoundEnabled = value;
                            // Aqui você pode adicionar lógica para ativar/desativar o som
                            if (isSoundEnabled) {
                              // Ativar o som
                              print('Som ativado');
                            } else {
                              // Desativar o som
                              print('Som desativado');
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _sendCommand('S');
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                          ),
                        ),
                        child: Text('Emitir Som'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _sendCommand('L');
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                          ),
                        ),
                        child: Text('Ligar Luzes'),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.0),

                  Container(
                    margin: EdgeInsets.only(left: 80, top: 10),
                    child: InkWell(
                      onTap: () {
                        _sendCommand('C');
                      },
                      child:
                      Container(
                        height: 100,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          color: Colors.blue
                        ),
                        child: Text("Parar", style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),),
                      ),
                    ),
                  )

                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Image.asset('assets/arobot.png', height: 200,),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text("ARO", style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 38
                    ),),
                    SizedBox(
                      width: 5,
                    ),
                    Text("BOT", style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w900,
                        fontSize: 38
                    ),),
                  ],
                ),
              ],
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Joystick(connection: widget.connection, som: isSoundEnabled),
              ],
            ),
          ],
        ),
      ),
    );
  }
}





class Joystick extends StatefulWidget {
  final BluetoothConnection connection;
  final bool som;
  const Joystick({Key? key, required this.connection, required this.som}) : super(key: key);

  @override
  State<Joystick> createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  String text = '';



  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }


  Future<void> _initializeTts() async {
    await flutterTts.setLanguage("pt-BR");
    await flutterTts.setPitch(1.0);
  }


  void _sendCommand(String command) {
    String commandText;
    switch (command) {
      case 'A':
        commandText = 'Para Frente';
        break;
      case 'a':
        commandText = 'Para Tráz';
        break;
      case 'B':
        commandText = 'Para Esquerda';
        break;
      case 'b':
        commandText = 'Para Direita';
        break;
      case 'C':
        commandText = 'Parar';
        break;
      case 'Z':
        commandText = 'Giro 180 Deg';
        break;
      case 'Y':
        commandText = 'JoyStick Left';
        break;
      case 'X':
        commandText = 'JoyStick Right';
        break;
      case 'S':
        commandText = 'Emitir Som';
        break;
      case 'L':
        commandText = 'Ligar Luzes';
        break;
      default:
        commandText = 'Comando Inválido';
    }

    if (command.isNotEmpty) {
      setState(() {
        text = commandText;
      });
      widget.connection.output.add(Uint8List.fromList(command.codeUnits));
      widget.connection.output.allSent;

      // Adicione a chamada para TTS aqui
      widget.som ? _speak(commandText) : null;
    }
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("pt-BR"); // Defina o idioma desejado
    await flutterTts.setPitch(0.9); // Ajuste conforme necessário
    await flutterTts.speak(text);
  }


  void _mainActionForControlButton(String command) {
    _sendCommand(command);
  }
  void _mainActionForControlButto(String command) {
    // _sendCommand(command);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      child: Column(
        children: [

          Text(
            text,
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              JoystickButton(icon: Icons.arrow_upward, onPressed: () => _sendCommand('A')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              JoystickButton(icon: Icons.arrow_back, onPressed: () => _sendCommand('B')),
              SizedBox(width: 50),
              JoystickButton(icon: Icons.arrow_forward, onPressed: () => _sendCommand('b')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              JoystickButton(icon: Icons.arrow_downward, onPressed: () => _sendCommand('a')),
            ],
          ),
        ],
      ),
    );
  }
}

class JoystickButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const JoystickButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Icon(icon, size: 36),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(16),
      ),
    );
  }
}

