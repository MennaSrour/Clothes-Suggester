import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../models/reward_model.dart';
import '../services/audio_service.dart';
import '../services/reward_service.dart';
import '../services/notification_service.dart';

/// ViewModel for the Task Screen
/// Manages the state and business logic for completing zikr tasks
class TaskViewModel extends ChangeNotifier {
  final AudioService _audioService = AudioService();
  final RewardService _rewardService = RewardService();
  final NotificationService _notificationService = NotificationService();

  TaskModel? _currentTask;
  int _currentCount = 0;
  bool _isPlaying = false;
  bool _isLoading = false;
  String? _error;
  bool _isTaskCompleted = false;

  /// Getters
  TaskModel? get currentTask => _currentTask;
  int get currentCount => _currentCount;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isTaskCompleted => _isTaskCompleted;
  int get remainingCount => (_currentTask?.count ?? 0) - _currentCount;
  double get progress => _currentTask == null
      ? 0
      : (_currentCount / _currentTask!.count).clamp(0, 1);

  /// Initialize with a task
  Future<void> initialize(TaskModel task) async {
    _currentTask = task;
    _currentCount = 0;
    _isTaskCompleted = false;
    _error = null;

    try {
      // Initialize audio service
      await _audioService.initialize();
      
      // Initialize reward service
      await _rewardService.initialize();

      notifyListeners();
    } catch (e) {
      _error = 'Failed to initialize: $e';
      notifyListeners();
    }
  }

  /// Increment the counter
  void incrementCounter() {
    if (_currentTask == null || _isTaskCompleted) return;

    if (_currentCount < _currentTask!.count) {
      _currentCount++;
      notifyListeners();

      // Auto-complete when count reaches target
      if (_currentCount >= _currentTask!.count) {
        _checkTaskCompletion();
      }
    }
  }

  /// Decrement the counter (in case of mistake)
  void decrementCounter() {
    if (_currentCount > 0 && !_isTaskCompleted) {
      _currentCount--;
      notifyListeners();
    }
  }

  /// Reset the counter
  void resetCounter() {
    if (!_isTaskCompleted) {
      _currentCount = 0;
      notifyListeners();
    }
  }

  /// Check if task is complete
  void _checkTaskCompletion() {
    if (_currentTask != null && _currentCount >= _currentTask!.count) {
      _isTaskCompleted = true;
      notifyListeners();
    }
  }

  /// Play audio for the current zikr
  Future<void> playAudio() async {
    if (_currentTask?.audioPath == null) {
      _error = 'No audio available for this zikr';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      await _audioService.playFromAsset(_currentTask!.audioPath!);
      _isPlaying = true;
      _isLoading = false;
      notifyListeners();

      // Listen to audio completion
      _audioService.onPlayerComplete.listen((_) {
        _isPlaying = false;
        notifyListeners();
      });
    } catch (e) {
      _error = 'Failed to play audio: $e';
      _isLoading = false;
      _isPlaying = false;
      notifyListeners();
    }
  }

  /// Pause audio
  Future<void> pauseAudio() async {
    try {
      await _audioService.pause();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to pause audio: $e';
      notifyListeners();
    }
  }

  /// Stop audio
  Future<void> stopAudio() async {
    try {
      await _audioService.stop();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to stop audio: $e';
      notifyListeners();
    }
  }

  /// Toggle audio play/pause
  Future<void> toggleAudio() async {
    if (_isPlaying) {
      await pauseAudio();
    } else {
      await playAudio();
    }
  }

  /// Complete the task and award rewards
  Future<RewardModel?> completeTask() async {
    if (_currentTask == null) {
      _error = 'No task to complete';
      notifyListeners();
      return null;
    }

    if (_currentCount < _currentTask!.count) {
      _error = 'Task not completed yet. Current: $_currentCount, Required: ${_currentTask!.count}';
      notifyListeners();
      return null;
    }

    try {
      _isLoading = true;
      notifyListeners();

      // Award stars for completing the task
      final rewards = await _rewardService.awardTaskCompletion(stars: 5);

      // Show completion notification
      await _notificationService.showNotification(
        id: 2,
        title: 'Task Completed! 🌟',
        body: 'Great job! You earned 5 stars. Keep growing your plant!',
      );

      _isTaskCompleted = true;
      _isLoading = false;
      notifyListeners();

      return rewards;
    } catch (e) {
      _error = 'Failed to complete task: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioService.stop();
    super.dispose();
  }
}
