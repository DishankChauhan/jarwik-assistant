import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize core services
  // await Firebase.initializeApp();
  // await Hive.initFlutter();

  runApp(const ProviderScope(child: JarwikApp()));
}

class JarwikApp extends ConsumerWidget {
  const JarwikApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Jarwik AI Assistant',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashPage(),
      // onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
