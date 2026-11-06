import 'package:flutter/foundation.dart';

import '../utils/date_utils.dart';
import 'dummy_data.dart';
import 'models/plant.dart';
import 'network_exception.dart';

/// Penyimpanan tanaman in-memory. Satu instance dipakai seluruh aplikasi.
class PlantRepository {
  PlantRepository({List<Plant>? initial})
      : _plants = ValueNotifier<List<Plant>>(
          List<Plant>.of(initial ?? DummyData.initialPlants()),
        );

  final ValueNotifier<List<Plant>> _plants;

  /// Sumber data tunggal. ViewModel mendengarkan lewat addListener.
  ValueListenable<List<Plant>> get plants => _plants;

  /// Saklar simulasi offline dari layar Profil.
  bool simulateOffline = false;

  /// Simulasi pemuatan: delay 1 detik, melempar [NetworkException] bila offline.
  Future<List<Plant>> loadPlants() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (simulateOffline) throw const NetworkException();
    return List<Plant>.unmodifiable(_plants.value);
  }

  /// Mengembalikan tanaman dengan [id], atau null bila tidak ada.
  Plant? getById(int id) {
    for (final plant in _plants.value) {
      if (plant.id == id) return plant;
    }
    return null;
  }

  /// Menambah tanaman dan mengembalikan objek dengan ID baru (tertinggi + 1).
  Plant add(Plant plant) {
    final created = plant.copyWith(id: _nextId());
    _plants.value = List<Plant>.of([..._plants.value, created]);
    return created;
  }

  /// Mengganti tanaman dengan id yang sama. Mengembalikan false bila id tidak ada.
  bool update(Plant plant) {
    final index = _plants.value.indexWhere((item) => item.id == plant.id);
    if (index < 0) return false;

    final updated = List<Plant>.of(_plants.value);
    updated[index] = plant;
    _plants.value = updated;
    return true;
  }

  /// Menghapus tanaman. Favorit ikut hilang karena diturunkan dari daftar yang sama.
  bool delete(int id) {
    if (getById(id) == null) return false;
    _plants.value = List<Plant>.of(
      _plants.value.where((plant) => plant.id != id),
    );
    return true;
  }

  /// Membalik status favorit. Mengembalikan false bila id tidak ada.
  bool toggleFavorite(int id) {
    final plant = getById(id);
    if (plant == null) return false;
    return update(plant.copyWith(isFavorite: !plant.isFavorite));
  }

  /// Menandai tanaman sudah disiram hari ini. Mengembalikan false bila id tidak ada.
  bool markWatered(int id) {
    final plant = getById(id);
    if (plant == null) return false;
    return update(plant.copyWith(lastWateredDate: dateOnly(DateTime.now())));
  }

  /// Melepas [ValueNotifier] saat repository tidak lagi dipakai.
  void dispose() => _plants.dispose();

  int _nextId() {
    final current = _plants.value;
    if (current.isEmpty) return 1;

    var maxId = current.first.id;
    for (final plant in current) {
      if (plant.id > maxId) maxId = plant.id;
    }
    return maxId + 1;
  }
}
