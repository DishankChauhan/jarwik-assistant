import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/voice/presentation/pages/voice_assistant_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL', // Replace with your Supabase URL
    anonKey: 'YOUR_SUPABASE_ANON_KEY', // Replace with your Supabase anon key
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
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to dark theme for premium look
      home: const SplashPage(),
      routes: {'/voice-assistant': (context) => const VoiceAssistantPage()},
      // onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
