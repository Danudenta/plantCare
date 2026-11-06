import '../utils/date_utils.dart';
import 'models/plant.dart';

/// Sepuluh tanaman awal. Tanggal siram dihitung relatif terhadap hari ini.
class DummyData {
  const DummyData._();

  static List<Plant> initialPlants() {
    final today = dateOnly(DateTime.now());

    DateTime daysAgo(int days) =>
        DateTime(today.year, today.month, today.day - days);

    return [
      Plant(
        id: 1,
        name: 'Monstera',
        species: 'Monstera deliciosa',
        category: PlantCategory.indoor,
        location: 'Ruang Tamu',
        emoji: '🌿',
        wateringIntervalDays: 5,
        lastWateredDate: daysAgo(6),
        isFavorite: true,
      ),
      Plant(
        id: 2,
        name: 'Lidah Mertua',
        species: 'Sansevieria trifasciata',
        category: PlantCategory.indoor,
        location: 'Kamar',
        emoji: '🪴',
        wateringIntervalDays: 14,
        lastWateredDate: daysAgo(3),
      ),
      Plant(
        id: 3,
        name: 'Kaktus Mini',
        species: 'Cactaceae',
        category: PlantCategory.indoor,
        location: 'Meja Kerja',
        emoji: '🌵',
        wateringIntervalDays: 21,
        lastWateredDate: daysAgo(10),
        isFavorite: true,
      ),
      Plant(
        id: 4,
        name: 'Aglonema',
        species: 'Aglaonema commutatum',
        category: PlantCategory.indoor,
        location: 'Ruang Tamu',
        emoji: '🍀',
        wateringIntervalDays: 4,
        lastWateredDate: daysAgo(4),
      ),
      Plant(
        id: 5,
        name: 'Sirih Gading',
        species: 'Epipremnum aureum',
        category: PlantCategory.indoor,
        location: 'Dapur',
        emoji: '🌿',
        wateringIntervalDays: 7,
        lastWateredDate: daysAgo(2),
      ),
      Plant(
        id: 6,
        name: 'Lavender',
        species: 'Lavandula',
        category: PlantCategory.outdoor,
        location: 'Teras',
        emoji: '🌸',
        wateringIntervalDays: 3,
        lastWateredDate: daysAgo(5),
        isFavorite: true,
      ),
      Plant(
        id: 7,
        name: 'Peace Lily',
        species: 'Spathiphyllum',
        category: PlantCategory.indoor,
        location: 'Kamar',
        emoji: '🌼',
        wateringIntervalDays: 6,
        lastWateredDate: daysAgo(1),
      ),
      Plant(
        id: 8,
        name: 'Bonsai Beringin',
        species: 'Ficus microcarpa',
        category: PlantCategory.outdoor,
        location: 'Taman',
        emoji: '🌳',
        wateringIntervalDays: 2,
        lastWateredDate: daysAgo(3),
      ),
      Plant(
        id: 9,
        name: 'Mawar',
        species: 'Rosa',
        category: PlantCategory.outdoor,
        location: 'Taman Depan',
        emoji: '🌺',
        wateringIntervalDays: 2,
        lastWateredDate: daysAgo(0),
        isFavorite: true,
      ),
      Plant(
        id: 10,
        name: 'Bunga Matahari',
        species: 'Helianthus annuus',
        category: PlantCategory.outdoor,
        location: 'Halaman',
        emoji: '🌻',
        wateringIntervalDays: 3,
        lastWateredDate: daysAgo(1),
      ),
    ];
  }
}
