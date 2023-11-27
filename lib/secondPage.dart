import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'gerenciarConexao.dart';

class ChoosePage extends StatefulWidget {
  final BluetoothConnectionManager connectionManager;
  final String? connectedDeviceAddress;

  const ChoosePage({
    required this.connectionManager,
    required this.connectedDeviceAddress,
    Key? key,
  }) : super(key: key);

  @override
  State<ChoosePage> createState() => _ChoosePageState();
}
class _ChoosePageState extends State<ChoosePage> {
  StreamController<String> _dataStreamController = StreamController<String>();
  List<BluetoothDevice> _devices = [];
  late BluetoothConnection connection;
  String? _connectedDeviceAddress;
  bool isConnected = false;
  String? _receivedData; // Adicione esta linha

  String adr = "00:21:06:BE:62:CD"; // meu endereço MAC do dispositivo Bluetooth

  @override
  void initState() {
    super.initState();
    // _connectionManager = widget.connectionManager;
    // connection = connectionManager.connection; // Inicialize connection
    _loadDevices();

    // Adicione a seguinte linha para receber dados
    connection.input!.listen((Uint8List data) {
      String receivedData = String.fromCharCodes(data);
      setState(() {
        _receivedData = receivedData;
      });
      _dataStreamController.add(receivedData);
    });
  }

  Future<void> _loadDevices() async {
    List<BluetoothDevice> devices =
    await FlutterBluetoothSerial.instance.getBondedDevices();

    setState(() {
      _devices = devices;
    });
  }

  Future<void> sendData(String data) async {
    data = data.trim();
    try {
      List<int> list = data.codeUnits;
      Uint8List bytes = Uint8List.fromList(list);
      connection.output.add(bytes);
      await connection.output.allSent;
      if (kDebugMode) {
        print('Data sent successfully');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void toggleConnection() {
    if (isConnected) {
      disconnect();
    } else {
      connect(adr);
    }
  }

  Future connect(String address) async {
    try {
      connection = await BluetoothConnection.toAddress(address);
      sendData('111');
      setState(() {
        isConnected = true;
      });

      connection.input!.listen((Uint8List data) {
        String receivedData = String.fromCharCodes(data);
        _dataStreamController.add(receivedData);
      });
    } catch (exception) {
      setState(() {
        isConnected = false;
      });
    }
  }

  Future disconnect() async {
    await connection.close();
    setState(() {
      isConnected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Endereço MAC: 00:21:06:BE:62:CD\nAROBOT TEST-01"),
                  ElevatedButton(
                    child: Text(isConnected ? "Desconectar" : "Conectar"),
                    onPressed: () {
                      toggleConnection();
                    },
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Builder(
                    builder: (BuildContext context) {
                      if (isConnected) {
                        return Text("Conectado ao MAC $adr");
                      } else {
                        return Text("Desconectado");
                      }
                    },
                  ),
                  SizedBox(
                    height: 30.0,
                  ),

                  isConnected == true ? Text("") : SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(),
                  ),
                  Center(
                    child: isConnected
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            sendData('A'); // Enviar comando para ligar
                          },
                          child: Text('Ligar'),
                        ),
                        SizedBox(height: 10.0),
                        ElevatedButton(
                          onPressed: () {
                            sendData('a'); // Enviar comando para desligar
                          },
                          child: Text('Desligar'),
                        ),
                        SizedBox(height: 10.0),
                        ElevatedButton(
                          onPressed: () {
                            sendData('C'); // Enviar comando para desligar
                          },
                          child: Text('Parar'),
                        ),
                      ],
                    )
                    // ElevatedButton(
                    //         child: Text("Controles"),
                    //         onPressed: () {
                    //           Navigator.push(
                    //             context,
                    //             PageTransition(
                    //               type: PageTransitionType.rightToLeft,
                    //               duration: const Duration(milliseconds: 200),
                    //               child:  ControlesPage(),
                    //             ),
                    //           );
                    //         },
                    //       )
                        : Text(""),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
