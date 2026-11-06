import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:plantcare/data/models/plant.dart';
import 'package:plantcare/utils/date_utils.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID');
  });

  Plant sample({required DateTime lastWatered, int interval = 5}) {
    return Plant(
      id: 1,
      name: 'Monstera',
      species: 'Monstera deliciosa',
      category: PlantCategory.indoor,
      location: 'Ruang Tamu',
      emoji: '🌿',
      wateringIntervalDays: interval,
      lastWateredDate: lastWatered,
    );
  }

  DateTime daysFromToday(int days) {
    final today = dateOnly(DateTime.now());
    return DateTime(today.year, today.month, today.day + days);
  }

  test('daysBetween memakai tanggal UTC dan mengabaikan jam', () {
    final from = DateTime(2026, 11, 3, 23, 30);
    final to = DateTime(2026, 11, 6, 1, 15);
    expect(daysBetween(from, to), 3);
    expect(daysBetween(to, from), -3);
  });

  test('formatLongDate memakai bahasa Indonesia', () {
    expect(formatLongDate(DateTime(2026, 11, 3, 15, 45)), 'Selasa, 3 November 2026');
  });

  test('status perlu disiram saat tepat jatuh tempo', () {
    final plant = sample(lastWatered: daysFromToday(-5));
    expect(plant.nextWateringDate, dateOnly(DateTime.now()));
    expect(plant.daysUntilWatering, 0);
    expect(plant.status, WateringStatus.needsWater);
  });

  test('status aman bila jadwal masih besok', () {
    final plant = sample(lastWatered: daysFromToday(-4));
    expect(plant.daysUntilWatering, 1);
    expect(plant.status, WateringStatus.safe);
  });

  test('status perlu disiram dan hari negatif bila terlambat', () {
    final plant = sample(lastWatered: daysFromToday(-7));
    expect(plant.daysUntilWatering, -2);
    expect(plant.status, WateringStatus.needsWater);
  });

  test('nextWateringDate melewati batas bulan', () {
    final plant = sample(
      lastWatered: DateTime(2026, 1, 30),
      interval: 3,
    );
    expect(plant.nextWateringDate, DateTime(2026, 2, 2));
  });

  test('copyWith hanya mengganti field yang diberikan', () {
    final plant = sample(lastWatered: daysFromToday(-1));
    final copied = plant.copyWith(
      name: 'Lidah Mertua',
      isFavorite: true,
      notes: 'Jangan terlalu basah',
    );

    expect(copied.name, 'Lidah Mertua');
    expect(copied.isFavorite, isTrue);
    expect(copied.notes, 'Jangan terlalu basah');
    expect(copied.id, plant.id);
    expect(copied.species, plant.species);
    expect(copied.lastWateredDate, plant.lastWateredDate);
  });
}
