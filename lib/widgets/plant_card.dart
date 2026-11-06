import 'package:flutter/material.dart';

import '../app/theme/app_colors.dart';
import '../data/models/plant.dart';
import 'app_logo.dart';
import 'status_badge.dart';

/// Teks jadwal sesuai sisa hari penyiraman.
String wateringScheduleText(int daysUntilWatering) {
  if (daysUntilWatering > 1) return 'Siram dalam $daysUntilWatering hari';
  if (daysUntilWatering == 1) return 'Siram besok';
  if (daysUntilWatering == 0) return 'Siram hari ini';
  return 'Terlambat ${daysUntilWatering.abs()} hari';
}

/// Kartu tanaman untuk daftar Dashboard dan Favorit.
class PlantCard extends StatelessWidget {
  const PlantCard({
    super.key,
    required this.plant,
    required this.onTap,
    required this.onFavoriteTap,
  });

  final Plant plant;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final urgent = plant.daysUntilWatering <= 0;
    final favoriteLabel =
        plant.isFavorite ? 'Hapus dari favorit' : 'Tandai favorit';

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              EmojiMark(emoji: plant.emoji, size: 48, fontSize: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      plant.species,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium,
                    ),
                    Text(
                      plant.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(color: AppColors.muted),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      wateringScheduleText(plant.daysUntilWatering),
                      style: textTheme.labelMedium?.copyWith(
                        color: urgent ? AppColors.tertiary : AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  StatusBadge(status: plant.status),
                  IconButton(
                    tooltip: favoriteLabel,
                    onPressed: onFavoriteTap,
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      switchInCurve: Curves.easeOutBack,
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        key: ValueKey(plant.isFavorite),
                        plant.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: plant.isFavorite
                            ? AppColors.error
                            : AppColors.muted,
                        semanticLabel: favoriteLabel,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
