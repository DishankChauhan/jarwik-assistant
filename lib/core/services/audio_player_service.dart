import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Audio player service provider
final audioPlayerServiceProvider = Provider<AudioPlayerService>((ref) {
  return AudioPlayerService();
});

enum AudioPlayerState { stopped, playing, paused, loading }

class AudioPlayerService extends ChangeNotifier {
  late final AudioPlayer _audioPlayer;
  AudioPlayerState _state = AudioPlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _volume = 1.0;

  AudioPlayerService() {
    _audioPlayer = AudioPlayer();
    _initializePlayer();
  }

  // Getters
  AudioPlayerState get state => _state;
  Duration get duration => _duration;
  Duration get position => _position;
  double get volume => _volume;
  bool get isPlaying => _state == AudioPlayerState.playing;
  bool get isPaused => _state == AudioPlayerState.paused;
  bool get isLoading => _state == AudioPlayerState.loading;

  void _initializePlayer() {
    // Listen to player state changes
    _audioPlayer.onPlayerStateChanged.listen((PlayerState playerState) {
      switch (playerState) {
        case PlayerState.playing:
          _state = AudioPlayerState.playing;
          break;
        case PlayerState.paused:
          _state = AudioPlayerState.paused;
          break;
        case PlayerState.stopped:
        case PlayerState.completed:
          _state = AudioPlayerState.stopped;
          _position = Duration.zero;
          break;
        case PlayerState.disposed:
          _state = AudioPlayerState.stopped;
          break;
      }
      notifyListeners();
    });

    // Listen to duration changes
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      _duration = duration;
      notifyListeners();
    });

    // Listen to position changes
    _audioPlayer.onPositionChanged.listen((Duration position) {
      _position = position;
      notifyListeners();
    });
  }

  /// Play audio from bytes data (ElevenLabs generated audio)
  Future<void> playFromBytes(Uint8List audioBytes) async {
    try {
      _state = AudioPlayerState.loading;
      notifyListeners();

      // Save bytes to temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/temp_audio_${DateTime.now().millisecondsSinceEpoch}.mp3',
      );
      await tempFile.writeAsBytes(audioBytes);

      // Play the temporary file
      await _audioPlayer.play(DeviceFileSource(tempFile.path));

      // Clean up temp file after playing
      tempFile.deleteSync();
    } catch (e) {
      if (kDebugMode) {
        print('Audio playback error: $e');
      }
      _state = AudioPlayerState.stopped;
      notifyListeners();
      throw Exception('Failed to play audio: $e');
    }
  }

  /// Play audio from URL
  Future<void> playFromUrl(String url) async {
    try {
      _state = AudioPlayerState.loading;
      notifyListeners();

      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      if (kDebugMode) {
        print('Audio playback error: $e');
      }
      _state = AudioPlayerState.stopped;
      notifyListeners();
      throw Exception('Failed to play audio from URL: $e');
    }
  }

  /// Play audio from asset
  Future<void> playFromAsset(String assetPath) async {
    try {
      _state = AudioPlayerState.loading;
      notifyListeners();

      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      if (kDebugMode) {
        print('Audio playback error: $e');
      }
      _state = AudioPlayerState.stopped;
      notifyListeners();
      throw Exception('Failed to play audio from asset: $e');
    }
  }

  /// Pause audio playback
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      if (kDebugMode) {
        print('Audio pause error: $e');
      }
    }
  }

  /// Resume audio playback
  Future<void> resume() async {
    try {
      await _audioPlayer.resume();
    } catch (e) {
      if (kDebugMode) {
        print('Audio resume error: $e');
      }
    }
  }

  /// Stop audio playback
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _position = Duration.zero;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Audio stop error: $e');
      }
    }
  }

  /// Seek to position
  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      if (kDebugMode) {
        print('Audio seek error: $e');
      }
    }
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      _volume = volume.clamp(0.0, 1.0);
      await _audioPlayer.setVolume(_volume);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Audio volume error: $e');
      }
    }
  }

  /// Set playback rate
  Future<void> setPlaybackRate(double rate) async {
    try {
      await _audioPlayer.setPlaybackRate(rate);
    } catch (e) {
      if (kDebugMode) {
        print('Audio playback rate error: $e');
      }
    }
  }

  /// Get position as percentage of duration
  double get positionPercentage {
    if (duration.inMilliseconds == 0) return 0.0;
    return position.inMilliseconds / duration.inMilliseconds;
  }

  /// Format duration for display
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

/// Provider for audio player state
final audioPlayerStateProvider = ChangeNotifierProvider<AudioPlayerService>((
  ref,
) {
  return ref.watch(audioPlayerServiceProvider);
});
