import 'dart:async';
import 'package:arobot_controller/secondPage.dart';
import 'package:arobot_controller/sound_provide.dart';
import 'package:arobot_controller/tela2.dart';
import 'package:arobot_controller/tela3.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'controles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Solicitar permissões necessárias
  await _requestPermissions();

  runApp(
    MaterialApp(
      title: 'ARO CONTROLLER AROTEC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (context) => SoundProvider(),
        child: MyApp(),
      ),
    ),
  );
}

Future<void> _requestPermissions() async {
  var status = await Permission.location.status;
  if (status.isDenied) {
    await Permission.location.request();
  }

  status = await Permission.bluetooth.status;
  if (status.isDenied) {
    await Permission.bluetooth.request();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
          backgroundColor: Color(0xFF2A2656),
          body: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 120),
                width:
                    250.0, // Ajuste conforme necessário para o tamanho desejado
                height:
                    250.0, // Ajuste conforme necessário para o tamanho desejado
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
                child: Lottie.asset('assets/boticon.json',
                    width: MediaQuery.of(context).size.width * 0.4),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .2),
                child: Row(
                  children: [
                    Text(
                      "ARO _",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF216FE4),
                          fontSize: 34),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 25, left: 10),
                      child: Lottie.asset(
                        'assets/3pontos.json',
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 1,
              ),
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .2),
                child: Text(
                  "CONTROLLER",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF216FE4),
                      fontSize: 34),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                width: MediaQuery.of(context).size.width * .6,
                margin: EdgeInsets.symmetric(vertical: 20.0),
                child: Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: const Duration(milliseconds: 200),
                            child: Tela3(),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.blue[800],
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset('assets/slideright.json', height: 50),
                            Container(
                              child: Text(
                                "Começar",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                            Lottie.asset('assets/slideright.json', height: 50),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Image.asset(
                  'assets/logo.png',
                  height: 20,
                ),
              )
            ],
          ),
    );
  }
}
