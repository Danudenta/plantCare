import 'package:flutter/material.dart';

import '../app/theme/app_colors.dart';
import 'app_logo.dart';

/// Tampilan daftar kosong.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.emoji,
    required this.title,
    required this.message,
  });

  final String emoji;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EmojiMark(emoji: emoji, size: 88, fontSize: 40),
            const SizedBox(height: 12),
            Text(title, style: textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(color: AppColors.muted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
