import 'package:intl/intl.dart';

/// Mengambil bagian tanggal saja (jam dan menit diset ke 00:00).
DateTime dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

/// Selisih jumlah hari dari [from] ke [to]. Hasil negatif bila [to] lebih awal.
///
/// Memakai [DateTime.utc] agar aman dari pergeseran waktu musim panas (DST).
int daysBetween(DateTime from, DateTime to) {
  final start = DateTime.utc(from.year, from.month, from.day);
  final end = DateTime.utc(to.year, to.month, to.day);
  return end.difference(start).inDays;
}

/// Format panjang berbahasa Indonesia, contoh: Selasa, 3 November 2026.
///
/// Panggil `initializeDateFormatting('id_ID')` sekali sebelum memakai fungsi ini.
String formatLongDate(DateTime date) {
  return DateFormat('EEEE, d MMMM y', 'id_ID').format(dateOnly(date));
}
