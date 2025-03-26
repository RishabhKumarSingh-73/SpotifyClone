import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final hintText;
  final bool isObscure;
  final TextEditingController? controller;
  final bool isReadOnly;
  final VoidCallback? onTap;
  const CustomField({
    super.key,
    required this.hintText,
    this.controller,
    this.isObscure = false,
    this.isReadOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(hintText: hintText),
      obscureText: isObscure,
      controller: controller,
      onTap: onTap,
      validator: (val) {
        if (val!.isEmpty) {
          return "$hintText is missing";
        }
        return null;
      },
    );
  }
}
