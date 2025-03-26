import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

String rgbToHex(Color color) {
  return '${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
}

Color hexToRgb(String hex) {
  return Color(int.parse(hex, radix: 16) + 0XFF000000);
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

Future<File?> audioPicker() async {
  try {
    final filePickerRes =
        await FilePicker.platform.pickFiles(type: FileType.audio);

    if (filePickerRes != null) {
      return File(filePickerRes.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}

Future<File?> imagePicker() async {
  try {
    final imagePickerRes =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (imagePickerRes != null) {
      return File(imagePickerRes.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}
