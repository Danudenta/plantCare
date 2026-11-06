import 'package:flutter/material.dart';

import '../app/theme/app_colors.dart';

/// Tampilan gagal memuat, dengan aksi untuk mencoba lagi.
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.message,
    required this.onRetry,
    this.actionLabel = 'Coba Lagi',
  });

  final String message;
  final VoidCallback onRetry;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 36,
                color: AppColors.error,
                semanticLabel: 'Terjadi kesalahan',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
