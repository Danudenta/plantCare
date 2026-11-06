import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../viewmodels/plant_viewmodel.dart';
import 'app_messenger.dart';
import 'theme/app_colors.dart';

/// Kerangka tab. Bottom bar tetap, SnackBar aksi tanaman dipasang sekali.
class PlantShell extends StatefulWidget {
  const PlantShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<PlantShell> createState() => _PlantShellState();
}

class _PlantShellState extends State<PlantShell> {
  PlantViewModel? _plants;

  @override
  void initState() {
    super.initState();
    _plants = context.read<PlantViewModel>();
    _plants!.addListener(_onPlantsChanged);
  }

  @override
  void dispose() {
    _plants?.removeListener(_onPlantsChanged);
    super.dispose();
  }

  void _onPlantsChanged() {
    final message = _plants?.consumeMessage();
    if (message == null) return;
    scaffoldMessengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _onBack(bool didPop) {
    if (didPop) return;
    if (widget.navigationShell.currentIndex != 0) {
      widget.navigationShell.goBranch(0);
      return;
    }
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final navigationShell = widget.navigationShell;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) => _onBack(didPop),
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: navigationShell.goBranch,
          indicatorColor: AppColors.primaryContainer,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_outline),
              selectedIcon: Icon(Icons.favorite),
              label: 'Favorit',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
