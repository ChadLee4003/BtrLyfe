import 'package:flutter/material.dart';

class DailyValueProvider extends ChangeNotifier {
  Map<DateTime, int> dailyValues = {};

  DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool get submittedToday {
    final today = _today();
    return dailyValues.containsKey(today);
  }

  int get todayValue {
    final today = _today();
    return dailyValues[today] ?? -1;
  }

  void submitValue(int value) {
    final today = _today();

    // Don't allow another submission today
    if (dailyValues.containsKey(today)) {
      return;
    }

    // Only allow values from 0-4
    if (value < 0 || value > 4) {
      return;
    }

    dailyValues[today] = value;
    notifyListeners();
  }
}