import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class ConsistencyHeatmap extends StatelessWidget {
  final Map<DateTime, int> activityData;
  final int weeks;

  const ConsistencyHeatmap({
    super.key,
    required this.activityData,
    this.weeks = 15,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final startDate = today.subtract(Duration(days: weeks * 7));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Consistency', style: AppTypography.heading4),
            Row(
              children: [
                Text('Less ', style: AppTypography.bodySmall),
                ...List.generate(5, (i) {
                  return Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(left: 2),
                    decoration: BoxDecoration(
                      color: _getColor(i),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
                Text(' More', style: AppTypography.bodySmall),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 7 * 14.0,
          child: Row(
            children: List.generate(weeks, (weekIndex) {
              return Expanded(
                child: Column(
                  children: List.generate(7, (dayIndex) {
                    final date = startDate.add(
                      Duration(days: weekIndex * 7 + dayIndex),
                    );
                    final normalizedDate =
                        DateTime(date.year, date.month, date.day);
                    final count = _getActivityCount(normalizedDate);

                    return Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: _getColorForCount(count),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  int _getActivityCount(DateTime date) {
    for (final entry in activityData.entries) {
      final entryDate = DateTime(
        entry.key.year,
        entry.key.month,
        entry.key.day,
      );
      if (entryDate == date) return entry.value;
    }
    return 0;
  }

  Color _getColorForCount(int count) {
    if (count == 0) return Colors.white.withValues(alpha: 0.05);
    if (count == 1) return AppColors.neonGreen.withValues(alpha: 0.2);
    if (count == 2) return AppColors.neonGreen.withValues(alpha: 0.4);
    if (count == 3) return AppColors.neonGreen.withValues(alpha: 0.6);
    return AppColors.neonGreen.withValues(alpha: 0.9);
  }

  Color _getColor(int level) {
    if (level == 0) return Colors.white.withValues(alpha: 0.05);
    return AppColors.neonGreen.withValues(alpha: 0.2 + (level * 0.2));
  }
}
