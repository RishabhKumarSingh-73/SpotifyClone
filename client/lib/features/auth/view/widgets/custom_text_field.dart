import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final hintText;
  final bool isObscure;
  final controller;
  const CustomField(
      {super.key,
      required this.hintText,
      this.isObscure = false,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(hintText: hintText),
      obscureText: isObscure,
      controller: controller,
      validator: (val) {
        if (val!.isEmpty) {
          return "$hintText is missing";
        }
        return null;
      },
    );
  }
}
