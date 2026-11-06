import 'package:flutter/material.dart';

import '../app/theme/app_colors.dart';

/// Kartu ringkasan di Dashboard, misalnya total tanaman.
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.highlight = false,
  });

  final String title;
  final String value;
  final IconData icon;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final accent = highlight ? AppColors.tertiary : AppColors.primary;
    final background = highlight
        ? AppColors.tertiary.withValues(alpha: 0.16)
        : AppColors.primaryContainer;

    return Card(
      color: background,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.72),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accent, size: 20, semanticLabel: title),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
