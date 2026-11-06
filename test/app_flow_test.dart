import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:plantcare/app/router.dart';
import 'package:plantcare/main.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID');
  });

  tearDown(() {
    appRouter.go(Routes.splash);
  });

  testWidgets('login divalidasi lalu dashboard menampilkan ringkasan', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    appRouter.go(Routes.splash);
    await tester.pumpWidget(const PlantCareRoot());
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.text('Selamat Datang'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pump();
    expect(find.text('Username tidak boleh kosong'), findsOneWidget);
    expect(find.text('Password tidak boleh kosong'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'admin');
    await tester.enterText(find.byType(TextField).at(1), 'salah');
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pump();
    expect(find.text('Username atau password salah'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(1), '123456');
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('Halo, Admin 👋'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('Lavender'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'mon');
    await tester.pump();
    expect(find.text('Monstera'), findsOneWidget);
    expect(find.text('Lavender'), findsNothing);
  });
}
