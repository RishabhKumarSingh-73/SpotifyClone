import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
      );
  static final darkAppTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Pallete.backgroundColor,
      inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.all(24),
          focusedBorder: _border(Pallete.gradient2),
          enabledBorder: _border(Pallete.borderColor)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Pallete.backgroundColor),
      appBarTheme: AppBarTheme(centerTitle: true));
}
