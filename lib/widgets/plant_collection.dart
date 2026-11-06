import 'package:flutter/material.dart';

import '../data/models/plant.dart';
import 'plant_card.dart';

/// Daftar atau grid tanaman. Grid dipakai pada landscape atau lebar >= 600.
class PlantCollection extends StatelessWidget {
  const PlantCollection({
    super.key,
    required this.plants,
    required this.onTap,
    required this.onFavoriteTap,
    required this.storageKey,
    this.bottomPadding = 16,
  });

  final List<Plant> plants;
  final ValueChanged<Plant> onTap;
  final ValueChanged<Plant> onFavoriteTap;
  final String storageKey;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final landscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    final useGrid = landscape || width >= 600;

    if (useGrid) {
      return GridView.builder(
        key: PageStorageKey(storageKey),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.45,
        ),
        itemCount: plants.length,
        itemBuilder: (context, index) => _card(plants[index]),
      );
    }

    return ListView.separated(
        key: PageStorageKey(storageKey),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding),
      itemCount: plants.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _card(plants[index]),
    );
  }

  Widget _card(Plant plant) {
    return PlantCard(
      key: ValueKey(plant.id),
      plant: plant,
      onTap: () => onTap(plant),
      onFavoriteTap: () => onFavoriteTap(plant),
    );
  }
}
