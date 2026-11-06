import 'package:flutter/material.dart';

/// Messenger di atas seluruh rute, termasuk untuk error tak terduga.
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Menampilkan pesan umum tanpa menjatuhkan aplikasi.
void showGlobalError() {
  final messenger = scaffoldMessengerKey.currentState;
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      const SnackBar(content: Text('Terjadi kesalahan. Coba lagi.')),
    );
}
