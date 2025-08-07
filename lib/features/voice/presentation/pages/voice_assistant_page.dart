import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:avatar_glow/avatar_glow.dart';
import '../../../../core/services/voice_assistant_service.dart';

class VoiceAssistantPage extends ConsumerStatefulWidget {
  const VoiceAssistantPage({super.key});

  @override
  ConsumerState<VoiceAssistantPage> createState() => _VoiceAssistantPageState();
}

class _VoiceAssistantPageState extends ConsumerState<VoiceAssistantPage>
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
    final voiceAssistant = ref.watch(voiceAssistantStateProvider);
    final theme = Theme.of(context);

    // Trigger response animation when speaking
    if (voiceAssistant.isSpeaking && !_responseController.isAnimating) {
      _responseController.forward();
    } else if (!voiceAssistant.isSpeaking) {
      _responseController.reverse();
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Jarwik Assistant',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () => _showSettingsDialog(context, voiceAssistant),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status Display
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Voice Visual Feedback
                    _buildVoiceVisual(voiceAssistant, theme),

                    const SizedBox(height: 40),

                    // Status Text
                    _buildStatusText(voiceAssistant, theme),

                    const SizedBox(height: 24),

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

            // Controls
            _buildControls(voiceAssistant, theme),

            // Quick Actions
            _buildQuickActions(voiceAssistant, theme),
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
        return Transform.scale(
          scale: voiceAssistant.isListening ? _pulseAnimation.value : 1.0,
          child: AvatarGlow(
            animate: voiceAssistant.isListening,
            glowColor: theme.colorScheme.primary,
            duration: const Duration(milliseconds: 2000),
            repeat: true,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                _getVoiceIcon(voiceAssistant),
                size: 60,
                color: Colors.white,
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
    Color textColor = theme.colorScheme.onSurface;

    switch (voiceAssistant.state) {
      case VoiceAssistantState.listening:
        statusText = 'Listening...';
        textColor = theme.colorScheme.primary;
        break;
      case VoiceAssistantState.processing:
        statusText = 'Processing...';
        textColor = theme.colorScheme.secondary;
        break;
      case VoiceAssistantState.speaking:
        statusText = 'Speaking...';
        textColor = theme.colorScheme.tertiary;
        break;
      case VoiceAssistantState.error:
        statusText = 'Error occurred';
        textColor = theme.colorScheme.error;
        break;
      default:
        statusText = 'Tap to speak';
    }

    return Text(
      statusText,
      style: theme.textTheme.headlineSmall?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
        ),
        child: Text(
          voiceAssistant.currentResponse,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            height: 1.5,
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
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              voiceAssistant.errorMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          TextButton(
            onPressed: voiceAssistant.clearError,
            child: Text(
              'Retry',
              style: TextStyle(
                color: theme.colorScheme.onErrorContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(VoiceAssistantService voiceAssistant, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Stop Speaking
          if (voiceAssistant.isSpeaking)
            FloatingActionButton(
              onPressed: voiceAssistant.stopSpeaking,
              backgroundColor: theme.colorScheme.error,
              child: const Icon(Icons.stop, color: Colors.white),
            ),

          const SizedBox(width: 20),

          // Main Action Button
          FloatingActionButton.extended(
            onPressed: _handleMainAction(voiceAssistant),
            backgroundColor: _getMainButtonColor(voiceAssistant, theme),
            icon: Icon(_getMainButtonIcon(voiceAssistant), color: Colors.white),
            label: Text(
              _getMainButtonText(voiceAssistant),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  VoidCallback? _handleMainAction(VoiceAssistantService voiceAssistant) {
    switch (voiceAssistant.state) {
      case VoiceAssistantState.idle:
      case VoiceAssistantState.error:
        return voiceAssistant.startListening;
      case VoiceAssistantState.listening:
        return voiceAssistant.stopListening;
      default:
        return null;
    }
  }

  Color _getMainButtonColor(
    VoiceAssistantService voiceAssistant,
    ThemeData theme,
  ) {
    switch (voiceAssistant.state) {
      case VoiceAssistantState.listening:
        return theme.colorScheme.primary;
      case VoiceAssistantState.error:
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.primary;
    }
  }

  IconData _getMainButtonIcon(VoiceAssistantService voiceAssistant) {
    switch (voiceAssistant.state) {
      case VoiceAssistantState.listening:
        return Icons.stop;
      case VoiceAssistantState.processing:
      case VoiceAssistantState.speaking:
        return Icons.hourglass_empty;
      default:
        return Icons.mic;
    }
  }

  String _getMainButtonText(VoiceAssistantService voiceAssistant) {
    switch (voiceAssistant.state) {
      case VoiceAssistantState.listening:
        return 'Stop';
      case VoiceAssistantState.processing:
        return 'Processing';
      case VoiceAssistantState.speaking:
        return 'Speaking';
      default:
        return 'Start';
    }
  }

  Widget _buildQuickActions(
    VoiceAssistantService voiceAssistant,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: voiceAssistant.conversationStarters
                .map(
                  (starter) => ActionChip(
                    label: Text(starter),
                    onPressed: voiceAssistant.isIdle
                        ? () => voiceAssistant.speakText('Processing: $starter')
                        : null,
                    backgroundColor: theme.colorScheme.surfaceContainer,
                    labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(
    BuildContext context,
    VoiceAssistantService voiceAssistant,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Voice Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Voice Selection
            ListTile(
              title: const Text('Voice'),
              subtitle: DropdownButton<String>(
                value: voiceAssistant.selectedVoice,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    voiceAssistant.setVoice(newValue);
                  }
                },
                items: voiceAssistant.voiceOptions.entries
                    .map<DropdownMenuItem<String>>((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    })
                    .toList(),
              ),
            ),

            // Speech Rate
            ListTile(
              title: const Text('Speech Rate'),
              subtitle: Slider(
                value: voiceAssistant.speechRate,
                min: 0.5,
                max: 2.0,
                divisions: 6,
                label: '${voiceAssistant.speechRate.toStringAsFixed(1)}x',
                onChanged: voiceAssistant.setSpeechRate,
              ),
            ),

            // Volume
            ListTile(
              title: const Text('Volume'),
              subtitle: Slider(
                value: voiceAssistant.volume,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                label: '${(voiceAssistant.volume * 100).toInt()}%',
                onChanged: voiceAssistant.setVolume,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
