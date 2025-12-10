import 'package:shared_preferences/shared_preferences.dart';
import '../models/reward_model.dart';

/// Service class for managing rewards and achievements
/// Uses SharedPreferences for data persistence
class RewardService {
  static final RewardService _instance = RewardService._internal();
  factory RewardService() => _instance;
  RewardService._internal();

  SharedPreferences? _prefs;

  // Storage keys
  static const String _starsKey = 'total_stars';
  static const String _plantGrowthKey = 'plant_growth';
  static const String _completedTasksKey = 'completed_tasks';
  static const String _lastTaskDateKey = 'last_task_date';

  /// Initialize the reward service
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Get the current rewards
  Future<RewardModel> getRewards() async {
    await initialize();
    
    final stars = _prefs!.getInt(_starsKey) ?? 0;
    final plantGrowth = _prefs!.getInt(_plantGrowthKey) ?? 0;

    return RewardModel(
      stars: stars,
      plantGrowth: plantGrowth,
    );
  }

  /// Add stars to the total
  Future<RewardModel> addStars(int starsToAdd) async {
    await initialize();
    
    final currentStars = _prefs!.getInt(_starsKey) ?? 0;
    final newStars = currentStars + starsToAdd;
    await _prefs!.setInt(_starsKey, newStars);

    // Update plant growth based on stars
    await _updatePlantGrowth(newStars);

    return await getRewards();
  }

  /// Update plant growth based on total stars
  Future<void> _updatePlantGrowth(int totalStars) async {
    int newGrowth;
    
    if (totalStars < 10) {
      newGrowth = 0; // Seed
    } else if (totalStars < 30) {
      newGrowth = 1; // Plant
    } else {
      newGrowth = 2; // Tree
    }

    await _prefs!.setInt(_plantGrowthKey, newGrowth);
  }

  /// Manually set plant growth level
  Future<void> setPlantGrowth(int growth) async {
    await initialize();
    await _prefs!.setInt(_plantGrowthKey, growth.clamp(0, 2));
  }

  /// Get the total number of completed tasks
  Future<int> getCompletedTasksCount() async {
    await initialize();
    return _prefs!.getInt(_completedTasksKey) ?? 0;
  }

  /// Increment the completed tasks counter
  Future<int> incrementCompletedTasks() async {
    await initialize();
    
    final currentCount = _prefs!.getInt(_completedTasksKey) ?? 0;
    final newCount = currentCount + 1;
    await _prefs!.setInt(_completedTasksKey, newCount);

    return newCount;
  }

  /// Get the last task completion date
  Future<DateTime?> getLastTaskDate() async {
    await initialize();
    
    final timestamp = _prefs!.getString(_lastTaskDateKey);
    if (timestamp == null) return null;

    return DateTime.parse(timestamp);
  }

  /// Update the last task completion date
  Future<void> updateLastTaskDate(DateTime date) async {
    await initialize();
    await _prefs!.setString(_lastTaskDateKey, date.toIso8601String());
  }

  /// Check if a task was completed today
  Future<bool> isTaskCompletedToday() async {
    final lastDate = await getLastTaskDate();
    if (lastDate == null) return false;

    final now = DateTime.now();
    return lastDate.year == now.year &&
        lastDate.month == now.month &&
        lastDate.day == now.day;
  }

  /// Reset all rewards (use with caution)
  Future<void> resetRewards() async {
    await initialize();
    await _prefs!.setInt(_starsKey, 0);
    await _prefs!.setInt(_plantGrowthKey, 0);
    await _prefs!.setInt(_completedTasksKey, 0);
    await _prefs!.remove(_lastTaskDateKey);
  }

  /// Get total stars
  Future<int> getTotalStars() async {
    await initialize();
    return _prefs!.getInt(_starsKey) ?? 0;
  }

  /// Get current plant growth level
  Future<int> getPlantGrowthLevel() async {
    await initialize();
    return _prefs!.getInt(_plantGrowthKey) ?? 0;
  }

  /// Award stars for completing a task
  /// Returns the updated RewardModel
  Future<RewardModel> awardTaskCompletion({int stars = 5}) async {
    await incrementCompletedTasks();
    await updateLastTaskDate(DateTime.now());
    return await addStars(stars);
  }

  /// Get achievement status
  Future<Map<String, dynamic>> getAchievements() async {
    final completedTasks = await getCompletedTasksCount();
    final totalStars = await getTotalStars();
    final plantGrowth = await getPlantGrowthLevel();

    return {
      'completedTasks': completedTasks,
      'totalStars': totalStars,
      'plantGrowth': plantGrowth,
      'achievements': {
        'firstTask': completedTasks >= 1,
        'tenTasks': completedTasks >= 10,
        'fiftyTasks': completedTasks >= 50,
        'hundredTasks': completedTasks >= 100,
        'plantGrown': plantGrowth >= 1,
        'treeGrown': plantGrowth >= 2,
      },
    };
  }
}
