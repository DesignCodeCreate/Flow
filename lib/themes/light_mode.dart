import 'package:flutter/material.dart';

final ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blueGrey[900],
  scaffoldBackgroundColor: Colors.blueGrey.shade200,
  
  appBarTheme: AppBarTheme(
    color: Colors.blueGrey[700],
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black54),
    titleLarge: TextStyle(color: Colors.black87, fontSize: 20),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueGrey),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueGrey[700]!),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  ),
  iconTheme: IconThemeData(
    color: Colors.black87,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blueGrey[700],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  ),
  colorScheme: ColorScheme.light(
    brightness: Brightness.light,
    primary: Colors.blueGrey[800]!,
    onPrimary: Colors.white,
    secondary: Colors.blueGrey,
    onSecondary: Colors.white,
    surface: Color(0xFFF5F5F5),
    onSurface: Colors.black87,
    error: Colors.redAccent,
    onError: Colors.white,
  ),
);
