import 'package:flutter/material.dart';

import '../app/theme/app_colors.dart';

/// Menampilkan dialog konfirmasi. [onConfirm] dipanggil hanya jika disetujui.
Future<void> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmText,
  required VoidCallback onConfirm,
  bool isDestructive = false,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: isDestructive
                ? FilledButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: AppColors.onPrimary,
                  )
                : null,
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onConfirm();
            },
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
}
