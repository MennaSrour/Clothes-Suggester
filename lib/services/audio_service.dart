import 'package:audioplayers/audioplayers.dart';

/// Service class for handling audio playback
/// Uses the audioplayers package
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _currentAudioPath;

  /// Get the current playing state
  bool get isPlaying => _isPlaying;

  /// Get the current audio path
  String? get currentAudioPath => _currentAudioPath;

  /// Initialize the audio service
  Future<void> initialize() async {
    // Listen to player state changes
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      _isPlaying = state == PlayerState.playing;
    });

    // Listen to player completion
    _audioPlayer.onPlayerComplete.listen((event) {
      _isPlaying = false;
      _currentAudioPath = null;
    });
  }

  /// Play audio from an asset file
  /// Example: 'assets/audio/zikr1.mp3'
  Future<void> playFromAsset(String assetPath) async {
    try {
      await stop(); // Stop any currently playing audio
      _currentAudioPath = assetPath;
      await _audioPlayer.play(AssetSource(assetPath));
      _isPlaying = true;
    } catch (e) {
      print('Error playing audio from asset: $e');
      _isPlaying = false;
      rethrow;
    }
  }

  /// Play audio from a file path
  Future<void> playFromFile(String filePath) async {
    try {
      await stop(); // Stop any currently playing audio
      _currentAudioPath = filePath;
      await _audioPlayer.play(DeviceFileSource(filePath));
      _isPlaying = true;
    } catch (e) {
      print('Error playing audio from file: $e');
      _isPlaying = false;
      rethrow;
    }
  }

  /// Play audio from a URL
  Future<void> playFromUrl(String url) async {
    try {
      await stop(); // Stop any currently playing audio
      _currentAudioPath = url;
      await _audioPlayer.play(UrlSource(url));
      _isPlaying = true;
    } catch (e) {
      print('Error playing audio from URL: $e');
      _isPlaying = false;
      rethrow;
    }
  }

  /// Pause the currently playing audio
  Future<void> pause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      _isPlaying = false;
    }
  }

  /// Resume the paused audio
  Future<void> resume() async {
    if (!_isPlaying && _currentAudioPath != null) {
      await _audioPlayer.resume();
      _isPlaying = true;
    }
  }

  /// Stop the currently playing audio
  Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    _currentAudioPath = null;
  }

  /// Set the volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
  }

  /// Seek to a specific position in the audio
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  /// Get the current position of the audio
  Future<Duration?> getCurrentPosition() async {
    return await _audioPlayer.getCurrentPosition();
  }

  /// Get the total duration of the audio
  Future<Duration?> getDuration() async {
    return await _audioPlayer.getDuration();
  }

  /// Set playback rate (speed)
  /// 1.0 = normal speed, 0.5 = half speed, 2.0 = double speed
  Future<void> setPlaybackRate(double rate) async {
    await _audioPlayer.setPlaybackRate(rate);
  }

  /// Set the release mode (what happens when audio completes)
  Future<void> setReleaseMode(ReleaseMode mode) async {
    await _audioPlayer.setReleaseMode(mode);
  }

  /// Enable/disable looping
  Future<void> setLooping(bool loop) async {
    await _audioPlayer.setReleaseMode(
      loop ? ReleaseMode.loop : ReleaseMode.release,
    );
  }

  /// Dispose the audio player
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }

  /// Stream of player state changes
  Stream<PlayerState> get onPlayerStateChanged =>
      _audioPlayer.onPlayerStateChanged;

  /// Stream of player completion events
  Stream<void> get onPlayerComplete => _audioPlayer.onPlayerComplete;

  /// Stream of position changes
  Stream<Duration> get onPositionChanged => _audioPlayer.onPositionChanged;

  /// Stream of duration changes
  Stream<Duration> get onDurationChanged => _audioPlayer.onDurationChanged;
}
