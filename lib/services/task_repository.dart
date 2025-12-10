import 'dart:math';
import '../models/task_model.dart';

/// Repository class for managing Zikr tasks
/// Provides a list of azkar and methods for random selection
class TaskRepository {
  static final TaskRepository _instance = TaskRepository._internal();
  factory TaskRepository() => _instance;
  TaskRepository._internal();

  final Random _random = Random();

  /// List of available Azkar tasks
  final List<TaskModel> _azkarList = [
    TaskModel(
      id: '1',
      text: 'سُبْحَانَ اللَّهِ',
      count: 33,
      audioPath: null,
    ),
    TaskModel(
      id: '2',
      text: 'الْحَمْدُ لِلَّهِ',
      count: 33,
      audioPath: null,
    ),
    TaskModel(
      id: '3',
      text: 'اللَّهُ أَكْبَرُ',
      count: 34,
      audioPath: null,
    ),
    TaskModel(
      id: '4',
      text: 'لَا إِلَٰهَ إِلَّا اللَّهُ',
      count: 10,
      audioPath: null,
    ),
    TaskModel(
      id: '5',
      text: 'أَسْتَغْفِرُ اللَّهَ',
      count: 100,
      audioPath: null,
    ),
    TaskModel(
      id: '6',
      text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      count: 100,
      audioPath: null,
    ),
    TaskModel(
      id: '7',
      text: 'سُبْحَانَ اللَّهِ الْعَظِيمِ',
      count: 10,
      audioPath: null,
    ),
    TaskModel(
      id: '8',
      text: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      count: 10,
      audioPath: null,
    ),
    TaskModel(
      id: '9',
      text: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      count: 21,
      audioPath: null,
    ),
    TaskModel(
      id: '10',
      text: 'اللَّهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ',
      count: 10,
      audioPath: null,
    ),
    TaskModel(
      id: '11',
      text: 'رَبِّ اغْفِرْ لِي',
      count: 7,
      audioPath: null,
    ),
    TaskModel(
      id: '12',
      text: 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
      count: 7,
      audioPath: null,
    ),
  ];

  /// Get all available Azkar tasks
  List<TaskModel> getAllTasks() {
    return List.unmodifiable(_azkarList);
  }

  /// Get a random task from the list
  TaskModel getRandomTask() {
    final index = _random.nextInt(_azkarList.length);
    return _azkarList[index];
  }

  /// Get a task by ID
  TaskModel? getTaskById(String id) {
    try {
      return _azkarList.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get a random task excluding specific IDs
  TaskModel getRandomTaskExcluding(List<String> excludedIds) {
    final availableTasks = _azkarList
        .where((task) => !excludedIds.contains(task.id))
        .toList();

    if (availableTasks.isEmpty) {
      // If all tasks are excluded, return a random task from all
      return getRandomTask();
    }

    final index = _random.nextInt(availableTasks.length);
    return availableTasks[index];
  }

  /// Get tasks by count range
  List<TaskModel> getTasksByCountRange(int minCount, int maxCount) {
    return _azkarList
        .where((task) => task.count >= minCount && task.count <= maxCount)
        .toList();
  }

  /// Get easy tasks (count <= 20)
  List<TaskModel> getEasyTasks() {
    return getTasksByCountRange(1, 20);
  }

  /// Get medium tasks (count 21-50)
  List<TaskModel> getMediumTasks() {
    return getTasksByCountRange(21, 50);
  }

  /// Get hard tasks (count > 50)
  List<TaskModel> getHardTasks() {
    return getTasksByCountRange(51, 1000);
  }

  /// Get a random easy task
  TaskModel getRandomEasyTask() {
    final easyTasks = getEasyTasks();
    if (easyTasks.isEmpty) return getRandomTask();
    final index = _random.nextInt(easyTasks.length);
    return easyTasks[index];
  }

  /// Get a random medium task
  TaskModel getRandomMediumTask() {
    final mediumTasks = getMediumTasks();
    if (mediumTasks.isEmpty) return getRandomTask();
    final index = _random.nextInt(mediumTasks.length);
    return mediumTasks[index];
  }

  /// Get a random hard task
  TaskModel getRandomHardTask() {
    final hardTasks = getHardTasks();
    if (hardTasks.isEmpty) return getRandomTask();
    final index = _random.nextInt(hardTasks.length);
    return hardTasks[index];
  }

  /// Get total number of tasks
  int get totalTasksCount => _azkarList.length;

  /// Search tasks by text
  List<TaskModel> searchTasks(String query) {
    if (query.isEmpty) return getAllTasks();
    
    final lowerQuery = query.toLowerCase();
    return _azkarList
        .where((task) => task.text.toLowerCase().contains(lowerQuery))
        .toList();
  }
}
