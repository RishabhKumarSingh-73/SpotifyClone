import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showSnackBarCustom(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: TextStyle(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold),
      ),
      backgroundColor: Pallete.gradient2,
      behavior: SnackBarBehavior.floating, // makes it float above bottom nav
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.all(16), // required when using `floating` behavior
      duration: Duration(seconds: 3),
    ),
  );
}
