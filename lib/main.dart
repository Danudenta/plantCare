import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'app/app_messenger.dart';
import 'data/plant_repository.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/plant_viewmodel.dart';
import 'viewmodels/settings_viewmodel.dart';

/// Provider bersama untuk seluruh layar.
class PlantCareRoot extends StatelessWidget {
  const PlantCareRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PlantRepository>(
          create: (_) => PlantRepository(),
          dispose: (_, repository) => repository.dispose(),
        ),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(
          create: (context) =>
              SettingsViewModel(context.read<PlantRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => PlantViewModel(context.read<PlantRepository>()),
        ),
      ],
      child: const PlantCareApp(),
    );
  }
}

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (details) {
      FlutterError.dumpErrorToConsole(details);
      showGlobalError();
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('$error');
      showGlobalError();
      return true;
    };

    initializeDateFormatting('id_ID').then((_) {
      runApp(const PlantCareRoot());
    });
  }, (error, stack) {
    debugPrint('$error');
    showGlobalError();
  });
}
