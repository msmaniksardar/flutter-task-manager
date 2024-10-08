// Define your light theme with consistent brightness
import 'package:flutter/material.dart';
import 'package:task_manager/ui/utility/app_colors.dart';

final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorSchemeSeed: Colors.white,
    textTheme: _textLightTheme(),
    elevatedButtonTheme: _elevatedButtonLightThemeData(),
    inputDecorationTheme:  _inputDecorationLightTheme());

InputDecorationTheme _inputDecorationLightTheme() {
  return InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      hintStyle: TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide.none));
}

TextTheme _textLightTheme() {
  return TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.black87),
  );
}

ElevatedButtonThemeData _elevatedButtonLightThemeData() {
  return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.themeColor,
          fixedSize: Size.fromWidth(double.maxFinite)));
}












// Define your dark theme with consistent brightness
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.green,
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white70),
  ),
);
