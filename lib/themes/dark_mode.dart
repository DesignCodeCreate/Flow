import 'package:flutter/material.dart';

final ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blueGrey[900],
  scaffoldBackgroundColor: Color(0xFF121212),
  appBarTheme: AppBarTheme(
    color: Colors.blueGrey[900],
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white70),
    bodyMedium: TextStyle(color: Colors.white60),
    titleLarge: TextStyle(color: Colors.white, fontSize: 20),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF1E1E1E),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white24),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueGrey),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  ),
  iconTheme: IconThemeData(
    color: Colors.white70,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blueGrey[800],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  ),
  colorScheme: ColorScheme.dark(
    brightness: Brightness.dark,
    primary: Colors.blueGrey[900]!,
    onPrimary: Colors.white,
    secondary: Colors.blueGrey,
    onSecondary: Colors.white,
    surface: Color(0xFF1E1E1E),
    onSurface: Colors.white70,
    error: Colors.redAccent,
    onError: Colors.white,
  ),
);
