import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // Supabase Configuration
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Google OAuth Configuration
  static String get googleClientIdAndroid =>
      dotenv.env['GOOGLE_CLIENT_ID_ANDROID'] ?? '';
  static String get googleClientIdIOS =>
      dotenv.env['GOOGLE_CLIENT_ID_IOS'] ?? '';
  static String get googleClientIdWeb =>
      dotenv.env['GOOGLE_CLIENT_ID_WEB'] ?? '';

  // ElevenLabs Configuration
  static String get elevenLabsApiKey => dotenv.env['ELEVENLABS_API_KEY'] ?? '';

  // OpenAI Configuration
  static String get openAiApiKey => dotenv.env['OPENAI_API_KEY'] ?? '';

  // Helper method to check if all required configs are set
  static bool get isConfigured {
    return supabaseUrl.isNotEmpty &&
        supabaseAnonKey.isNotEmpty &&
        googleClientIdAndroid.isNotEmpty;
  }

  // Initialize environment variables
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }
}
