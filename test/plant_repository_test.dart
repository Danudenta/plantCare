import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare/data/dummy_data.dart';
import 'package:plantcare/data/models/plant.dart';
import 'package:plantcare/data/network_exception.dart';
import 'package:plantcare/data/plant_repository.dart';
import 'package:plantcare/utils/date_utils.dart';

Plant draftPlant({int id = 0}) {
  return Plant(
    id: id,
    name: 'Lidah Buaya',
    species: 'Aloe vera',
    category: PlantCategory.indoor,
    location: 'Dapur',
    emoji: '🪴',
    wateringIntervalDays: 7,
    lastWateredDate: dateOnly(DateTime.now()),
  );
}

void main() {
  test('data awal berisi 10 tanaman dan 4 perlu disiram', () {
    final plants = DummyData.initialPlants();
    final needsWater = plants
        .where((plant) => plant.status == WateringStatus.needsWater)
        .map((plant) => plant.name)
        .toList();

    expect(plants, hasLength(10));
    expect(needsWater, [
      'Monstera',
      'Aglonema',
      'Lavender',
      'Bonsai Beringin',
    ]);
    expect(
      plants.where((plant) => plant.isFavorite).map((plant) => plant.id),
      [1, 3, 6, 9],
    );
  });

  test('add memakai ID tertinggi ditambah 1', () {
    final repository = PlantRepository();
    final created = repository.add(draftPlant(id: 99));

    expect(created.id, 11);
    expect(repository.getById(11)?.name, 'Lidah Buaya');
    expect(repository.plants.value, hasLength(11));
    repository.dispose();
  });

  test('add pada daftar kosong mulai dari ID 1', () {
    final repository = PlantRepository(initial: []);
    final first = repository.add(draftPlant());
    final second = repository.add(draftPlant());

    expect(first.id, 1);
    expect(second.id, 2);
    repository.dispose();
  });

  test('update, favorit, siram, dan hapus mengubah data yang sama', () {
    final repository = PlantRepository();
    var notifications = 0;
    repository.plants.addListener(() => notifications++);

    expect(
      repository.update(draftPlant(id: 404).copyWith(name: 'Tidak Ada')),
      isFalse,
    );
    expect(repository.toggleFavorite(404), isFalse);
    expect(repository.markWatered(404), isFalse);
    expect(repository.delete(404), isFalse);

    final monstera = repository.getById(1)!;
    expect(monstera.isFavorite, isTrue);
    expect(repository.toggleFavorite(1), isTrue);
    expect(repository.getById(1)!.isFavorite, isFalse);

    expect(repository.markWatered(1), isTrue);
    final watered = repository.getById(1)!;
    expect(dateOnly(watered.lastWateredDate), dateOnly(DateTime.now()));
    expect(watered.status, WateringStatus.safe);

    expect(
      repository.update(watered.copyWith(location: 'Balkon')),
      isTrue,
    );
    expect(repository.getById(1)!.location, 'Balkon');

    expect(repository.delete(1), isTrue);
    expect(repository.getById(1), isNull);
    expect(repository.plants.value, hasLength(9));
    expect(notifications, 4);
    repository.dispose();
  });

  test('loadPlants gagal saat simulasi offline dan berhasil setelah dimatikan', () async {
    final repository = PlantRepository(initial: [draftPlant(id: 1)]);
    repository.simulateOffline = true;

    await expectLater(repository.loadPlants(), throwsA(isA<NetworkException>()));

    repository.simulateOffline = false;
    final loaded = await repository.loadPlants();
    expect(loaded, hasLength(1));
    expect(loaded.single.name, 'Lidah Buaya');
    repository.dispose();
  });
}
