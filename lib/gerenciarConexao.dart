import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothConnectionManager extends ChangeNotifier {
  BluetoothConnection? _connection;
  bool get isConnected => _connection != null;
  Stream<bool> get connectionStream => _connectionStreamController.stream;
  final _connectionStreamController = StreamController<bool>.broadcast();

  // Getter para acessar a conexão
  BluetoothConnection get connection => _connection!;

  Future<void> connect(BluetoothDevice device) async {
    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      // Se precisar enviar dados após a conexão, faça isso aqui.
      _connectionStreamController.add(true); // Notifica os ouvintes sobre a alteração no estado.
    } catch (exception) {
      print('Erro ao conectar: $exception');
    }
  }

  Future<void> disconnect() async {
    if (_connection != null) {
      await _connection!.close();
      _connection = null;
      _connectionStreamController.add(false); // Notifica os ouvintes sobre a alteração no estado.
    }
  }
}
