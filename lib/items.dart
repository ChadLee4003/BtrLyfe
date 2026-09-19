import 'package:flutter/material.dart';
import 'event.dart';

class Items extends ChangeNotifier {
  final Map<DateTime, List<Event>> _events = {};

  Map<DateTime, List<Event>> get events => _events;

  DateTime _dateOnly(DateTime day) {
    return DateTime(
      day.year,
      day.month,
      day.day,
    );
  }

  List<Event> getEventsForDay(DateTime day) {
    final date = _dateOnly(day);
    return _events[date] ?? [];
  }

  void addEvent(
    DateTime day,
    String eventName,
    int minutes,
    String category,
  ) {
    final date = _dateOnly(day);

    _events[date] = [
      ..._events[date] ?? [],
      Event(
        title: eventName,
        minutes: minutes,
        category: category,
      ),
    ];

    notifyListeners();
  }

  void deleteEvent(DateTime day, int index) {
    final date = _dateOnly(day);

    if (_events[date] == null) {
      return;
    }

    _events[date]!.removeAt(index);

    if (_events[date]!.isEmpty) {
      _events.remove(date);
    }

    notifyListeners();
  }

  Map<DateTime, int> getStudyMinutesByDate() {
    final Map<DateTime, int> studyMinutes = {};

    for (final entry in _events.entries) {
      int totalMinutes = 0;

      for (final event in entry.value) {
        if (event.category == 'Study') {
          totalMinutes += event.minutes;
        }
      }

      if (totalMinutes > 0) {
        studyMinutes[entry.key] = totalMinutes;
      }
    }

    return studyMinutes;
  }
}