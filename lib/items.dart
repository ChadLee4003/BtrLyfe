import 'package:flutter/material.dart';
import 'event.dart';

class Items extends ChangeNotifier {
  final Map<DateTime, List<Event>> _events = {};

  Map<DateTime, List<Event>> get events => _events;

  List<Event> getEventsForDay(DateTime day) {
    final date = DateTime(
      day.year,
      day.month,
      day.day,
    );

    return _events[date] ?? [];
  }

  void addEvent(DateTime day, String eventName) {
    final date = DateTime(
      day.year,
      day.month,
      day.day,
    );

    _events[date] = [
      ..._events[date] ?? [],
      Event(eventName),
    ];

    notifyListeners();
  }

  void deleteEvent(DateTime day, int index) {
    final date = DateTime(
      day.year,
      day.month,
      day.day,
    );

    if (_events[date] == null) {
      return;
    }

    _events[date]!.removeAt(index);

    if (_events[date]!.isEmpty) {
      _events.remove(date);
    }

    notifyListeners();
  }
}
