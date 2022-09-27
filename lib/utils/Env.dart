import 'package:flutter/material.dart';
import '../main.dart' as main;
import '../screens/ContentScreen.dart';
import '../screens/YearScreen.dart';

class ThemeState {
  ThemeMode themeMode = ThemeMode.system;
  set mode(ThemeMode value) {
    themeMode = value;
    main.MyAppState.refresh!();
  }

  ThemeMode get mode {
    return themeMode;
  }
}

class Env {
  static const apiUrl = "https://php.celestialmee.repl.co?path=";
  static const baseUrl = "https://php.celestialmee.repl.co";
  static String subject = "";
  static ThemeState themeState = ThemeState();
  static List<dynamic> favorites = [];
}
