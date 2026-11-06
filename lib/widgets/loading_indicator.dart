import 'package:flutter/material.dart';

import '../app/theme/app_colors.dart';

/// Indikator muat di tengah layar.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(semanticsLabel: 'Memuat'),
          SizedBox(height: 16),
          Text('Memuat...', style: TextStyle(color: AppColors.muted)),
        ],
      ),
    );
  }
}
