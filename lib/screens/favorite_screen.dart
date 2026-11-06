import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app/router.dart';
import '../viewmodels/plant_viewmodel.dart';
import '../widgets/empty_state.dart';
import '../widgets/plant_collection.dart';

/// Daftar tanaman yang ditandai favorit.
class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plants = context.watch<PlantViewModel>();
    final favorites = plants.favoritePlants;

    return Scaffold(
      appBar: AppBar(title: const Text('Tanaman Favorit')),
      body: favorites.isEmpty
          ? const EmptyState(
              emoji: '💚',
              title: 'Belum ada favorit',
              message: 'Tandai tanamanmu dari beranda.',
            )
          : PlantCollection(
              plants: favorites,
              storageKey: 'favorite-plants',
              onTap: (plant) => context.push(Routes.plantDetailPath(plant.id)),
              onFavoriteTap: (plant) => plants.toggleFavorite(plant.id),
            ),
    );
  }
}
