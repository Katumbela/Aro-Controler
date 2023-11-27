import 'package:flutter/material.dart';

class SoundProvider extends ChangeNotifier {
  bool _isSoundEnabled = true;

  bool get isSoundEnabled => _isSoundEnabled;

  set isSoundEnabled(bool value) {
    _isSoundEnabled = value;
    notifyListeners();
  }
}
