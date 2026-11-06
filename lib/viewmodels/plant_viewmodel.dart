import 'package:flutter/foundation.dart';

import '../data/models/plant.dart';
import '../data/network_exception.dart';
import '../data/plant_repository.dart';

/// State pemuatan daftar. Daftar tanaman tidak disimpan di sini.
sealed class PlantListState {
  const PlantListState();
}

final class PlantListLoading extends PlantListState {
  const PlantListLoading();
}

final class PlantListSuccess extends PlantListState {
  const PlantListSuccess();
}

final class PlantListError extends PlantListState {
  const PlantListError(this.message);

  final String message;
}

/// Filter chip di Dashboard.
enum PlantFilter {
  all('Semua'),
  indoor('Indoor'),
  outdoor('Outdoor'),
  needsWater('Perlu Disiram');

  const PlantFilter(this.label);

  final String label;
}

/// Urutan daftar. Default: paling mendesak.
enum SortOrder { mostUrgent, nameAsc }

/// Daftar, pencarian, filter, favorit, dan penyiraman.
class PlantViewModel extends ChangeNotifier {
  PlantViewModel(this._repository) {
    _repository.plants.addListener(_onPlantsChanged);
  }

  final PlantRepository _repository;

  PlantListState _listState = const PlantListLoading();
  String _query = '';
  PlantFilter _filter = PlantFilter.all;
  SortOrder _sortOrder = SortOrder.mostUrgent;
  String? _pendingMessage;

  PlantListState get listState => _listState;
  String get query => _query;
  PlantFilter get filter => _filter;
  SortOrder get sortOrder => _sortOrder;
  String? get pendingMessage => _pendingMessage;

  /// Total tanaman, dihitung dari data terkini.
  int get totalCount => _repository.plants.value.length;

  /// Jumlah tanaman yang perlu disiram hari ini.
  int get needsWaterCount => _repository.plants.value
      .where((plant) => plant.status == WateringStatus.needsWater)
      .length;

  /// Jumlah favorit untuk statistik profil.
  int get favoriteCount =>
      _repository.plants.value.where((plant) => plant.isFavorite).length;

  /// Daftar Dashboard setelah search, filter, dan urutan digabung.
  List<Plant> get visiblePlants {
    final items = _repository.plants.value.where(_matches).toList();
    _sort(items);
    return items;
  }

  /// Daftar favorit. Tidak memakai filter Dashboard.
  List<Plant> get favoritePlants {
    final items = _repository.plants.value
        .where((plant) => plant.isFavorite)
        .toList();
    _sort(items);
    return items;
  }

  Plant? findById(int id) => _repository.getById(id);

  /// Memuat data. Gagal dengan pesan jaringan bila simulasi offline aktif.
  ///
  /// [keepContent] mempertahankan daftar saat tarik untuk memuat ulang.
  Future<void> loadPlants({bool keepContent = false}) async {
    if (!keepContent || _listState is! PlantListSuccess) {
      _listState = const PlantListLoading();
      notifyListeners();
    }
    try {
      await _repository.loadPlants();
      _listState = const PlantListSuccess();
    } on NetworkException {
      _listState = const PlantListError(
        'Tidak ada koneksi internet. Periksa jaringanmu lalu coba lagi.',
      );
    } catch (_) {
      _listState = const PlantListError('Terjadi kesalahan. Coba lagi.');
    }
    notifyListeners();
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setFilter(PlantFilter value) {
    if (_filter == value) return;
    _filter = value;
    notifyListeners();
  }

  void setSortOrder(SortOrder value) {
    if (_sortOrder == value) return;
    _sortOrder = value;
    notifyListeners();
  }

  /// Membalik favorit. Mengembalikan false bila tanaman tidak ada.
  bool toggleFavorite(int id) {
    final plant = _repository.getById(id);
    if (plant == null) {
      _pendingMessage = 'Gagal menyimpan. Silakan coba lagi.';
      notifyListeners();
      return false;
    }

    final willBeFavorite = !plant.isFavorite;
    final saved = _repository.toggleFavorite(id);
    _pendingMessage = saved
        ? (willBeFavorite ? 'Ditambahkan ke favorit' : 'Dihapus dari favorit')
        : 'Gagal menyimpan. Silakan coba lagi.';
    notifyListeners();
    return saved;
  }

  /// Menandai sudah disiram hari ini. Mengembalikan false bila id tidak ada.
  bool markWatered(int id) {
    final saved = _repository.markWatered(id);
    _pendingMessage = saved
        ? 'Tanaman berhasil disiram'
        : 'Gagal menyimpan. Silakan coba lagi.';
    notifyListeners();
    return saved;
  }

  /// Menghapus tanaman. Mengembalikan false bila id tidak ada.
  bool delete(int id) {
    final saved = _repository.delete(id);
    _pendingMessage = saved
        ? 'Tanaman dihapus'
        : 'Gagal menyimpan. Silakan coba lagi.';
    notifyListeners();
    return saved;
  }

  /// Mengambil pesan sekali pakai agar SnackBar tidak muncul ulang.
  String? consumeMessage() {
    final message = _pendingMessage;
    _pendingMessage = null;
    return message;
  }

  @override
  void dispose() {
    _repository.plants.removeListener(_onPlantsChanged);
    super.dispose();
  }

  void _onPlantsChanged() => notifyListeners();

  bool _matches(Plant plant) {
    final keyword = _query.trim().toLowerCase();
    final matchesQuery =
        keyword.isEmpty ||
        plant.name.toLowerCase().contains(keyword) ||
        plant.species.toLowerCase().contains(keyword);

    final matchesFilter = switch (_filter) {
      PlantFilter.all => true,
      PlantFilter.indoor => plant.category == PlantCategory.indoor,
      PlantFilter.outdoor => plant.category == PlantCategory.outdoor,
      PlantFilter.needsWater => plant.status == WateringStatus.needsWater,
    };

    return matchesQuery && matchesFilter;
  }

  void _sort(List<Plant> items) {
    switch (_sortOrder) {
      case SortOrder.mostUrgent:
        items.sort((a, b) {
          final byDays = a.daysUntilWatering.compareTo(b.daysUntilWatering);
          if (byDays != 0) return byDays;
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
      case SortOrder.nameAsc:
        items.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
    }
  }
}
