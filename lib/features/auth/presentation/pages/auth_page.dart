import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _showEmailForm = false;
  bool?
  _isSignUp; // null = show choice, false = sign in form, true = sign up form

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.signInWithGoogle();

      if (mounted) {
        // Add a small delay to ensure authentication state is updated
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      if (mounted) {
        final errorString = e.toString().toLowerCase();
        String userMessage;

        if (errorString.contains('cancelled') ||
            errorString.contains('cancel')) {
          userMessage = 'Sign in was cancelled. Please try again.';
        } else if (errorString.contains('network') ||
            errorString.contains('internet')) {
          userMessage = 'Network error. Please check your internet connection.';
        } else {
          userMessage = 'Google sign in failed. Please try again or use email.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text(userMessage)),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authNotifier = ref.read(authProvider.notifier);

      if (_isSignUp == true) {
        await authNotifier.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Account created! Check your email for verification link.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
            ),
          );
          // Switch to sign in mode after successful signup
          setState(() {
            _isSignUp = false;
          });
        }
      } else {
        await authNotifier.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      }
    } catch (e) {
      if (mounted) {
        _handleAuthError(e);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleAuthError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    String userMessage;
    Color backgroundColor = Theme.of(context).colorScheme.error;

    if (errorString.contains('invalid login credentials') ||
        errorString.contains('invalid_credentials')) {
      userMessage = (_isSignUp == true)
          ? 'Account creation failed. Please try again.'
          : 'Account not found. Please check your email or sign up first.';

      // If it's a sign in attempt with invalid credentials, suggest signing up
      if (_isSignUp != true) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            _showSignUpSuggestion();
          }
        });
      }
    } else if (errorString.contains('user_already_registered') ||
        errorString.contains('already registered')) {
      userMessage = 'This email is already registered. Try signing in instead.';
      // Switch to sign in mode
      setState(() {
        _isSignUp = false;
      });
    } else if (errorString.contains('email_not_confirmed') ||
        errorString.contains('not confirmed')) {
      userMessage = 'Please check your email and click the verification link.';
      backgroundColor = Colors.orange;
    } else if (errorString.contains('weak_password') ||
        errorString.contains('password')) {
      userMessage = 'Password must be at least 6 characters long.';
    } else {
      userMessage = (_isSignUp == true)
          ? 'Sign up failed. Please try again.'
          : 'Sign in failed. Please check your credentials.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(userMessage),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 4),
        action:
            (_isSignUp != true) &&
                errorString.contains('invalid login credentials')
            ? SnackBarAction(
                label: 'Sign Up',
                textColor: Colors.white,
                onPressed: () {
                  setState(() {
                    _isSignUp = true;
                  });
                },
              )
            : null,
      ),
    );
  }

  void _showSignUpSuggestion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Account Not Found'),
          content: const Text(
            'It looks like you don\'t have an account with this email. Would you like to create one?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isSignUp = true;
                });
              },
              child: const Text('Sign Up'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final availableHeight = screenHeight - safeAreaTop - safeAreaBottom;

    // Debug prints
    print(
      'AuthPage build - _showEmailForm: $_showEmailForm, _isSignUp: $_isSignUp',
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final hasEmailForm = _showEmailForm && (_isSignUp != null);

                    return Column(
                      children: [
                        // Header section - adaptive based on content
                        Expanded(
                          flex: hasEmailForm ? 2 : 3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 16.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // App Logo - smaller when showing email form
                                Container(
                                  width: hasEmailForm ? 80 : 100,
                                  height: hasEmailForm ? 80 : 100,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(
                                      hasEmailForm ? 20 : 25,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.colorScheme.primary
                                            .withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      hasEmailForm ? 20 : 25,
                                    ),
                                    child: Image.asset(
                                      'assets/images/jarwik_logo.png',
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Icon(
                                              Icons.mic,
                                              size: hasEmailForm ? 40 : 50,
                                              color:
                                                  theme.colorScheme.onPrimary,
                                            );
                                          },
                                    ),
                                  ),
                                ),
                                SizedBox(height: hasEmailForm ? 16 : 24),

                                // App Name - smaller when showing email form
                                Text(
                                  'JARWIK',
                                  style: GoogleFonts.sourceCodePro(
                                    fontSize: hasEmailForm ? 28 : 36,
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.onSurface,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                SizedBox(height: hasEmailForm ? 4 : 8),

                                // Tagline
                                Text(
                                  'AI VOICE ASSISTANT',
                                  style: GoogleFonts.sourceCodePro(
                                    fontSize: hasEmailForm ? 11 : 13,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 1.0,
                                  ),
                                ),

                                // Description - only show when not showing email form
                                if (!hasEmailForm) ...[
                                  const SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      'Manage your emails and calendar hands-free with AI-powered voice commands',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withOpacity(0.6),
                                            height: 1.4,
                                          ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                        // Authentication section
                        Expanded(
                          flex: hasEmailForm ? 4 : 3,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (!_showEmailForm) ...[
                                  // Initial screen - Google and Email buttons
                                  _buildSocialButton(
                                    onPressed: _isLoading
                                        ? null
                                        : _signInWithGoogle,
                                    icon: Icons.login,
                                    label: 'Continue with Google',
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black87,
                                    iconColor: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(height: 16),

                                  // Divider
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: theme.colorScheme.outline
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text(
                                          'or',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.5),
                                              ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: theme.colorScheme.outline
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Email Sign In button
                                  _buildSocialButton(
                                    onPressed: () {
                                      print('Continue with Email clicked');
                                      setState(() => _showEmailForm = true);
                                    },
                                    icon: Icons.email_outlined,
                                    label: 'Continue with Email',
                                    backgroundColor:
                                        theme.colorScheme.surfaceContainer,
                                    textColor: theme.colorScheme.onSurface,
                                    iconColor: theme.colorScheme.primary,
                                  ),
                                ] else if (_isSignUp == null) ...[
                                  // Email choice page (sign in vs sign up)
                                  _buildEmailForm(theme),
                                ] else ...[
                                  // Show credentials form when user has made a choice
                                  _buildCredentialsForm(theme),
                                ],
                              ],
                            ),
                          ),
                        ),

                        // Footer section - compact
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 16.0,
                          ),
                          child: Column(
                            children: [
                              // Terms and privacy
                              Text(
                                'By continuing, you agree to our Terms of Service and Privacy Policy',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.5),
                                  height: 1.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),

                              // Footer text
                              Text(
                                'Secure • Private • Professional',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.4),
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required Color iconColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
        ),
        icon: _isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                ),
              )
            : Icon(icon, color: iconColor),
        label: Text(
          _isLoading ? 'Please wait...' : label,
          style: GoogleFonts.sourceCodePro(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button and title
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() {
                _showEmailForm = false;
                _isSignUp = null; // Reset choice when going back
              }),
              icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
            ),
            Text(
              'Email Authentication',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Welcome message
        Text(
          'Welcome to Jarwik',
          style: GoogleFonts.sourceCodePro(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Choose how you\'d like to continue',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),

        const SizedBox(height: 20),

        // Sign In Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => setState(() => _isSignUp = false),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'I have an account - Sign In',
              style: GoogleFonts.sourceCodePro(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Sign Up Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () => setState(() => _isSignUp = true),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              side: BorderSide(color: theme.colorScheme.primary, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'I\'m new here - Sign Up',
              style: GoogleFonts.sourceCodePro(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Info card for new users - more compact
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Sign up to manage emails and calendar with AI voice commands.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCredentialsForm(ThemeData theme) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button and title
          Row(
            children: [
              IconButton(
                onPressed: () => setState(() => _isSignUp = null),
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                (_isSignUp == true) ? 'Create Account' : 'Sign In',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Email field
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),

          const SizedBox(height: 12),

          // Password field
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Info section - more compact
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (_isSignUp == true)
                  ? theme.colorScheme.primaryContainer.withOpacity(0.3)
                  : theme.colorScheme.surfaceContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: (_isSignUp == true)
                    ? theme.colorScheme.primary.withOpacity(0.3)
                    : theme.colorScheme.outline.withOpacity(0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  (_isSignUp == true) ? Icons.info_outline : Icons.login,
                  color: (_isSignUp == true)
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.7),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    (_isSignUp == true)
                        ? 'You\'ll receive a verification email after signing up.'
                        : 'New user? Create an account using the link below.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _signInWithEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                elevation: 2,
                shadowColor: theme.colorScheme.primary.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      (_isSignUp == true) ? 'Create Account' : 'Sign In',
                      style: GoogleFonts.sourceCodePro(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 12),

          // Toggle sign up / sign in
          Center(
            child: TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      setState(
                        () => _isSignUp = (_isSignUp == true) ? false : true,
                      );
                    },
              child: Text(
                (_isSignUp == true)
                    ? 'Already have an account? Sign In'
                    : 'Don\'t have an account? Sign Up',
                style: GoogleFonts.sourceCodePro(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
