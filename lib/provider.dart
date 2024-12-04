import 'package:flutter/material.dart';

class StateManagement extends ChangeNotifier {
  int currentView = 1;

  void changeView(int num) {
    currentView = num;
    notifyListeners();
  }
}
