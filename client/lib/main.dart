import 'package:client/core/theme/app_theme.dart';
import 'package:client/features/auth/view/pages/sign_in.dart';
import 'package:client/features/auth/view/pages/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'music app',
      theme: AppTheme.darkAppTheme,
      home: SignUpPage(),
    );
  }
}
