import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'command.dart';
import 'gerenciarConexao.dart';
// import 'package:arobot_controller/command_page.dart'; // Importe a página de comandos

class Tela2 extends StatefulWidget {
  const Tela2({Key? key}) : super(key: key);

  @override
  State<Tela2> createState() => _Tela2State();
}

class _Tela2State extends State<Tela2> {
  List<BluetoothDevice> _pairedDevices = [];
  late BluetoothConnectionManager _connectionManager;
  Map<String, bool> _connectionStates = {};
  String? _connectedDeviceAddress;

  @override
  void initState() {
    super.initState();
    _loadDevices();
    _connectionManager = BluetoothConnectionManager();
  }

  Future<void> _loadDevices() async {
    List<BluetoothDevice> devices =
    await FlutterBluetoothSerial.instance.getBondedDevices();

    setState(() {
      _pairedDevices = devices;
      _pairedDevices.forEach((device) {
        _connectionStates[device.address!] = false;
      });
    });
  }

  void _showConnectionMessage(String deviceName, String deviceAddress) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Conectado ao dispositivo $deviceName'),
        duration: Duration(seconds: 2),
      ),
    );
    Fluttertoast.showToast(
              msg: 'Conectado ao dispositivo $deviceName',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
    _connectedDeviceAddress = deviceAddress; // Adicione esta linha
  }



  void _navigateToCommandPage() {
    if (_connectionManager.isConnected) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CommandPage(connection: _connectionManager.connection),
        ),
      );
    } else {
      Fluttertoast.showToast(
        msg: "Conecte a um dispositivo primeiro!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print('Erro: Dispositivo não conectado....');
    }
  }


  // void _navigateToCommandPage() {
  //   if (_connectionManager.isConnected) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => CommandPage(connection: _connectionManager.connection),
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).removeCurrentSnackBar(); // Remove snackbar anterior, se houver
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Conecte a um dispositivo primeiro!'),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //     print('Erro: Dispositivo não conectado....');
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Color(0xFF2A2656),
        appBar: AppBar(
          title: Text('Escolha o seu dispositivo'),
          actions: [
            // Adiciona um botão à AppBar
            IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: () {
                // Navega para a página de comandos ao pressionar o botão
                _navigateToCommandPage();
              },
            ),
          ],
        ),
        body: StreamBuilder<bool>(
          stream: _connectionManager.connectionStream,
          initialData: false,
          builder: (context, snapshot) {
            bool isConnected = snapshot.data ?? false;

            return ListView.builder(
              itemCount: _pairedDevices.length,
              itemBuilder: (context, index) {
                BluetoothDevice device = _pairedDevices[index];
                bool deviceIsConnected =
                    _connectionStates[device.address!] ?? false;

                return ListTile(
                  title: Text(
                    device.name ?? 'Nome Desconhecido',
                    style: TextStyle(
                      color:
                      deviceIsConnected ? Colors.white : Colors.blue[400],
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    device.address ?? 'Endereço Desconhecido',
                    style: TextStyle(
                      color:
                      deviceIsConnected ? Colors.white : Colors.blue[200],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  tileColor: deviceIsConnected ? Colors.blue[800] : null,
                  trailing: deviceIsConnected
                      ? IconButton(
                    icon: Icon(
                      Icons.power_settings_new,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () {
                      _connectionManager.disconnect();
                      setState(() {
                        _connectionStates[device.address!] = false;
                      });
                    },
                  )
                      : null,
                  onTap: () async {
                    if (device.address != null) {
                      if (!deviceIsConnected) {
                        await _connectionManager.connect(device);
                        if (_connectionManager.isConnected) {
                          setState(() {
                            _connectionStates[device.address!] = true;
                          });
                          _showConnectionMessage(device.name ?? 'Dispositivo', device.address!);
                        }
                      }
                    } else {
                      print('Endereço do dispositivo é nulo');
                    }
                  },
                );
              },
            );
          },
        ),
      );
  }
}
