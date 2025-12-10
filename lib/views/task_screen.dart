import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../viewmodels/task_viewmodel.dart';

/// Task Screen - Screen for completing a zikr task
/// Shows the zikr text, count, counter, audio button, and complete button
class TaskScreen extends StatefulWidget {
  final TaskModel task;

  const TaskScreen({
    super.key,
    required this.task,
  });

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize the view model with the task
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskViewModel>().initialize(widget.task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Zikr'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<TaskViewModel>(
        builder: (context, viewModel, child) {
          // Loading state
          if (viewModel.isLoading && viewModel.currentTask == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error state
          if (viewModel.error != null && !viewModel.isTaskCompleted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(viewModel.error!),
                  action: SnackBarAction(
                    label: 'Dismiss',
                    onPressed: () {
                      viewModel.clearError();
                    },
                  ),
                ),
              );
            });
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Zikr Text
                  _buildZikrText(context, viewModel),
                  const SizedBox(height: 24),

                  // Progress Indicator
                  _buildProgressIndicator(context, viewModel),
                  const SizedBox(height: 24),

                  // Counter Display
                  _buildCounterDisplay(context, viewModel),
                  const SizedBox(height: 32),

                  // Counter Button
                  _buildCounterButton(context, viewModel),
                  const SizedBox(height: 16),

                  // Counter Controls
                  _buildCounterControls(context, viewModel),
                  const SizedBox(height: 24),

                  // Audio Button (if available)
                  if (widget.task.audioPath != null)
                    _buildAudioButton(context, viewModel),
                  if (widget.task.audioPath != null)
                    const SizedBox(height: 16),

                  const Spacer(),

                  // Complete Button
                  _buildCompleteButton(context, viewModel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build the zikr text display
  Widget _buildZikrText(BuildContext context, TaskViewModel viewModel) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Recite:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.task.text,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build the progress indicator
  Widget _buildProgressIndicator(BuildContext context, TaskViewModel viewModel) {
    final progress = viewModel.progress;
    final percentage = (progress * 100).toInt();

    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          minHeight: 16,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            viewModel.isTaskCompleted ? Colors.green : Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$percentage% Complete',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Build the counter display
  Widget _buildCounterDisplay(BuildContext context, TaskViewModel viewModel) {
    return Card(
      elevation: 4,
      color: viewModel.isTaskCompleted ? Colors.green[50] : null,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${viewModel.currentCount}',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: viewModel.isTaskCompleted ? Colors.green : Colors.blue,
                  ),
                ),
                const Text(
                  ' / ',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '${widget.task.count}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (viewModel.isTaskCompleted)
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Task Completed!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              )
            else
              Text(
                '${viewModel.remainingCount} remaining',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build the main counter button
  Widget _buildCounterButton(BuildContext context, TaskViewModel viewModel) {
    return GestureDetector(
      onTap: viewModel.isTaskCompleted ? null : viewModel.incrementCounter,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: viewModel.isTaskCompleted ? Colors.grey : Colors.blue,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                viewModel.isTaskCompleted ? Icons.check_circle : Icons.touch_app,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                viewModel.isTaskCompleted ? 'Completed' : 'Tap to Count',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build counter controls (reset, decrement)
  Widget _buildCounterControls(BuildContext context, TaskViewModel viewModel) {
    if (viewModel.isTaskCompleted) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Decrement button
        IconButton(
          onPressed: viewModel.currentCount > 0 ? viewModel.decrementCounter : null,
          icon: const Icon(Icons.remove_circle),
          iconSize: 40,
          color: Colors.orange,
          tooltip: 'Decrease',
        ),
        const SizedBox(width: 32),
        // Reset button
        IconButton(
          onPressed: viewModel.currentCount > 0 ? viewModel.resetCounter : null,
          icon: const Icon(Icons.refresh),
          iconSize: 40,
          color: Colors.red,
          tooltip: 'Reset',
        ),
      ],
    );
  }

  /// Build the audio play button
  Widget _buildAudioButton(BuildContext context, TaskViewModel viewModel) {
    return ElevatedButton.icon(
      onPressed: viewModel.toggleAudio,
      icon: Icon(viewModel.isPlaying ? Icons.pause : Icons.play_arrow),
      label: Text(viewModel.isPlaying ? 'Pause Audio' : 'Play Audio'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Build the complete task button
  Widget _buildCompleteButton(BuildContext context, TaskViewModel viewModel) {
    final canComplete = viewModel.currentCount >= widget.task.count;

    return ElevatedButton(
      onPressed: canComplete && !viewModel.isTaskCompleted
          ? () => _handleCompleteTask(context, viewModel)
          : null,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey,
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: viewModel.isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              viewModel.isTaskCompleted ? 'Task Completed ✓' : 'Complete Task',
            ),
    );
  }

  /// Handle task completion
  Future<void> _handleCompleteTask(BuildContext context, TaskViewModel viewModel) async {
    final rewards = await viewModel.completeTask();

    if (!mounted) return;

    if (rewards != null) {
      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.celebration, color: Colors.amber, size: 32),
              SizedBox(width: 8),
              Text('Congratulations!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                rewards.plantEmoji,
                style: const TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 16),
              const Text(
                'Task completed successfully!',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'You earned 5 stars! ⭐',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.amber[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your plant is now a ${rewards.plantStageName}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Return to home screen
              },
              child: const Text(
                'Done',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    // Stop audio when leaving the screen
    context.read<TaskViewModel>().stopAudio();
    super.dispose();
  }
}
