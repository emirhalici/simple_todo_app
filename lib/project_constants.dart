import 'package:flutter/material.dart';

class ProjectConstants {
  static const Color _priority1Color = Color(0xAAFFA4A4);
  static const Color _priority2Color = Color(0xAAFDFFA4);
  static const Color _priority3Color = Color(0xAAB0FFA4);

  static const Color _cardBackgroundColorLight = Color(0xAAE8ECEF);
  static const Color _cardBackgroundColorDark = Color(0xAA494B51);

  static Color cardBackgroundColor(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return _cardBackgroundColorLight;
    } else {
      return _cardBackgroundColorDark;
    }
  }

  static Color priorityColor(int priority) {
    if (priority == 1) {
      return _priority1Color;
    } else if (priority == 2) {
      return _priority2Color;
    } else {
      return _priority3Color;
    }
  }

  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Poppins',
    useMaterial3: false,
    colorScheme: const ColorScheme.light(
      primary: Colors.blueGrey,
      brightness: Brightness.light,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Poppins',
    useMaterial3: false,
    scaffoldBackgroundColor: const Color(0xAA2F3136),
    colorScheme: const ColorScheme.dark(
      primary: Colors.blueGrey,
      brightness: Brightness.dark,
    ),
  );
}
