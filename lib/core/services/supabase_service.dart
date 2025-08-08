import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Supabase service provider
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

class SupabaseService {
  // Get the Supabase client instance
  SupabaseClient get client => Supabase.instance.client;

  // Get current user
  User? get currentUser => client.auth.currentUser;

  // Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  // Stream of authentication state changes
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  /// Initialize Supabase
  static Future<void> initialize() async {
    // This is now handled in main.dart with environment variables
    // No need for manual initialization here
  }

  /// Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      print('Attempting to sign up user: $email'); // Debug log

      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: fullName != null ? {'full_name': fullName} : null,
        emailRedirectTo:
            null, // For development - can set a custom redirect URL later
      );

      print(
        'Sign up response - User: ${response.user?.email}, Session: ${response.session != null}',
      ); // Debug log

      if (response.user == null) {
        throw Exception('Sign up failed: No user returned from Supabase');
      }

      // For development: If email confirmation is enabled but user can't receive emails
      // we can check if the user exists but isn't confirmed
      if (response.session == null && response.user != null) {
        print(
          'User created but email confirmation required. Check your email (including spam folder).',
        );
        print(
          'If you can\'t receive emails, you may need to configure email settings in Supabase dashboard.',
        );
      }

      return response;
    } catch (e) {
      print('Supabase sign up error: $e'); // Debug log
      throw Exception('Sign up failed: $e');
    }
  }

  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('Attempting to sign in user: $email'); // Debug log

      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print(
        'Sign in response - User: ${response.user?.email}, Session: ${response.session != null}',
      ); // Debug log

      if (response.user == null) {
        throw Exception('Sign in failed: Invalid credentials');
      }

      return response;
    } catch (e) {
      print('Supabase sign in error: $e'); // Debug log
      throw Exception('Sign in failed: $e');
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      final response = await client.auth.signInWithOAuth(OAuthProvider.google);
      return response;
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  /// Resend email verification
  Future<void> resendVerification(String email, String password) async {
    try {
      // This will trigger another verification email to be sent
      await client.auth.signUp(email: email, password: password);
    } catch (e) {
      // If user already exists, that's expected
      if (!e.toString().toLowerCase().contains('already registered')) {
        throw Exception('Failed to resend verification: $e');
      }
    }
  }

  /// Update user profile
  Future<UserResponse> updateProfile({String? fullName, String? email}) async {
    try {
      final updates = <String, dynamic>{};
      if (fullName != null) updates['full_name'] = fullName;
      if (email != null) updates['email'] = email;

      final response = await client.auth.updateUser(
        UserAttributes(
          email: email,
          data: fullName != null ? {'full_name': fullName} : null,
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }

  /// Store user preferences
  Future<void> storeUserPreferences(Map<String, dynamic> preferences) async {
    if (!isAuthenticated) throw Exception('User not authenticated');

    try {
      await client.from('user_preferences').upsert({
        'user_id': currentUser!.id,
        'preferences': preferences,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to store preferences: $e');
    }
  }

  /// Get user preferences
  Future<Map<String, dynamic>?> getUserPreferences() async {
    if (!isAuthenticated) throw Exception('User not authenticated');

    try {
      final response = await client
          .from('user_preferences')
          .select('preferences')
          .eq('user_id', currentUser!.id)
          .maybeSingle();

      return response?['preferences'] as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Failed to get preferences: $e');
    }
  }
}
