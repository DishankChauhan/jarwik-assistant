import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/voice_assistant_button.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();

    // Navigate to onboarding after animation
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _navigateToOnboarding();
      }
    });
  }

  void _navigateToOnboarding() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const OnboardingPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
<<<<<<< HEAD
                    // App Icon/Logo
=======
                    // App Logo
>>>>>>> 9b168b8 (pushed other files)
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
<<<<<<< HEAD
                            color: Colors.black.withOpacity(0.1),
=======
                            color: Colors.white.withOpacity(0.2),
>>>>>>> 9b168b8 (pushed other files)
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
<<<<<<< HEAD
                      child: const Icon(
                        Icons.mic,
                        size: 60,
                        color: Color(0xFF6366F1),
=======
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          'assets/images/jarwik_logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.mic,
                              size: 60,
                              color: Color(0xFF000000),
                            );
                          },
                        ),
>>>>>>> 9b168b8 (pushed other files)
                      ),
                    ),
                    const SizedBox(height: 32),

                    // App Name
                    Text(
<<<<<<< HEAD
                      'Jarwik',
                      style: GoogleFonts.inter(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
=======
                      'JARWIK',
                      style: GoogleFonts.sourceCodePro(
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 2.0,
>>>>>>> 9b168b8 (pushed other files)
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tagline
                    Text(
<<<<<<< HEAD
                      'Your AI Voice Assistant',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w400,
=======
                      'AI VOICE ASSISTANT',
                      style: GoogleFonts.sourceCodePro(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.2,
>>>>>>> 9b168b8 (pushed other files)
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Loading indicator
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.8),
                        ),
                        strokeWidth: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Placeholder Onboarding Page
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.mic, size: 100, color: Color(0xFF6366F1)),
              const SizedBox(height: 32),
              Text(
                'Welcome to Jarwik',
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Manage your emails and calendar hands-free with AI-powered voice commands.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Voice Assistant Demo Button
              const VoiceAssistantButton(),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  child: const Text('Get Started'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder Home Page
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jarwik Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.account_circle), onPressed: () {}),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Color(0xFF6366F1)),
            SizedBox(height: 16),
            Text(
              'MVP Under Construction',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Core features coming soon...',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),
<<<<<<< HEAD
            const VoiceAssistantButton(),
=======
            VoiceAssistantButton(),
>>>>>>> 9b168b8 (pushed other files)
          ],
        ),
      ),
    );
  }
}
