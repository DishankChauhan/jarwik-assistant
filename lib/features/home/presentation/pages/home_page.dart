import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:avatar_glow/avatar_glow.dart';
import '../../../../core/services/voice_assistant_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'settings_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _responseController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _responseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _responseController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _responseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _responseController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _responseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final voiceAssistant = ref.watch(voiceAssistantStateProvider);

    // Trigger response animation when speaking
    if (voiceAssistant.isSpeaking && !_responseController.isAnimating) {
      _responseController.forward();
    } else if (!voiceAssistant.isSpeaking) {
      _responseController.reverse();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Jarwik Assistant',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        actions: [
          // Settings button
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: Colors.white.withOpacity(0.8),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          // User profile
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage:
                  authState.user?.userMetadata?['avatar_url'] != null
                  ? NetworkImage(authState.user!.userMetadata!['avatar_url'])
                  : null,
              backgroundColor: const Color(0xFFFFD700), // Gold color
              child: authState.user?.userMetadata?['avatar_url'] == null
                  ? Text(
                      authState.user?.userMetadata?['full_name']
                              ?.substring(0, 1)
                              .toUpperCase() ??
                          authState.user?.email
                              ?.substring(0, 1)
                              .toUpperCase() ??
                          'U',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Main Voice Assistant Interface
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Voice Visual Feedback - Golden Circle
                    _buildVoiceVisual(voiceAssistant, theme),

                    const SizedBox(height: 40),

                    // Status Text - "Tap to speak"
                    _buildStatusText(voiceAssistant, theme),

                    const SizedBox(height: 60),

                    // Response Text
                    if (voiceAssistant.currentResponse.isNotEmpty)
                      _buildResponseText(voiceAssistant, theme),

                    // Error Message
                    if (voiceAssistant.state == VoiceAssistantState.error)
                      _buildErrorMessage(voiceAssistant, theme),
                  ],
                ),
              ),
            ),

            // Quick Actions - Bottom buttons
            _buildQuickActions(voiceAssistant, theme),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceVisual(
    VoiceAssistantService voiceAssistant,
    ThemeData theme,
  ) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (voiceAssistant.isIdle) {
              voiceAssistant.startListening();
            } else if (voiceAssistant.isListening) {
              voiceAssistant.stopListening();
            }
          },
          child: Transform.scale(
            scale: voiceAssistant.isListening ? _pulseAnimation.value : 1.0,
            child: AvatarGlow(
              animate: voiceAssistant.isListening,
              glowColor: const Color(0xFFFFD700), // Gold color
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFD700), // Gold
                      Color(0xFFFFA500), // Orange
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Icon(
                  _getVoiceIcon(voiceAssistant),
                  size: 80,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getVoiceIcon(VoiceAssistantService voiceAssistant) {
    switch (voiceAssistant.state) {
      case VoiceAssistantState.listening:
        return Icons.mic;
      case VoiceAssistantState.processing:
        return Icons.psychology_outlined;
      case VoiceAssistantState.speaking:
        return Icons.volume_up_outlined;
      case VoiceAssistantState.error:
        return Icons.error_outline;
      default:
        return Icons.mic_none_outlined;
    }
  }

  Widget _buildStatusText(
    VoiceAssistantService voiceAssistant,
    ThemeData theme,
  ) {
    String statusText;
    Color textColor = Colors.white;

    switch (voiceAssistant.state) {
      case VoiceAssistantState.listening:
        statusText = 'Listening...';
        textColor = const Color(0xFFFFD700); // Gold
        break;
      case VoiceAssistantState.processing:
        statusText = 'Processing...';
        textColor = Colors.orange;
        break;
      case VoiceAssistantState.speaking:
        statusText = 'Speaking...';
        textColor = Colors.green;
        break;
      case VoiceAssistantState.error:
        statusText = 'Error occurred';
        textColor = Colors.red;
        break;
      default:
        statusText = 'Tap to speak';
    }

    return Text(
      statusText,
      style: theme.textTheme.headlineSmall?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
        fontSize: 24,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildResponseText(
    VoiceAssistantService voiceAssistant,
    ThemeData theme,
  ) {
    return AnimatedBuilder(
      animation: _responseAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[700]!, width: 1),
        ),
        child: Text(
          voiceAssistant.currentResponse,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            height: 1.5,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      builder: (context, child) {
        return Transform.scale(
          scale: _responseAnimation.value,
          child: Opacity(opacity: _responseAnimation.value, child: child),
        );
      },
    );
  }

  Widget _buildErrorMessage(
    VoiceAssistantService voiceAssistant,
    ThemeData theme,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              voiceAssistant.errorMessage,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: voiceAssistant.clearError,
            child: const Text(
              'Retry',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(
    VoiceAssistantService voiceAssistant,
    ThemeData theme,
  ) {
    final quickActions = [
      {'text': 'Hello Jarwik', 'icon': Icons.waving_hand},
      {'text': 'Read my emails', 'icon': Icons.email},
      {'text': 'Check my calendar', 'icon': Icons.calendar_today},
      {'text': 'What\'s the weather?', 'icon': Icons.wb_sunny},
      {'text': 'What time is it?', 'icon': Icons.access_time},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: quickActions
                .map(
                  (action) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey[700]!, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          action['icon'] as IconData,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          action['text'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
