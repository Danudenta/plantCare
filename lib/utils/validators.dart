// Fungsi validasi murni. Mengembalikan pesan error, atau null bila valid.
// Spasi di ujung diabaikan; teks yang hanya berisi spasi dianggap kosong.

const String demoUsername = 'admin';
const String demoPassword = '123456';

/// VAL-01. Username login tidak boleh kosong.
String? validateUsername(String? value) {
  if ((value ?? '').trim().isEmpty) return 'Username tidak boleh kosong';
  return null;
}

/// VAL-02. Password login tidak boleh kosong.
String? validatePassword(String? value) {
  if ((value ?? '').trim().isEmpty) return 'Password tidak boleh kosong';
  return null;
}

/// VAL-03. Kredensial dummy harus admin / 123456.
///
/// Mengembalikan null bila field masih kosong, agar error kosong tetap di field.
String? validateCredentials(String? username, String? password) {
  final user = (username ?? '').trim();
  final pass = (password ?? '').trim();
  if (user.isEmpty || pass.isEmpty) return null;
  if (user == demoUsername && pass == demoPassword) return null;
  return 'Username atau password salah';
}

/// VAL-04 dan VAL-10. Nama tanaman, 2 s.d. 40 karakter.
String? validatePlantName(String? value) {
  final text = (value ?? '').trim();
  if (text.isEmpty) return 'Nama tanaman wajib diisi';
  if (text.length < 2 || text.length > 40) {
    return 'Nama minimal 2 dan maksimal 40 karakter';
  }
  return null;
}

/// VAL-05 dan VAL-10. Jenis tanaman, wajib dan maksimal 50 karakter.
String? validateSpecies(String? value) {
  final text = (value ?? '').trim();
  if (text.isEmpty) return 'Jenis tanaman wajib diisi';
  if (text.length > 50) return 'Jenis maksimal 50 karakter';
  return null;
}

/// VAL-06 dan VAL-10. Lokasi, wajib dan maksimal 30 karakter.
String? validateLocation(String? value) {
  final text = (value ?? '').trim();
  if (text.isEmpty) return 'Lokasi wajib diisi';
  if (text.length > 30) return 'Lokasi maksimal 30 karakter';
  return null;
}

/// VAL-07, VAL-08, dan VAL-10. Interval siram, angka bulat 1 s.d. 90.
String? validateWateringInterval(String? value) {
  final text = (value ?? '').trim();
  final interval = int.tryParse(text);
  if (interval == null) return 'Interval harus berupa angka';
  if (interval < 1 || interval > 90) {
    return 'Interval harus antara 1 dan 90 hari';
  }
  return null;
}

/// VAL-09. Catatan opsional, maksimal 200 karakter.
String? validateNotes(String? value) {
  final text = (value ?? '').trim();
  if (text.length > 200) return 'Catatan maksimal 200 karakter';
  return null;
}
