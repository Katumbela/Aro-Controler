import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ControlesPage extends StatefulWidget {

  ControlesPage();

  @override
  _ControlesPageState createState() => _ControlesPageState();
}

class _ControlesPageState extends State<ControlesPage> {

  StreamController<String> _dataStreamController = StreamController<String>();
  List<BluetoothDevice> _devices = [];
  late BluetoothConnection connection;
  String adr = "00:21:06:BE:62:CD"; // meu endereço MAC do dispositivo Bluetooth
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _loadDevices();
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
          ],
        ),
      ),
    );
  }
}
