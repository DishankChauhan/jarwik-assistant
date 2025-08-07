import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'elevenlabs_service.dart';
import 'audio_player_service.dart';
import 'speech_to_text_service.dart';

/// Voice assistant service provider
final voiceAssistantServiceProvider = Provider<VoiceAssistantService>((ref) {
  final elevenLabs = ref.watch(elevenLabsServiceProvider);
  final audioPlayer = ref.watch(audioPlayerServiceProvider);
  final speechToText = ref.watch(speechToTextServiceProvider);

  return VoiceAssistantService(
    elevenLabs: elevenLabs,
    audioPlayer: audioPlayer,
    speechToText: speechToText,
  );
});

enum VoiceAssistantState { idle, listening, processing, speaking, error }

class VoiceAssistantService extends ChangeNotifier {
  final ElevenLabsService _elevenLabs;
  final AudioPlayerService _audioPlayer;
  final SpeechToTextService _speechToText;

  VoiceAssistantState _state = VoiceAssistantState.idle;
  String _currentResponse = '';
  String _lastUserInput = '';
  String _errorMessage = '';

  // Voice settings
  String _selectedVoice = ElevenLabsService.voices['rachel']!;
  double _speechRate = 1.0;
  double _volume = 0.8;

  VoiceAssistantService({
    required ElevenLabsService elevenLabs,
    required AudioPlayerService audioPlayer,
    required SpeechToTextService speechToText,
  }) : _elevenLabs = elevenLabs,
       _audioPlayer = audioPlayer,
       _speechToText = speechToText {
    _setupListeners();
  }

  // Getters
  VoiceAssistantState get state => _state;
  String get currentResponse => _currentResponse;
  String get lastUserInput => _lastUserInput;
  String get errorMessage => _errorMessage;
  String get selectedVoice => _selectedVoice;
  double get speechRate => _speechRate;
  double get volume => _volume;
  bool get isIdle => _state == VoiceAssistantState.idle;
  bool get isListening => _state == VoiceAssistantState.listening;
  bool get isProcessing => _state == VoiceAssistantState.processing;
  bool get isSpeaking => _state == VoiceAssistantState.speaking;

  void _setupListeners() {
    // Listen to speech-to-text changes
    _speechToText.addListener(() {
      if (_speechToText.state == SpeechState.ready &&
          _speechToText.lastRecognizedText.isNotEmpty &&
          _state == VoiceAssistantState.listening) {
        _processUserInput(_speechToText.lastRecognizedText);
      }
    });

    // Listen to audio player changes
    _audioPlayer.addListener(() {
      if (_audioPlayer.state == AudioPlayerState.stopped &&
          _state == VoiceAssistantState.speaking) {
        _setState(VoiceAssistantState.idle);
      }
    });
  }

  void _setState(VoiceAssistantState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Start listening for user input
  Future<void> startListening() async {
    try {
      _errorMessage = '';
      _setState(VoiceAssistantState.listening);

      // Stop any current audio playback
      if (_audioPlayer.isPlaying) {
        await _audioPlayer.stop();
      }

      await _speechToText.startListening(
        listenTimeout: const Duration(seconds: 10),
        pauseTimeout: const Duration(seconds: 2),
      );
    } catch (e) {
      _handleError('Failed to start listening: $e');
    }
  }

  /// Stop listening for user input
  Future<void> stopListening() async {
    try {
      await _speechToText.stopListening();
      if (_speechToText.lastRecognizedText.isNotEmpty) {
        _processUserInput(_speechToText.lastRecognizedText);
      } else {
        _setState(VoiceAssistantState.idle);
      }
    } catch (e) {
      _handleError('Failed to stop listening: $e');
    }
  }

  /// Process user input and generate response
  Future<void> _processUserInput(String userInput) async {
    try {
      _lastUserInput = userInput;
      _setState(VoiceAssistantState.processing);

      // Generate AI response based on user input
      final response = await _generateAIResponse(userInput);
      _currentResponse = response;

      // Convert response to speech
      await _speakResponse(response);
    } catch (e) {
      _handleError('Failed to process input: $e');
    }
  }

  /// Generate AI response (simplified for now)
  Future<String> _generateAIResponse(String userInput) async {
    // This is a simplified response generator
    // In a real implementation, you would integrate with OpenAI, Claude, or another AI service

    final input = userInput.toLowerCase();

    if (input.contains('hello') || input.contains('hi')) {
      return 'Hello! I\'m Jarwik, your AI voice assistant. How can I help you today?';
    } else if (input.contains('email')) {
      return 'I can help you manage your emails. Would you like me to read your latest emails or compose a new one?';
    } else if (input.contains('calendar')) {
      return 'I can assist with your calendar. Would you like to check your schedule or create a new appointment?';
    } else if (input.contains('weather')) {
      return 'I can help you with weather information. Let me check the current weather for your location.';
    } else if (input.contains('time')) {
      final now = DateTime.now();
      return 'The current time is ${now.hour}:${now.minute.toString().padLeft(2, '0')}.';
    } else if (input.contains('thank')) {
      return 'You\'re welcome! I\'m here to help whenever you need assistance.';
    } else if (input.contains('goodbye') || input.contains('bye')) {
      return 'Goodbye! Have a great day and feel free to ask for help anytime.';
    } else {
      return 'I understand you said: "$userInput". I\'m still learning to help with various tasks. Is there something specific you\'d like me to assist you with?';
    }
  }

  /// Convert text to speech and play it
  Future<void> _speakResponse(String text) async {
    try {
      _setState(VoiceAssistantState.speaking);

      // Generate audio from ElevenLabs
      final audioData = await _elevenLabs.textToSpeech(
        text: text,
        voiceId: _selectedVoice,
        stability: 0.5,
        similarityBoost: 0.75,
      );

      // Play the generated audio
      await _audioPlayer.setVolume(_volume);
      await _audioPlayer.setPlaybackRate(_speechRate);
      await _audioPlayer.playFromBytes(audioData);
    } catch (e) {
      _handleError('Failed to speak response: $e');
    }
  }

  /// Speak a custom message
  Future<void> speakText(String text) async {
    try {
      _currentResponse = text;
      await _speakResponse(text);
    } catch (e) {
      _handleError('Failed to speak text: $e');
    }
  }

  /// Stop current speech
  Future<void> stopSpeaking() async {
    try {
      await _audioPlayer.stop();
      _setState(VoiceAssistantState.idle);
    } catch (e) {
      _handleError('Failed to stop speaking: $e');
    }
  }

  /// Set voice settings
  void setVoice(String voiceId) {
    if (ElevenLabsService.voices.containsValue(voiceId)) {
      _selectedVoice = voiceId;
      notifyListeners();
    }
  }

  void setSpeechRate(double rate) {
    _speechRate = rate.clamp(0.5, 2.0);
    notifyListeners();
  }

  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
    notifyListeners();
  }

  /// Handle errors
  void _handleError(String error) {
    _errorMessage = error;
    _setState(VoiceAssistantState.error);

    if (kDebugMode) {
      print('Voice Assistant Error: $error');
    }
  }

  /// Clear error state
  void clearError() {
    _errorMessage = '';
    _setState(VoiceAssistantState.idle);
  }

  /// Get voice options for UI
  Map<String, String> get voiceOptions {
    return ElevenLabsService.voices.map(
      (key, value) => MapEntry(value, key.replaceAll('_', ' ').toUpperCase()),
    );
  }

  /// Quick conversation starters
  List<String> get conversationStarters => [
    'Hello Jarwik',
    'Read my emails',
    'Check my calendar',
    'What\'s the weather?',
    'What time is it?',
  ];

  @override
  void dispose() {
    _speechToText.removeListener(() {});
    _audioPlayer.removeListener(() {});
    super.dispose();
  }
}

/// Provider for voice assistant state
final voiceAssistantStateProvider =
    ChangeNotifierProvider<VoiceAssistantService>((ref) {
      return ref.watch(voiceAssistantServiceProvider);
    });
