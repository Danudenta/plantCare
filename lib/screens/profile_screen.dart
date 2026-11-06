import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app/router.dart';
import '../app/theme/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/plant_viewmodel.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../widgets/confirm_dialog.dart';

/// Ganti nama ini bila aplikasi dipakai orang lain.
const String appCreatorName = 'Danu';

/// Profil dummy, statistik, simulasi offline, dan logout.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plants = context.watch<PlantViewModel>();
    final settings = context.watch<SettingsViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.primaryContainer,
            child: Text(
              'A',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text('Admin', style: Theme.of(context).textTheme.titleLarge),
          Text(
            'admin@plantcare.id',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.muted,
                ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _stat(context, 'Total tanaman', plants.totalCount),
                  _stat(context, 'Favorit', plants.favoriteCount),
                  _stat(context, 'Perlu disiram', plants.needsWaterCount),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Simulasi Offline'),
            subtitle: const Text(
              'Aktifkan untuk menguji tampilan error koneksi',
            ),
            value: settings.simulateOffline,
            onChanged: settings.setSimulateOffline,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Tentang Aplikasi'),
            trailing: const Icon(Icons.info_outline),
            onTap: () => _showAbout(context),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => _logout(context),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text('$value', style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }

  Future<void> _showAbout(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Tentang Aplikasi'),
          content: const Text(
            'PlantCare versi 1.0.0\nPembuat: $appCreatorName',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) {
    return showConfirmDialog(
      context: context,
      title: 'Logout?',
      message: 'Kamu akan keluar dari akun demo.',
      confirmText: 'Logout',
      onConfirm: () {
        context.read<AuthViewModel>().logout();
        context.go(Routes.login);
      },
    );
  }
}
