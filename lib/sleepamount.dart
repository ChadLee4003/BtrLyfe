import 'package:flutter/material.dart';

class SleepProvider extends ChangeNotifier {
  DateTime? _sleepStartTime;

  // Stores sleep duration in hours for each date
  final Map<DateTime, double> sleepHours = {};

  bool get isSleeping => _sleepStartTime != null;

  get duration => null;

  get dailyValues => null;

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  void startSleep() {
    if (_sleepStartTime != null) return;

    _sleepStartTime = DateTime.now();
    notifyListeners();
  }

  void wakeUp() {
    if (_sleepStartTime == null) return;

    final wakeTime = DateTime.now();

    final duration = wakeTime.difference(_sleepStartTime!);

    final hours = duration.inMinutes / 60.0;

    // Record the sleep duration on the date the sleep started
    final date = _dateOnly(_sleepStartTime!);

    sleepHours[date] = hours;

    _sleepStartTime = null;

    notifyListeners();
  }
}