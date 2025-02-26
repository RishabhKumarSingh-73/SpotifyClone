import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class CustomGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const CustomGradientButton(
      {super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            colors: [Pallete.gradient1, Pallete.gradient2],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          )),
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
            fixedSize: Size(395, 55),
            backgroundColor: Pallete.transparentColor,
            shadowColor: Pallete.transparentColor),
      ),
    );
  }
}
