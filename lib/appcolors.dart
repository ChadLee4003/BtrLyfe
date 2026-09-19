import 'package:flutter/material.dart';

class AppColors extends ChangeNotifier {
  Color _primaryColor = const Color(0xFF4A90E2);
  Color _secondaryColor = const Color(0xFF6FCF97);
  Color _tertiaryColor = const Color(0xFF9B8AFB);

  // Original colors of the selected theme
  Color _basePrimaryColor = const Color(0xFF4A90E2);
  Color _baseSecondaryColor = const Color(0xFF6FCF97);
  Color _baseTertiaryColor = const Color(0xFF9B8AFB);

  // 0 = black, 50 = normal, 100 = white
  double _brightness = 50;

  Color get primaryColor => _primaryColor;
  Color get secondaryColor => _secondaryColor;
  Color get tertiaryColor => _tertiaryColor;

  double get brightness => _brightness;

  // ------------------------------------------------------------
  // CHANGE THEME
  // ------------------------------------------------------------

  void setColors({
    required Color primary,
    required Color secondary,
    required Color tertiary,
  }) {
    // Save the ORIGINAL theme colors
    _basePrimaryColor = primary;
    _baseSecondaryColor = secondary;
    _baseTertiaryColor = tertiary;

    // New themes always start at 50%
    _brightness = 50;

    _primaryColor = primary;
    _secondaryColor = secondary;
    _tertiaryColor = tertiary;

    notifyListeners();
  }

  // ------------------------------------------------------------
  // CHANGE BRIGHTNESS
  // ------------------------------------------------------------

  void setBrightness(double value) {
    _brightness = value;

    _primaryColor = adjustBrightness(
      _basePrimaryColor,
      value,
    );

    _secondaryColor = adjustBrightness(
      _baseSecondaryColor,
      value,
    );

    _tertiaryColor = adjustBrightness(
      _baseTertiaryColor,
      value,
    );

    notifyListeners();
  }

  // ------------------------------------------------------------
  // BRIGHTNESS CALCULATION
  // ------------------------------------------------------------

  Color adjustBrightness(
    Color color,
    double brightness,
  ) {
    if (brightness <= 50) {
      final amount = brightness / 50;

      return Color.lerp(
        Colors.black,
        color,
        amount,
      )!;
    } else {
      final amount = (brightness - 50) / 50;

      return Color.lerp(
        color,
        Colors.white,
        amount,
      )!;
    }
  }
}