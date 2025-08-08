import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment variables
  await AppConfig.initialize();

  // Initialize Supabase with environment variables
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

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
      debugShowCheckedModeBanner: false, // This removes the debug banner
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to dark theme for premium look
      initialRoute: AppRouter.getInitialRoute(),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
