import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Tema Material 3. Warna seed ditimpa agar hex-nya tepat seperti palet.
ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
  ).copyWith(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.primary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onPrimary,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onPrimary,
    error: AppColors.error,
    onError: AppColors.onPrimary,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
  );

  const radius = 12.0;
  final roundedButton = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(radius),
  );
  final outline = OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius),
    borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.28)),
  );

  final baseText = Typography.material2021().black.apply(
        bodyColor: AppColors.onSurface,
        displayColor: AppColors.onSurface,
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.background,
    splashFactory: InkRipple.splashFactory,
    textTheme: baseText.copyWith(
      headlineSmall: baseText.headlineSmall?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.25,
      ),
      titleLarge: baseText.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: baseText.titleMedium?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: baseText.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      bodyLarge: baseText.bodyLarge?.copyWith(fontSize: 16, height: 1.4),
      bodyMedium: baseText.bodyMedium?.copyWith(fontSize: 14, height: 1.4),
      bodySmall: baseText.bodySmall?.copyWith(
        fontSize: 12,
        color: AppColors.muted,
        height: 1.35,
      ),
      labelSmall: baseText.labelSmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: AppColors.onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shadowColor: AppColors.onSurface.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 48),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.38),
        disabledForegroundColor: AppColors.onPrimary,
        elevation: 0,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        shape: roundedButton,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: roundedButton,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        shape: roundedButton,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: 2,
      highlightElevation: 4,
      shape: CircleBorder(),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      selectedColor: AppColors.primaryContainer,
      backgroundColor: AppColors.surface,
      side: BorderSide(color: AppColors.primary.withValues(alpha: 0.28)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.primaryContainer,
      height: 72,
      elevation: 8,
      shadowColor: AppColors.onSurface.withValues(alpha: 0.08),
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? AppColors.primary : AppColors.muted,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? AppColors.primary : AppColors.muted,
        );
      }),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(color: AppColors.muted),
      labelStyle: const TextStyle(color: AppColors.muted),
      floatingLabelStyle: const TextStyle(color: AppColors.primary),
      border: outline,
      enabledBorder: outline,
      focusedBorder: outline.copyWith(
        borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
      ),
      errorBorder: outline.copyWith(
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: outline.copyWith(
        borderSide: const BorderSide(color: AppColors.error, width: 1.6),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.onSurface,
      contentTextStyle: const TextStyle(color: AppColors.onPrimary, fontSize: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.primary.withValues(alpha: 0.12),
      space: 1,
      thickness: 1,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
  );
}
