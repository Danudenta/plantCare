import 'package:flutter/material.dart';

import '../app/theme/app_colors.dart';
import '../data/models/plant.dart';

/// Badge status penyiraman. Teks selalu ada, tidak hanya warna.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final WateringStatus status;

  @override
  Widget build(BuildContext context) {
    final needsWater = status == WateringStatus.needsWater;
    final background = needsWater
        ? AppColors.tertiary.withValues(alpha: 0.16)
        : AppColors.primaryContainer;
    final foreground = needsWater ? AppColors.tertiary : AppColors.primary;
    final label = needsWater ? 'Perlu Disiram' : 'Aman';

    return Semantics(
      label: label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
