import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import '../config/app_config.dart';

/// ElevenLabs service provider
final elevenLabsServiceProvider = Provider<ElevenLabsService>((ref) {
  return ElevenLabsService();
});

class ElevenLabsService {
  static const String _baseUrl = 'https://api.elevenlabs.io/v1';

  late final Dio _dio;

  ElevenLabsService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        headers: {
          'Accept': 'audio/mpeg',
          'Content-Type': 'application/json',
          'xi-api-key': AppConfig.elevenLabsApiKey,
        },
      ),
    );
  }

  /// Available voices for text-to-speech
  static const Map<String, String> voices = {
    'rachel': 'EXAVITQu4vr4xnSDxMaL', // Professional female voice
    'drew': 'aZxSHNM1z9KoEhNhPJhQ', // Professional male voice
    'clyde': 'y3yRfzFkdOekZQN1K3m3', // Warm male voice
    'domi': 'xG2ZoIAL4tPzfkZ8H1Y4', // Strong female voice
    'dave': 'jBpfuIE2acCO8z3wKNLl', // Natural male voice
  };

  /// Convert text to speech using ElevenLabs API
  Future<Uint8List> textToSpeech({
    required String text,
    String voiceId = 'EXAVITQu4vr4xnSDxMaL', // Default: Rachel
    double stability = 0.5,
    double similarityBoost = 0.75,
    double style = 0.0,
    bool useSpeakerBoost = true,
  }) async {
    try {
      final response = await _dio.post(
        '/text-to-speech/$voiceId',
        data: {
          'text': text,
          'model_id': 'eleven_monolingual_v1',
          'voice_settings': {
            'stability': stability,
            'similarity_boost': similarityBoost,
            'style': style,
            'use_speaker_boost': useSpeakerBoost,
          },
        },
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);
      } else {
        throw Exception('Failed to generate speech: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('ElevenLabs TTS Error: $e');
      }
      throw Exception('Text-to-speech failed: $e');
    }
  }

  /// Get available voices from ElevenLabs
  Future<List<ElevenLabsVoice>> getAvailableVoices() async {
    try {
      final response = await _dio.get('/voices');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final voicesData = data['voices'] as List<dynamic>;

        return voicesData
            .map((voice) => ElevenLabsVoice.fromJson(voice))
            .toList();
      } else {
        throw Exception('Failed to fetch voices: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('ElevenLabs Voices Error: $e');
      }
      throw Exception('Failed to get voices: $e');
    }
  }

  /// Generate speech with streaming for longer texts
  Future<Stream<Uint8List>> textToSpeechStream({
    required String text,
    String voiceId = 'EXAVITQu4vr4xnSDxMaL',
    double stability = 0.5,
    double similarityBoost = 0.75,
  }) async {
    try {
      final response = await _dio.post(
        '/text-to-speech/$voiceId/stream',
        data: {
          'text': text,
          'model_id': 'eleven_monolingual_v1',
          'voice_settings': {
            'stability': stability,
            'similarity_boost': similarityBoost,
          },
        },
        options: Options(responseType: ResponseType.stream),
      );

      if (response.statusCode == 200) {
        return (response.data as Stream).map(
          (chunk) => Uint8List.fromList(chunk),
        );
      } else {
        throw Exception('Failed to stream speech: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('ElevenLabs Streaming Error: $e');
      }
      throw Exception('Speech streaming failed: $e');
    }
  }

  /// Check API usage and limits
  Future<ElevenLabsUsage> getUsage() async {
    try {
      final response = await _dio.get('/user/subscription');

      if (response.statusCode == 200) {
        return ElevenLabsUsage.fromJson(response.data);
      } else {
        throw Exception('Failed to get usage: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('ElevenLabs Usage Error: $e');
      }
      throw Exception('Failed to get usage: $e');
    }
  }
}

/// ElevenLabs voice model
class ElevenLabsVoice {
  final String voiceId;
  final String name;
  final String? description;
  final String? previewUrl;
  final String category;

  ElevenLabsVoice({
    required this.voiceId,
    required this.name,
    this.description,
    this.previewUrl,
    required this.category,
  });

  factory ElevenLabsVoice.fromJson(Map<String, dynamic> json) {
    return ElevenLabsVoice(
      voiceId: json['voice_id'],
      name: json['name'],
      description: json['description'],
      previewUrl: json['preview_url'],
      category: json['category'] ?? 'generated',
    );
  }
}

/// ElevenLabs usage model
class ElevenLabsUsage {
  final int characterCount;
  final int characterLimit;
  final bool canExtendCharacterLimit;
  final bool canUseInstantVoiceCloning;
  final bool canUseProfessionalVoiceCloning;

  ElevenLabsUsage({
    required this.characterCount,
    required this.characterLimit,
    required this.canExtendCharacterLimit,
    required this.canUseInstantVoiceCloning,
    required this.canUseProfessionalVoiceCloning,
  });

  factory ElevenLabsUsage.fromJson(Map<String, dynamic> json) {
    return ElevenLabsUsage(
      characterCount: json['character_count'] ?? 0,
      characterLimit: json['character_limit'] ?? 0,
      canExtendCharacterLimit: json['can_extend_character_limit'] ?? false,
      canUseInstantVoiceCloning: json['can_use_instant_voice_cloning'] ?? false,
      canUseProfessionalVoiceCloning:
          json['can_use_professional_voice_cloning'] ?? false,
    );
  }

  double get usagePercentage =>
      characterLimit > 0 ? (characterCount / characterLimit) * 100 : 0;
}
