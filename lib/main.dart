import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'controles.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamController<String> _dataStreamController = StreamController<String>();
  List<BluetoothDevice> _devices = [];
  late BluetoothConnection connection;
  String adr = "98:D3:71:F5:BA:6D"; // meu endereço MAC do dispositivo Bluetooth
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Controle de LED Bluetooth Único"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Endereço MAC: 98:D3:71:F5:BA:6D\nAROBOT TEST-01"),
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

             isConnected ? Text("") : SizedBox(
                height: 30.0,
                child: CircularProgressIndicator(dfgg),
              ),
              Center(
                child: isConnected
                    ? ElevatedButton(
                        child: Text("Controles"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ControlesPage(
                                enviarComando: sendData,
                              ),
                            ),
                          );
                        },
                      )
                    : Text(""),
              )
            ],
          ),
        ),
      ),
    );
  }
}
