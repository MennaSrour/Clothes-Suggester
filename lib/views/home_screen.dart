import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_viewmodel.dart';
import '../models/task_model.dart';
import 'task_screen.dart';

/// Home Screen - Main screen of the app
/// Shows current task, start button, and plant progress indicator
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize the view model when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kids Zikr App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<HomeViewModel>().refresh();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          // Loading state
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error state
          if (viewModel.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${viewModel.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        viewModel.clearError();
                        viewModel.refresh();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: viewModel.refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Plant Progress Section
                  _buildPlantProgressSection(context, viewModel),
                  const SizedBox(height: 32),

                  // Current Task Section
                  _buildCurrentTaskSection(context, viewModel),
                  const SizedBox(height: 32),

                  // Start Button
                  _buildStartButton(context, viewModel),
                  const SizedBox(height: 16),

                  // Statistics Section
                  _buildStatisticsSection(context, viewModel),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<HomeViewModel>().generateNewTask();
        },
        tooltip: 'Get New Task',
        child: const Icon(Icons.shuffle),
      ),
    );
  }

  /// Build the plant progress section
  Widget _buildPlantProgressSection(BuildContext context, HomeViewModel viewModel) {
    final rewards = viewModel.rewards;
    final plantEmoji = rewards?.plantEmoji ?? '🌱';
    final plantStage = rewards?.plantStageName ?? 'Seed';
    final stars = rewards?.stars ?? 0;
    final progress = viewModel.getPlantProgress();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Your Plant Progress',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              plantEmoji,
              style: const TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 8),
            Text(
              plantStage,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress / 100,
              minHeight: 12,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              '$stars ⭐ Stars',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the current task section
  Widget _buildCurrentTaskSection(BuildContext context, HomeViewModel viewModel) {
    final task = viewModel.currentTask;
    final isCompletedToday = viewModel.isTaskCompletedToday;

    if (isCompletedToday) {
      return Card(
        elevation: 4,
        color: Colors.green[50],
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Icon(
                Icons.check_circle,
                size: 64,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              const Text(
                'Task Completed Today!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Come back tomorrow for a new task',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (task == null) {
      return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Icon(
                Icons.task_alt,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'No Task Available',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  viewModel.generateNewTask();
                },
                child: const Text('Generate Task'),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Today\'s Zikr',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                task.text,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Repeat ${task.count} times',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the start button
  Widget _buildStartButton(BuildContext context, HomeViewModel viewModel) {
    final task = viewModel.currentTask;
    final isCompletedToday = viewModel.isTaskCompletedToday;

    if (task == null || isCompletedToday) {
      return const SizedBox.shrink();
    }

    return ElevatedButton(
      onPressed: () {
        _navigateToTaskScreen(context, task);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: const Text('Start Task'),
    );
  }

  /// Build the statistics section
  Widget _buildStatisticsSection(BuildContext context, HomeViewModel viewModel) {
    return FutureBuilder<Map<String, dynamic>>(
      future: viewModel.getAchievements(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!;
        final completedTasks = data['completedTasks'] ?? 0;

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Statistics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      icon: Icons.task_alt,
                      label: 'Completed',
                      value: '$completedTasks',
                    ),
                    _buildStatItem(
                      icon: Icons.star,
                      label: 'Stars',
                      value: '${viewModel.rewards?.stars ?? 0}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build a single statistics item
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blue),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  /// Navigate to the task screen
  void _navigateToTaskScreen(BuildContext context, TaskModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskScreen(task: task),
      ),
    ).then((_) {
      // Refresh home screen when returning from task screen
      context.read<HomeViewModel>().refresh();
    });
  }
}
