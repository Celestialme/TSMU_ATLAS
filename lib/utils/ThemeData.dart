import 'package:flutter/material.dart';

class CustomTheme {
  static final lightTheme = ThemeData(
    drawerTheme: const DrawerThemeData(
        backgroundColor: Color.fromRGBO(160, 160, 160, 1)),
    brightness: Brightness.light,
    primaryColor: Colors.white,
    dividerColor: Colors.black54,
    scaffoldBackgroundColor: const Color.fromRGBO(146, 209, 255, 1),
    appBarTheme: const AppBarTheme(color: Color.fromRGBO(42, 92, 165, 1)),
    colorScheme: const ColorScheme.light(
        onPrimaryContainer: Colors.black,
        primaryContainer: Color.fromRGBO(240, 240, 240, 1),
        background: Color.fromRGBO(107, 237, 255, 1)),
  );
  static final darkTheme = ThemeData(
    drawerTheme:
        const DrawerThemeData(backgroundColor: Color.fromRGBO(64, 64, 64, 1)),
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    dividerColor: Colors.white,
    scaffoldBackgroundColor: const Color.fromRGBO(64, 64, 64, 1),
    appBarTheme: const AppBarTheme(color: Color.fromRGBO(77, 77, 77, 1)),
    colorScheme: const ColorScheme.dark(
        onPrimaryContainer: Colors.black,
        primaryContainer: Color.fromRGBO(217, 217, 217, 1),
        background: Color.fromRGBO(11, 95, 122, 1)),
  );
}
