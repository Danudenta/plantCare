import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app/router.dart';
import '../app/theme/app_colors.dart';
import '../utils/date_utils.dart';
import '../viewmodels/plant_viewmodel.dart';
import '../widgets/app_text_field.dart';
import '../widgets/category_filter_row.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_state.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/plant_collection.dart';
import '../widgets/summary_card.dart';

/// Beranda: ringkasan, pencarian, filter, dan daftar tanaman.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    final plants = context.read<PlantViewModel>();
    _search.text = plants.query;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) plants.loadPlants();
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _setQuery(String value) {
    context.read<PlantViewModel>().setQuery(value);
  }

  void _clearQuery() {
    _search.clear();
    _setQuery('');
  }

  @override
  Widget build(BuildContext context) {
    final plants = context.watch<PlantViewModel>();
    final loading = plants.listState is PlantListLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PlantCare'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            onPressed: loading ? null : plants.loadPlants,
            icon: const Icon(Icons.refresh),
          ),
          PopupMenuButton<SortOrder>(
            tooltip: 'Urutkan',
            initialValue: plants.sortOrder,
            onSelected: plants.setSortOrder,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: SortOrder.mostUrgent,
                child: Text('Paling Mendesak'),
              ),
              PopupMenuItem(
                value: SortOrder.nameAsc,
                child: Text('Nama A-Z'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah tanaman',
        onPressed: () => context.push(Routes.plantFormPath()),
        child: const Icon(Icons.add),
      ),
      body: _body(plants),
    );
  }

  Widget _body(PlantViewModel plants) {
    final state = plants.listState;
    if (state is PlantListLoading) return const LoadingIndicator();
    if (state is PlantListError) {
      return ErrorState(message: state.message, onRetry: plants.loadPlants);
    }

    return Column(
      children: [
        _header(plants),
        const SizedBox(height: 12),
        CategoryFilterRow(
          selected: plants.filter,
          onSelected: plants.setFilter,
        ),
        const SizedBox(height: 12),
        Expanded(child: _results(plants)),
      ],
    );
  }

  Widget _header(PlantViewModel plants) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Halo, Admin 👋', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            formatLongDate(DateTime.now()),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.muted,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'Total Tanaman',
                  value: '${plants.totalCount}',
                  icon: Icons.yard_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SummaryCard(
                  title: 'Perlu Disiram Hari Ini',
                  value: '${plants.needsWaterCount}',
                  icon: Icons.water_drop_outlined,
                  highlight: plants.needsWaterCount > 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _search,
            label: 'Cari nama atau jenis',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: plants.query.trim().isEmpty
                ? null
                : IconButton(
                    tooltip: 'Hapus teks',
                    onPressed: _clearQuery,
                    icon: const Icon(Icons.close),
                  ),
            onChanged: _setQuery,
          ),
        ],
      ),
    );
  }

  Widget _results(PlantViewModel plants) {
    if (plants.totalCount == 0) {
      return const EmptyState(
        emoji: '🌱',
        title: 'Belum ada tanaman',
        message: 'Koleksimu masih kosong. Tambah tanaman dengan tombol tambah.',
      );
    }
    if (plants.visiblePlants.isEmpty) {
      return const EmptyState(
        emoji: '🔍',
        title: 'Tidak ada hasil',
        message: 'Tidak ada tanaman yang cocok dengan pencarian atau filter.',
      );
    }

    return RefreshIndicator(
      onRefresh: () => plants.loadPlants(keepContent: true),
      child: PlantCollection(
        plants: plants.visiblePlants,
        storageKey: 'dashboard-plants',
        bottomPadding: 88,
        onTap: (plant) => context.push(Routes.plantDetailPath(plant.id)),
        onFavoriteTap: (plant) => plants.toggleFavorite(plant.id),
      ),
    );
  }
}
