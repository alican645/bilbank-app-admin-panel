import 'package:bilbank_admin_panel/core/app_colors.dart';
import 'package:bilbank_admin_panel/data/local_storage/local_storage_impl.dart';
import 'package:bilbank_admin_panel/data/local_storage/local_storage_keys.dart';
import 'package:bilbank_admin_panel/presentation/navigation/app_page_keys.dart';
import 'package:bilbank_admin_panel/presentation/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localStorage = LocalStorageImpl();
  await localStorage.init();

  final rememberCheck =
      await localStorage.getValue<bool>(LocalStorageKeys.rememberCheck, false);
  final accessToken =
      await localStorage.getValue<String>(LocalStorageKeys.accessToken, '');

  final initialLocation =
      rememberCheck && accessToken.isNotEmpty
          ? AppPageKeys.roomHome
          : AppPageKeys.login;

  runApp(MyApp(initialLocation: initialLocation));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required String initialLocation})
      : _router = router(initialLocation: initialLocation);

  final GoRouter _router;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
      ),
    );
  }
}

