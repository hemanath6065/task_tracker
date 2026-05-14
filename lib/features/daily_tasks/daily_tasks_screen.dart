import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/glassmorphic_card.dart';
import '../../providers/task_provider.dart';

class DailyTasksScreen extends ConsumerStatefulWidget {
  const DailyTasksScreen({super.key});

  @override
  ConsumerState<DailyTasksScreen> createState() => _DailyTasksScreenState();
}

class _DailyTasksScreenState extends ConsumerState<DailyTasksScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCategory = 'general';
  int _estimatedMinutes = 30;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _showAddTaskSheet() {
    _titleController.clear();
    _descController.clear();
    _selectedCategory = 'general';
    _estimatedMinutes = 30;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textTertiary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('New Task', style: AppTypography.heading3),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                style: AppTypography.bodyLarge,
                decoration: const InputDecoration(hintText: 'Task title...'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descController,
                style: AppTypography.bodyMedium,
                maxLines: 2,
                decoration: const InputDecoration(hintText: 'Description (optional)...'),
              ),
              const SizedBox(height: 16),
              Text('Category', style: AppTypography.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: ['general', 'java', 'spring', 'dsa', 'microservices']
                    .map((cat) => GestureDetector(
                          onTap: () => setSheetState(() => _selectedCategory = cat),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _selectedCategory == cat
                                  ? AppColors.neonGreen.withValues(alpha: 0.2)
                                  : AppColors.card,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _selectedCategory == cat
                                    ? AppColors.neonGreen : AppColors.cardLight,
                              ),
                            ),
                            child: Text(cat.toUpperCase(),
                                style: AppTypography.labelSmall.copyWith(
                                  color: _selectedCategory == cat
                                      ? AppColors.neonGreen : AppColors.textSecondary,
                                )),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Est. time: ', style: AppTypography.labelLarge),
                  Text('$_estimatedMinutes min',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.electricBlue)),
                ],
              ),
              Slider(
                value: _estimatedMinutes.toDouble(),
                min: 10, max: 120, divisions: 11,
                activeColor: AppColors.electricBlue,
                onChanged: (v) => setSheetState(() => _estimatedMinutes = v.toInt()),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.trim().isNotEmpty) {
                      ref.read(taskProvider).addTask(
                            title: _titleController.text.trim(),
                            description: _descController.text.trim(),
                            estimatedMinutes: _estimatedMinutes,
                            category: _selectedCategory,
                          );
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Add Task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: taskState.canAddMoreTasks
          ? FloatingActionButton(
              onPressed: _showAddTaskSheet,
              child: const Icon(Icons.add_rounded),
            ).animate().scale(duration: 300.ms)
          : null,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Daily Tasks', style: AppTypography.heading2)
                        .animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: 4),
                    Text('Focus on what matters today', style: AppTypography.bodyMedium)
                        .animate().fadeIn(duration: 400.ms, delay: 100.ms),
                  ],
                ),
              ),
            ),
            if (!taskState.canAddMoreTasks)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: GlassmorphicCard(
                    borderColor: AppColors.amber.withValues(alpha: 0.3),
                    gradient: LinearGradient(colors: [
                      AppColors.amber.withValues(alpha: 0.1),
                      AppColors.amber.withValues(alpha: 0.02),
                    ]),
                    child: Row(children: [
                      const Text('🧘', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          taskState.overwhelmMessage ?? AppConstants.antiOverwhelmMessages.first,
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.amber),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            if (taskState.todayTasks.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('📋', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 16),
                      Text('No tasks yet', style: AppTypography.heading4),
                      const SizedBox(height: 8),
                      Text('Tap + to add your first task', style: AppTypography.bodyMedium),
                    ],
                  ).animate().fadeIn(duration: 500.ms),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final task = taskState.todayTasks[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: Dismissible(
                        key: Key(task.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.delete_outline, color: AppColors.error),
                        ),
                        onDismissed: (_) => ref.read(taskProvider).deleteTask(task.id),
                        child: GlassmorphicCard(
                          borderColor: task.isCompleted
                              ? AppColors.neonGreen.withValues(alpha: 0.3)
                              : Colors.white.withValues(alpha: 0.05),
                          onTap: () => ref.read(taskProvider).toggleTask(task),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 26, height: 26,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: task.isCompleted ? AppColors.neonGreen : Colors.transparent,
                                  border: Border.all(
                                    color: task.isCompleted ? AppColors.neonGreen : AppColors.textTertiary,
                                    width: 2,
                                  ),
                                ),
                                child: task.isCompleted
                                    ? const Icon(Icons.check, size: 14, color: AppColors.background)
                                    : null,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(task.title,
                                        style: AppTypography.labelLarge.copyWith(
                                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                          color: task.isCompleted ? AppColors.textTertiary : null,
                                        )),
                                    if (task.description != null && task.description!.isNotEmpty)
                                      Text(task.description!, style: AppTypography.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor(task.category).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(task.category.toUpperCase(),
                                        style: AppTypography.labelSmall.copyWith(
                                          color: _getCategoryColor(task.category), fontSize: 9)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('${task.estimatedMinutes}m', style: AppTypography.labelSmall),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(duration: 300.ms, delay: Duration(milliseconds: 50 * index)),
                    );
                  },
                  childCount: taskState.todayTasks.length,
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'java': return AppColors.neonGreen;
      case 'spring': return AppColors.electricBlue;
      case 'dsa': return AppColors.softPurple;
      case 'microservices': return AppColors.accentPink;
      default: return AppColors.textSecondary;
    }
  }
}
