import 'package:flutter/material.dart';

class AppColors extends ChangeNotifier {
  Color primaryColor = Color(0xFF4A90E2);
  Color secondaryColor = Color(0xFF6FCF97);
  Color tertiaryColor = Color(0xFF9B8AFB);

  void setColors({
    Color? primary,
    Color? secondary,
    Color? tertiary,
  }) {
    if (primary != null) {
      primaryColor = primary;
    }

    if (secondary != null) {
      secondaryColor = secondary;
    }

    if (tertiary != null) {
      tertiaryColor = tertiary;
    }

    notifyListeners();
  }
}