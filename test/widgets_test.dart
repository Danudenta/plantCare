import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare/app/theme/app_theme.dart';
import 'package:plantcare/data/models/plant.dart';
import 'package:plantcare/utils/date_utils.dart';
import 'package:plantcare/viewmodels/plant_viewmodel.dart';
import 'package:plantcare/widgets/app_text_field.dart';
import 'package:plantcare/widgets/category_filter_row.dart';
import 'package:plantcare/widgets/confirm_dialog.dart';
import 'package:plantcare/widgets/empty_state.dart';
import 'package:plantcare/widgets/error_state.dart';
import 'package:plantcare/widgets/plant_card.dart';
import 'package:plantcare/widgets/status_badge.dart';
import 'package:plantcare/widgets/summary_card.dart';

void main() {
  Plant sample({required int interval, required int daysAgo, bool favorite = false}) {
    final today = dateOnly(DateTime.now());
    return Plant(
      id: 1,
      name: 'Monstera',
      species: 'Monstera deliciosa',
      category: PlantCategory.indoor,
      location: 'Ruang Tamu',
      emoji: '🌿',
      wateringIntervalDays: interval,
      lastWateredDate: DateTime(today.year, today.month, today.day - daysAgo),
      isFavorite: favorite,
    );
  }

  Widget wrap(Widget child) {
    return MaterialApp(theme: buildAppTheme(), home: Scaffold(body: child));
  }

  testWidgets('badge dan kartu menampilkan status serta jadwal', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      wrap(
        ListView(
          children: [
            const StatusBadge(status: WateringStatus.safe),
            PlantCard(
              plant: sample(interval: 5, daysAgo: 4),
              onTap: () {},
              onFavoriteTap: () {},
            ),
            PlantCard(
              plant: sample(interval: 5, daysAgo: 5),
              onTap: () {},
              onFavoriteTap: () {},
            ),
            PlantCard(
              plant: sample(interval: 5, daysAgo: 7, favorite: true),
              onTap: () {},
              onFavoriteTap: () {},
            ),
            PlantCard(
              plant: sample(interval: 5, daysAgo: 2),
              onTap: () {},
              onFavoriteTap: () {},
            ),
          ],
        ),
      ),
    );

    expect(find.text('Aman'), findsWidgets);
    expect(find.text('Perlu Disiram'), findsWidgets);
    expect(find.text('Siram besok'), findsOneWidget);
    expect(find.text('Siram hari ini'), findsOneWidget);
    expect(find.text('Terlambat 2 hari'), findsOneWidget);
    expect(find.text('Siram dalam 3 hari'), findsOneWidget);
    expect(find.byTooltip('Hapus dari favorit'), findsOneWidget);
  });

  testWidgets('filter, ringkasan, kosong, dan error merespons aksi', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    PlantFilter? picked;
    var retried = false;

    await tester.pumpWidget(
      wrap(
        ListView(
          children: [
            CategoryFilterRow(
              selected: PlantFilter.all,
              onSelected: (value) => picked = value,
            ),
            const SummaryCard(
              title: 'Perlu Disiram Hari Ini',
              value: '4',
              icon: Icons.water_drop_outlined,
              highlight: true,
            ),
            const EmptyState(
              emoji: '💚',
              title: 'Belum ada favorit',
              message: 'Tandai tanamanmu dari beranda.',
            ),
            ErrorState(message: 'Tidak ada koneksi internet.', onRetry: () => retried = true),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Perlu Disiram'));
    expect(picked, PlantFilter.needsWater);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('Belum ada favorit'), findsOneWidget);

    await tester.tap(find.text('Coba Lagi'));
    expect(retried, isTrue);
  });

  testWidgets('dialog konfirmasi hanya memanggil aksi saat disetujui', (tester) async {
    var confirmed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return FilledButton(
                onPressed: () => showConfirmDialog(
                  context: context,
                  title: 'Hapus tanaman?',
                  message: 'Tanaman akan dihapus dari koleksi.',
                  confirmText: 'Hapus',
                  isDestructive: true,
                  onConfirm: () => confirmed = true,
                ),
                child: const Text('Buka'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Buka'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    expect(confirmed, isFalse);

    await tester.tap(find.text('Buka'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();
    expect(confirmed, isTrue);
  });

  testWidgets('AppTextField menampilkan pesan error', (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      wrap(
        AppTextField(
          controller: controller,
          label: 'Nama',
          errorText: 'Nama tanaman wajib diisi',
        ),
      ),
    );

    expect(find.text('Nama tanaman wajib diisi'), findsOneWidget);
    controller.dispose();
  });
}
