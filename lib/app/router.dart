import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/dashboard_screen.dart';
import '../screens/favorite_screen.dart';
import '../screens/login_screen.dart';
import '../screens/plant_detail_screen.dart';
import '../screens/plant_form_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/splash_screen.dart';
import 'plant_shell.dart';

/// Konstanta rute. Widget wajib memakai konstanta ini, bukan string mentah.
abstract final class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const favorites = '/favorites';
  static const profile = '/profile';
  static const plantDetail = '/plant/:id';
  static const plantForm = '/plant/form';

  static String plantDetailPath(int id) => '/plant/$id';

  static String plantFormPath({int plantId = -1}) =>
      '$plantForm?plantId=$plantId';
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Router aplikasi. Detail dan form berada di luar shell agar tanpa bottom bar.
final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  restorationScopeId: 'router',
  initialLocation: Routes.splash,
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return PlantShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.dashboard,
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.favorites,
              builder: (context, state) => const FavoriteScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    // Form dideklarasikan sebelum :id agar tidak tertangkap sebagai id "form".
    GoRoute(
      path: Routes.plantForm,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final plantId =
            int.tryParse(state.uri.queryParameters['plantId'] ?? '') ?? -1;
        return PlantFormScreen(plantId: plantId);
      },
    ),
    GoRoute(
      path: Routes.plantDetail,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return PlantDetailScreen(plantId: id);
      },
    ),
  ],
);
