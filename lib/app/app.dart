import 'package:flutter/material.dart';

import 'app_messenger.dart';
import 'router.dart';
import 'theme/app_theme.dart';

/// Root widget aplikasi.
class PlantCareApp extends StatefulWidget {
  const PlantCareApp({super.key});

  @override
  State<PlantCareApp> createState() => _PlantCareAppState();
}

class _PlantCareAppState extends State<PlantCareApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('Lifecycle: ${state.name}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PlantCare',
      theme: buildAppTheme(),
      routerConfig: appRouter,
      scaffoldMessengerKey: scaffoldMessengerKey,
      restorationScopeId: 'plantcare',
    );
  }
}
