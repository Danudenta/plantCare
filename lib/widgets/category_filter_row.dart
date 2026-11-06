import 'package:flutter/material.dart';

import '../app/theme/app_colors.dart';
import '../viewmodels/plant_viewmodel.dart';

/// Baris chip filter Dashboard: Semua, Indoor, Outdoor, Perlu Disiram.
class CategoryFilterRow extends StatelessWidget {
  const CategoryFilterRow({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final PlantFilter selected;
  final ValueChanged<PlantFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (final filter in PlantFilter.values) ...[
            FilterChip(
              label: Text(filter.label),
              selected: selected == filter,
              showCheckmark: false,
              selectedColor: AppColors.primaryContainer,
              labelStyle: TextStyle(
                color: selected == filter ? AppColors.primary : AppColors.onSurface,
                fontWeight: selected == filter ? FontWeight.w700 : FontWeight.w500,
              ),
              onSelected: (_) => onSelected(filter),
            ),
            if (filter != PlantFilter.values.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
