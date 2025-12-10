import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../models/reward_model.dart';
import '../services/task_repository.dart';
import '../services/reward_service.dart';
import '../services/notification_service.dart';

/// ViewModel for the Home Screen
/// Manages the state and business logic for the home screen
class HomeViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository = TaskRepository();
  final RewardService _rewardService = RewardService();
  final NotificationService _notificationService = NotificationService();

  TaskModel? _currentTask;
  RewardModel? _rewards;
  bool _isLoading = false;
  String? _error;
  bool _isTaskCompletedToday = false;

  /// Getters
  TaskModel? get currentTask => _currentTask;
  RewardModel? get rewards => _rewards;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isTaskCompletedToday => _isTaskCompletedToday;

  /// Initialize the home view model
  Future<void> initialize() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Initialize services
      await _rewardService.initialize();
      await _notificationService.initialize();

      // Load rewards
      await loadRewards();

      // Check if task completed today
      _isTaskCompletedToday = await _rewardService.isTaskCompletedToday();

      // Load or generate a new task
      if (!_isTaskCompletedToday) {
        _currentTask = _taskRepository.getRandomTask();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to initialize: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load rewards from storage
  Future<void> loadRewards() async {
    try {
      _rewards = await _rewardService.getRewards();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load rewards: $e';
      notifyListeners();
    }
  }

  /// Generate a new random task
  void generateNewTask() {
    _currentTask = _taskRepository.getRandomTask();
    notifyListeners();
  }

  /// Start a task (navigate to task screen)
  void startTask() {
    // This method is called when user taps the start button
    // The actual navigation is handled in the UI layer
    notifyListeners();
  }

  /// Get plant progress percentage (0-100)
  double getPlantProgress() {
    if (_rewards == null) return 0;
    
    final stars = _rewards!.stars;
    final growth = _rewards!.plantGrowth;

    if (growth == 0) {
      // Seed to Plant: 0-10 stars
      return (stars / 10) * 33.33;
    } else if (growth == 1) {
      // Plant to Tree: 10-30 stars
      final progress = ((stars - 10) / 20) * 33.33;
      return 33.33 + progress;
    } else {
      // Tree: 30+ stars
      final progress = ((stars - 30) / 20).clamp(0, 1) * 33.34;
      return 66.66 + progress;
    }
  }

  /// Get achievement statistics
  Future<Map<String, dynamic>> getAchievements() async {
    return await _rewardService.getAchievements();
  }

  /// Schedule daily reminder notification
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    try {
      await _notificationService.scheduleDailyNotification(
        id: 1,
        title: 'Time for Zikr! 🌟',
        body: 'Complete your daily zikr and grow your plant!',
        hour: hour,
        minute: minute,
      );
    } catch (e) {
      _error = 'Failed to schedule reminder: $e';
      notifyListeners();
    }
  }

  /// Cancel daily reminder
  Future<void> cancelDailyReminder() async {
    try {
      await _notificationService.cancelNotification(1);
    } catch (e) {
      _error = 'Failed to cancel reminder: $e';
      notifyListeners();
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    await initialize();
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
