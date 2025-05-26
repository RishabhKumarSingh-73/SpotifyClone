import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_theme.dart';
import 'package:client/features/auth/view/pages/sign_up.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.openBox('MusicApp');

  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).initSharedPreferences();
  await container.read(authViewModelProvider.notifier).getData();

  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    print("Current User: $currentUser");
    return MaterialApp(
      title: 'music app',
      theme: AppTheme.darkAppTheme,
      home: currentUser == null ? SignUpPage() : HomePage(),
    );
  }
}
