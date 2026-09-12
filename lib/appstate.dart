import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  TimeOfDay sleepTime = const TimeOfDay(
    hour: 23,
    minute: 0,
  );

  void setTime(TimeOfDay time) {
    sleepTime = time;
    notifyListeners();
  }
}