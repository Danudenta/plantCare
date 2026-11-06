import 'package:flutter/foundation.dart';

import '../../utils/date_utils.dart';

/// Kategori lokasi tanaman.
enum PlantCategory {
  indoor('Indoor'),
  outdoor('Outdoor');

  const PlantCategory(this.label);

  /// Teks yang tampil di UI.
  final String label;
}

/// Status penyiraman yang dihitung dari tanggal.
enum WateringStatus { needsWater, safe }

/// Model tanaman. Bersifat immutable; perubahan dibuat lewat [copyWith].
@immutable
class Plant {
  const Plant({
    required this.id,
    required this.name,
    required this.species,
    required this.category,
    required this.location,
    required this.emoji,
    required this.wateringIntervalDays,
    required this.lastWateredDate,
    this.notes = '',
    this.isFavorite = false,
  });

  final int id;
  final String name;
  final String species;
  final PlantCategory category;
  final String location;
  final String emoji;
  final int wateringIntervalDays;
  final DateTime lastWateredDate;
  final String notes;
  final bool isFavorite;

  /// Jadwal siram berikutnya. Dart menangani pergantian bulan secara otomatis.
  DateTime get nextWateringDate => DateTime(
        lastWateredDate.year,
        lastWateredDate.month,
        lastWateredDate.day + wateringIntervalDays,
      );

  /// Sisa hari hingga jadwal siram. Nilai negatif berarti terlambat.
  int get daysUntilWatering => daysBetween(DateTime.now(), nextWateringDate);

  /// Status yang ditampilkan sebagai badge.
  WateringStatus get status =>
      daysUntilWatering <= 0 ? WateringStatus.needsWater : WateringStatus.safe;

  /// Salin objek dengan field tertentu diganti.
  Plant copyWith({
    int? id,
    String? name,
    String? species,
    PlantCategory? category,
    String? location,
    String? emoji,
    int? wateringIntervalDays,
    DateTime? lastWateredDate,
    String? notes,
    bool? isFavorite,
  }) {
    return Plant(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      category: category ?? this.category,
      location: location ?? this.location,
      emoji: emoji ?? this.emoji,
      wateringIntervalDays: wateringIntervalDays ?? this.wateringIntervalDays,
      lastWateredDate: lastWateredDate ?? this.lastWateredDate,
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
