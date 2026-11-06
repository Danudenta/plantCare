import 'package:flutter/material.dart';

import '../app/theme/app_colors.dart';

/// Logo aplikasi. Emoji diletakkan di lingkaran agar tetap simetris.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 96,
    this.onPrimary = false,
  });

  final double size;
  final bool onPrimary;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Logo PlantCare',
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: onPrimary ? AppColors.onPrimary : AppColors.primaryContainer,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          '🌱',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: size * 0.5, height: 1),
        ),
      ),
    );
  }
}

/// Lingkaran emoji tanaman, dipakai di kartu dan detail.
class EmojiMark extends StatelessWidget {
  const EmojiMark({
    super.key,
    required this.emoji,
    required this.size,
    required this.fontSize,
  });

  final String emoji;
  final double size;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Text(
        emoji,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: fontSize, height: 1),
      ),
    );
  }
}
