import 'dart:io';

import 'package:flutter/material.dart';
import '../utils/Env.dart';

import 'screens/Home.dart';
import 'utils/ThemeData.dart';
import 'utils/utils.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  static Function? refresh;
  @override
  void initState() {
    getFavorites();
    super.initState();
    final window = WidgetsBinding.instance.window;

    // This callback is called every time the brightness changes.
    window.onPlatformBrightnessChanged = () {
      final brightness = window.platformBrightness;
    };
  }

  @override
  Widget build(BuildContext context) {
    refresh = () => setState(() => {});
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: Env.themeState.themeMode,
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      home: const Home(),
    );
  }
}
