import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app/router.dart';
import '../app/theme/app_colors.dart';
import '../utils/date_utils.dart';
import '../viewmodels/plant_viewmodel.dart';
import '../widgets/app_logo.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/error_state.dart';
import '../widgets/plant_card.dart';
import '../widgets/status_badge.dart';

/// Detail satu tanaman beserta aksi siram, favorit, edit, dan hapus.
class PlantDetailScreen extends StatefulWidget {
  const PlantDetailScreen({super.key, required this.plantId});

  final int? plantId;

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen>
    with RestorationMixin {
  final RestorableBool _confirmOpen = RestorableBool(false);
  var _dialogVisible = false;

  @override
  String? get restorationId => 'plant-detail-${widget.plantId ?? 'invalid'}';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_confirmOpen, 'delete-confirm');
    if (_confirmOpen.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _confirmDelete();
      });
    }
  }

  @override
  void dispose() {
    _confirmOpen.dispose();
    super.dispose();
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(Routes.dashboard);
  }

  Future<void> _confirmDelete() async {
    if (_dialogVisible || !mounted) return;
    final id = widget.plantId;
    final plant = id == null ? null : context.read<PlantViewModel>().findById(id);
    if (plant == null) return;

    _dialogVisible = true;
    _confirmOpen.value = true;
    await showConfirmDialog(
      context: context,
      title: 'Hapus tanaman?',
      message: '${plant.name} akan dihapus dari koleksi.',
      confirmText: 'Hapus',
      isDestructive: true,
      onConfirm: () {
        final removed = context.read<PlantViewModel>().delete(plant.id);
        if (!mounted || !removed) return;
        context.go(Routes.dashboard);
      },
    );
    _dialogVisible = false;
    if (mounted) _confirmOpen.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final plants = context.watch<PlantViewModel>();
    final plant = widget.plantId == null ? null : plants.findById(widget.plantId!);

    if (plant == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Tanaman')),
        body: ErrorState(
          message: 'Tanaman tidak ditemukan',
          actionLabel: 'Kembali',
          onRetry: _back,
        ),
      );
    }

    final favoriteLabel =
        plant.isFavorite ? 'Hapus dari favorit' : 'Tandai favorit';

    return Scaffold(
      appBar: AppBar(
        title: Text(plant.name),
        actions: [
          IconButton(
            tooltip: favoriteLabel,
            onPressed: () => plants.toggleFavorite(plant.id),
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                key: ValueKey(plant.isFavorite),
                plant.isFavorite ? Icons.favorite : Icons.favorite_border,
                semanticLabel: favoriteLabel,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Edit tanaman',
            onPressed: () => context.push(Routes.plantFormPath(plantId: plant.id)),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: EmojiMark(emoji: plant.emoji, size: 160, fontSize: 80),
            ),
            const SizedBox(height: 16),
            Center(child: StatusBadge(status: plant.status)),
            const SizedBox(height: 8),
            Center(
              child: Text(
                wateringScheduleText(plant.daysUntilWatering),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: plant.daysUntilWatering <= 0
                          ? AppColors.tertiary
                          : AppColors.primary,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _info('Jenis', plant.species),
                    _info('Kategori', plant.category.label),
                    _info('Lokasi', plant.location),
                    _info('Interval siram', '${plant.wateringIntervalDays} hari'),
                    _info('Terakhir disiram', formatLongDate(plant.lastWateredDate)),
                    _info('Jadwal berikutnya', formatLongDate(plant.nextWateringDate)),
                    _info('Catatan', plant.notes.trim().isEmpty ? '-' : plant.notes),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => plants.markWatered(plant.id),
              child: const Text('Sudah Disiram 💧'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
              ),
              onPressed: _confirmDelete,
              child: const Text('Hapus Tanaman'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.muted,
                  ),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.titleSmall),
          ),
        ],
      ),
    );
  }
}
