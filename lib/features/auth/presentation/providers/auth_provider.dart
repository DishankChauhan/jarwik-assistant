import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';

// Custom auth state model (renamed to avoid conflict with Supabase's AuthState)
class AppAuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AppAuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AppAuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AppAuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppAuthState &&
        other.user?.id == user?.id &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.isAuthenticated == isAuthenticated;
  }

  @override
  int get hashCode {
    return Object.hash(user?.id, isLoading, error, isAuthenticated);
  }
}

// Auth notifier
class AuthNotifier extends StateNotifier<AppAuthState> {
  final SupabaseService _supabaseService;

  AuthNotifier(this._supabaseService) : super(const AppAuthState()) {
    _initAuthListener();
    _checkInitialAuthState();
  }

  void _initAuthListener() {
    _supabaseService.authStateChanges.listen((AuthState supabaseAuthState) {
      final user = supabaseAuthState.session?.user;
      state = state.copyWith(
        user: user,
        isAuthenticated: user != null,
        isLoading: false,
        error: null,
      );
    });
  }

  void _checkInitialAuthState() {
    final user = _supabaseService.currentUser;
    state = state.copyWith(
      user: user,
      isAuthenticated: user != null,
      isLoading: false,
    );
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await _supabaseService.signInWithGoogle();
      if (!success) {
        throw Exception('Google sign in was cancelled');
      }
      // State will be updated through the auth listener
    } catch (e) {
      print('Google sign-in error: $e'); // Debug print
      state = state.copyWith(
        isLoading: false,
        error: 'Google sign-in failed: ${e.toString()}',
        isAuthenticated: false,
      );
      rethrow;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _supabaseService.signIn(
        email: email,
        password: password,
      );

      // Check if sign in was successful
      if (response.user != null) {
        // State will be updated through the auth listener
        print('Sign in successful: ${response.user?.email}');
      } else {
        throw Exception('Sign in failed: No user returned');
      }
    } catch (e) {
      print('Email sign-in error: $e'); // Debug print

      // Parse Supabase-specific errors
      String errorMessage = 'Sign-in failed';
      final errorString = e.toString().toLowerCase();

      if (errorString.contains('invalid_credentials') ||
          errorString.contains('invalid login credentials')) {
        errorMessage =
            'Invalid email or password. Please check your credentials or sign up if you don\'t have an account.';
      } else if (errorString.contains('email_not_confirmed') ||
          errorString.contains('not confirmed') ||
          errorString.contains('signup_disabled') ||
          (errorString.contains('invalid_credentials') &&
              errorString.contains('email'))) {
        errorMessage =
            'Please verify your email address. Check your inbox (including spam folder) and click the verification link we sent you.';
      } else if (errorString.contains('too_many_requests')) {
        errorMessage =
            'Too many sign-in attempts. Please wait a moment and try again.';
      } else if (errorString.contains('network') ||
          errorString.contains('connection')) {
        errorMessage = 'Network error. Please check your internet connection.';
      }

      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
        isAuthenticated: false,
      );
      rethrow;
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _supabaseService.signUp(
        email: email,
        password: password,
      );

      // Check if sign up was successful
      if (response.user != null) {
        print('Sign up successful: ${response.user?.email}');

        // Check if email confirmation is required
        if (response.session == null) {
          print('Email confirmation required for: ${response.user?.email}');
          // Set loading to false but don't show as authenticated yet
          state = state.copyWith(
            isLoading: false,
            user: response.user,
            isAuthenticated: false,
            error: null,
          );
        } else {
          // User is immediately authenticated (email confirmation disabled)
          state = state.copyWith(
            isLoading: false,
            user: response.user,
            isAuthenticated: true,
            error: null,
          );
        }
      } else {
        throw Exception('Sign up failed: No user returned');
      }
    } catch (e) {
      print('Email sign-up error: $e'); // Debug print

      // Parse Supabase-specific errors
      String errorMessage = 'Sign-up failed';
      final errorString = e.toString().toLowerCase();

      if (errorString.contains('user_already_registered') ||
          errorString.contains('already registered')) {
        errorMessage =
            'An account with this email already exists. Please try signing in instead.';
      } else if (errorString.contains('weak_password') ||
          errorString.contains('password')) {
        errorMessage =
            'Password is too weak. Please use at least 6 characters.';
      } else if (errorString.contains('invalid_email')) {
        errorMessage = 'Please enter a valid email address.';
      } else if (errorString.contains('network') ||
          errorString.contains('connection')) {
        errorMessage = 'Network error. Please check your internet connection.';
      }

      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
        isAuthenticated: false,
      );
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _supabaseService.signOut();
      state = const AppAuthState(isAuthenticated: false, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> resendVerification(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _supabaseService.resendVerification(email, password);
      state = state.copyWith(isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to resend verification email: ${e.toString()}',
      );
      rethrow;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final authProvider = StateNotifierProvider<AuthNotifier, AppAuthState>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return AuthNotifier(supabaseService);
});

// Helper provider to check authentication status
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isAuthenticated;
});

// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user;
});
