import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Speech-to-text service provider
final speechToTextServiceProvider = Provider<SpeechToTextService>((ref) {
  return SpeechToTextService();
});

enum SpeechState { notInitialized, ready, listening, error, noPermission }

class SpeechToTextService extends ChangeNotifier {
  late SpeechToText _speech;
  SpeechState _state = SpeechState.notInitialized;
  String _lastRecognizedText = '';
  String _currentRecognizedText = '';
  bool _isInitialized = false;
  List<LocaleName> _availableLocales = [];
  String _currentLocale = 'en_US';
  double _confidence = 0.0;

  // Getters
  SpeechState get state => _state;
  String get lastRecognizedText => _lastRecognizedText;
  String get currentRecognizedText => _currentRecognizedText;
  bool get isInitialized => _isInitialized;
  bool get isListening => _state == SpeechState.listening;
  List<LocaleName> get availableLocales => _availableLocales;
  String get currentLocale => _currentLocale;
  double get confidence => _confidence;

  SpeechToTextService() {
    _speech = SpeechToText();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    try {
      // Check and request microphone permission
      final permission = await Permission.microphone.request();
      if (permission != PermissionStatus.granted) {
        _state = SpeechState.noPermission;
        notifyListeners();
        return;
      }

      // Initialize speech recognition
      final bool available = await _speech.initialize(
        onStatus: _onSpeechStatus,
        onError: _onSpeechError,
      );

      if (available) {
        _isInitialized = true;
        _state = SpeechState.ready;

        // Get available locales
        _availableLocales = await _speech.locales();

        // Set default locale if available
        if (_availableLocales.isNotEmpty) {
          final enLocale = _availableLocales.firstWhere(
            (locale) => locale.localeId.startsWith('en_'),
            orElse: () => _availableLocales.first,
          );
          _currentLocale = enLocale.localeId;
        }
      } else {
        _state = SpeechState.error;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Speech initialization error: $e');
      }
      _state = SpeechState.error;
    }

    notifyListeners();
  }

  void _onSpeechStatus(String status) {
    if (kDebugMode) {
      print('Speech status: $status');
    }

    switch (status) {
      case 'listening':
        _state = SpeechState.listening;
        break;
      case 'done':
      case 'notListening':
        if (_state == SpeechState.listening) {
          _state = SpeechState.ready;
          _lastRecognizedText = _currentRecognizedText;
        }
        break;
    }

    notifyListeners();
  }

  void _onSpeechError(dynamic error) {
    if (kDebugMode) {
      print('Speech error: $error');
    }

    _state = SpeechState.error;
    notifyListeners();
  }

  /// Start listening for speech input
  Future<void> startListening({
    String? locale,
    Duration? listenTimeout,
    Duration? pauseTimeout,
  }) async {
    if (!_isInitialized) {
      await _initializeSpeech();
      if (!_isInitialized) return;
    }

    if (_speech.isListening) {
      await stopListening();
    }

    try {
      _currentRecognizedText = '';
      _confidence = 0.0;

      await _speech.listen(
        onResult: _onSpeechResult,
        localeId: locale ?? _currentLocale,
        listenFor: listenTimeout ?? const Duration(seconds: 30),
        pauseFor: pauseTimeout ?? const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: false,
      );

      _state = SpeechState.listening;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Start listening error: $e');
      }
      _state = SpeechState.error;
      notifyListeners();
    }
  }

  void _onSpeechResult(result) {
    _currentRecognizedText = result.recognizedWords;
    _confidence = result.confidence;

    if (result.finalResult) {
      _lastRecognizedText = _currentRecognizedText;
      _state = SpeechState.ready;
    }

    notifyListeners();
  }

  /// Stop listening for speech input
  Future<void> stopListening() async {
    if (_speech.isListening) {
      try {
        await _speech.stop();
        _lastRecognizedText = _currentRecognizedText;
        _state = SpeechState.ready;
        notifyListeners();
      } catch (e) {
        if (kDebugMode) {
          print('Stop listening error: $e');
        }
      }
    }
  }

  /// Cancel current listening session
  Future<void> cancelListening() async {
    if (_speech.isListening) {
      try {
        await _speech.cancel();
        _currentRecognizedText = '';
        _confidence = 0.0;
        _state = SpeechState.ready;
        notifyListeners();
      } catch (e) {
        if (kDebugMode) {
          print('Cancel listening error: $e');
        }
      }
    }
  }

  /// Set the locale for speech recognition
  void setLocale(String localeId) {
    if (_availableLocales.any((locale) => locale.localeId == localeId)) {
      _currentLocale = localeId;
      notifyListeners();
    }
  }

  /// Get supported locales as a map
  Map<String, String> get supportedLocalesMap {
    final map = <String, String>{};
    for (final locale in _availableLocales) {
      map[locale.localeId] = locale.name;
    }
    return map;
  }

  /// Check if speech recognition is available
  Future<bool> checkAvailability() async {
    return await _speech.hasPermission;
  }

  /// Request microphone permission
  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      if (!_isInitialized) {
        await _initializeSpeech();
      }
      return true;
    }
    return false;
  }

  /// Clear recognized text
  void clearText() {
    _lastRecognizedText = '';
    _currentRecognizedText = '';
    _confidence = 0.0;
    notifyListeners();
  }

  @override
  void dispose() {
    if (_speech.isListening) {
      _speech.stop();
    }
    super.dispose();
  }
}

/// Provider for speech-to-text state
final speechToTextStateProvider = ChangeNotifierProvider<SpeechToTextService>((
  ref,
) {
  return ref.watch(speechToTextServiceProvider);
});
