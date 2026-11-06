import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare/data/models/plant.dart';
import 'package:plantcare/data/plant_repository.dart';
import 'package:plantcare/viewmodels/auth_viewmodel.dart';
import 'package:plantcare/viewmodels/plant_form_viewmodel.dart';
import 'package:plantcare/viewmodels/plant_viewmodel.dart';
import 'package:plantcare/viewmodels/settings_viewmodel.dart';

void main() {
  test('login kosong dan salah tidak membuat sesi', () async {
    final auth = AuthViewModel();

    expect(await auth.login('  ', '  '), isFalse);
    expect(auth.usernameError, 'Username tidak boleh kosong');
    expect(auth.passwordError, 'Password tidak boleh kosong');
    expect(auth.isLoggedIn, isFalse);

    expect(await auth.login('admin', 'salah'), isFalse);
    expect(auth.credentialsError, 'Username atau password salah');
    expect(auth.isLoading, isFalse);
    auth.dispose();
  });

  test('login benar menunggu sebentar lalu menyalakan sesi', () async {
    final auth = AuthViewModel();
    final result = auth.login('admin', '123456');
    expect(auth.isLoading, isTrue);

    expect(await result, isTrue);
    expect(auth.isLoggedIn, isTrue);
    expect(auth.isLoading, isFalse);

    auth.logout();
    expect(auth.isLoggedIn, isFalse);
    auth.dispose();
  });

  test('search, filter, dan ringkasan dihitung dari data yang sama', () {
    final repository = PlantRepository();
    final viewModel = PlantViewModel(repository);

    expect(viewModel.totalCount, 10);
    expect(viewModel.needsWaterCount, 4);
    expect(viewModel.favoriteCount, 4);

    viewModel.setQuery('  MON ');
    expect(viewModel.visiblePlants.map((plant) => plant.name), ['Monstera']);

    viewModel.setFilter(PlantFilter.outdoor);
    expect(viewModel.visiblePlants, isEmpty);

    viewModel.setQuery('');
    viewModel.setFilter(PlantFilter.needsWater);
    expect(viewModel.visiblePlants.map((plant) => plant.name), [
      'Lavender',
      'Bonsai Beringin',
      'Monstera',
      'Aglonema',
    ]);

    viewModel.setSortOrder(SortOrder.nameAsc);
    expect(viewModel.visiblePlants.first.name, 'Aglonema');
    viewModel.dispose();
    repository.dispose();
  });

  test('simulasi offline mengubah pemuatan menjadi error lalu sukses', () async {
    final repository = PlantRepository();
    final settings = SettingsViewModel(repository);
    final viewModel = PlantViewModel(repository);

    settings.setSimulateOffline(true);
    await viewModel.loadPlants();
    expect(viewModel.listState, isA<PlantListError>());
    expect(
      (viewModel.listState as PlantListError).message,
      'Tidak ada koneksi internet. Periksa jaringanmu lalu coba lagi.',
    );

    settings.setSimulateOffline(false);
    await viewModel.loadPlants();
    expect(viewModel.listState, isA<PlantListSuccess>());
    expect(viewModel.totalCount, 10);

    viewModel.dispose();
    settings.dispose();
    repository.dispose();
  });

  test('favorit dan siram memperbarui ringkasan serta pesan sekali pakai', () {
    final repository = PlantRepository();
    final viewModel = PlantViewModel(repository);

    expect(viewModel.markWatered(1), isTrue);
    expect(viewModel.consumeMessage(), 'Tanaman berhasil disiram');
    expect(viewModel.needsWaterCount, 3);
    expect(viewModel.consumeMessage(), isNull);

    expect(viewModel.toggleFavorite(2), isTrue);
    expect(viewModel.favoriteCount, 5);
    expect(viewModel.favoritePlants.any((plant) => plant.id == 2), isTrue);

    expect(viewModel.markWatered(404), isFalse);
    expect(viewModel.consumeMessage(), 'Gagal menyimpan. Silakan coba lagi.');

    viewModel.dispose();
    repository.dispose();
  });

  test('form menolak simpan tidak valid dan menambah tanaman yang valid', () async {
    final repository = PlantRepository();
    final form = PlantFormViewModel(repository);
    form.load(-1);

    form.updateName('A');
    expect(form.state.errors[FormField.name], isNotNull);
    expect(await form.save(), isFalse);
    expect(repository.plants.value, hasLength(10));

    form.updateName('Lidah Buaya');
    form.updateSpecies('Aloe vera');
    form.updateLocation('Dapur');
    form.updateInterval('7');
    form.updateCategory(PlantCategory.indoor);
    expect(form.isDirty, isTrue);

    final firstSave = form.save();
    final duplicateSave = form.save();
    expect(await firstSave, isTrue);
    expect(await duplicateSave, isFalse);
    expect(form.consumeMessage(), 'Tanaman berhasil ditambahkan');
    expect(repository.plants.value, hasLength(11));
    expect(repository.getById(11)?.name, 'Lidah Buaya');
    expect(form.isDirty, isFalse);

    final edit = PlantFormViewModel(repository);
    edit.load(1);
    expect(edit.isEditing, isTrue);
    edit.updateLocation('Balkon');
    expect(await edit.save(), isTrue);
    expect(edit.consumeMessage(), 'Perubahan disimpan');
    expect(repository.getById(1)?.location, 'Balkon');
    expect(repository.getById(1)?.isFavorite, isTrue);

    final missing = PlantFormViewModel(repository);
    missing.load(404);
    expect(missing.notFound, isTrue);

    form.dispose();
    edit.dispose();
    missing.dispose();
    repository.dispose();
  });
}
