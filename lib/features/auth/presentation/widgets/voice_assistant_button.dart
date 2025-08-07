import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class VoiceAssistantButton extends ConsumerStatefulWidget {
  const VoiceAssistantButton({super.key});

  @override
  ConsumerState<VoiceAssistantButton> createState() =>
      _VoiceAssistantButtonState();
}

class _VoiceAssistantButtonState extends ConsumerState<VoiceAssistantButton> {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  bool _speechEnabled = false;
  String _wordsSpoken = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initTts();
  }

  void _initSpeech() async {
    _speech = stt.SpeechToText();
    _speechEnabled = await _speech.initialize();
    setState(() {});
  }

  void _initTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  void _startListening() async {
    if (_speechEnabled && !_isListening) {
      await _speech.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: "en_US",
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
      );
      setState(() {
        _isListening = true;
        _wordsSpoken = '';
      });
    }
  }

  void _stopListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() {
        _isListening = false;
      });

      // Process the voice command
      if (_wordsSpoken.isNotEmpty) {
        _processVoiceCommand(_wordsSpoken);
      }
    }
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = result.recognizedWords;
    });
  }

  void _processVoiceCommand(String command) async {
    // Basic AI response simulation
    String response = _generateAIResponse(command.toLowerCase());

    // Speak the response
    await _flutterTts.speak(response);

    // Show response in a dialog or snackbar
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You: $command',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text('Jarwik: $response'),
            ],
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  String _generateAIResponse(String command) {
    if (command.contains('hello') || command.contains('hi')) {
      return 'Hello! I\'m Jarwik, your AI voice assistant. How can I help you today?';
    } else if (command.contains('email')) {
      return 'I can help you manage your emails. Once connected, I can read, summarize, and help you reply to emails.';
    } else if (command.contains('calendar')) {
      return 'I can assist with your calendar. I can schedule meetings, check your availability, and remind you of appointments.';
    } else if (command.contains('weather')) {
      return 'Weather integration is coming soon! I\'ll be able to give you weather updates.';
    } else if (command.contains('thank')) {
      return 'You\'re welcome! I\'m here whenever you need assistance.';
    } else {
      return 'I understand you said: $command. I\'m still learning and will have more capabilities soon!';
    }
  }

  @override
  void dispose() {
    _speech.cancel();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Voice status text
        if (_wordsSpoken.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _wordsSpoken,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),

        // Voice button
        AvatarGlow(
          animate: _isListening,
          glowColor: Theme.of(context).colorScheme.primary,
          child: GestureDetector(
            onTap: _speechEnabled
                ? (_isListening ? _stopListening : _startListening)
                : null,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _isListening
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color:
                        (_isListening
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).colorScheme.primary)
                            .withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Status text
        Text(
          _isListening
              ? 'Listening... Tap to stop'
              : (_speechEnabled ? 'Tap to speak' : 'Speech not available'),
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),

        if (_isListening)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Try saying: "Hello", "Check my emails", or "Schedule a meeting"',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
