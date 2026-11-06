import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare/utils/validators.dart';

void main() {
  test('VAL-01 menolak username kosong atau spasi', () {
    expect(validateUsername(null), 'Username tidak boleh kosong');
    expect(validateUsername('   '), 'Username tidak boleh kosong');
    expect(validateUsername('admin'), isNull);
  });

  test('VAL-02 menolak password kosong atau spasi', () {
    expect(validatePassword(null), 'Password tidak boleh kosong');
    expect(validatePassword('   '), 'Password tidak boleh kosong');
    expect(validatePassword('123456'), isNull);
  });

  test('VAL-03 hanya muncul bila kedua field terisi dan salah', () {
    expect(validateCredentials('', ''), isNull);
    expect(validateCredentials('admin', ''), isNull);
    expect(validateCredentials('admin', 'salah'), 'Username atau password salah');
    expect(validateCredentials('Admin', '123456'), 'Username atau password salah');
    expect(validateCredentials(' admin ', ' 123456 '), isNull);
  });

  test('VAL-04 membatasi nama 2 sampai 40 karakter', () {
    expect(validatePlantName(' '), 'Nama tanaman wajib diisi');
    expect(validatePlantName('A'), 'Nama minimal 2 dan maksimal 40 karakter');
    expect(validatePlantName('A' * 41), 'Nama minimal 2 dan maksimal 40 karakter');
    expect(validatePlantName('AB'), isNull);
    expect(validatePlantName('A' * 40), isNull);
  });

  test('VAL-05 mewajibkan jenis dan membatasi 50 karakter', () {
    expect(validateSpecies('  '), 'Jenis tanaman wajib diisi');
    expect(validateSpecies('A' * 51), 'Jenis maksimal 50 karakter');
    expect(validateSpecies('A' * 50), isNull);
  });

  test('VAL-06 mewajibkan lokasi dan membatasi 30 karakter', () {
    expect(validateLocation('  '), 'Lokasi wajib diisi');
    expect(validateLocation('A' * 31), 'Lokasi maksimal 30 karakter');
    expect(validateLocation('A' * 30), isNull);
  });

  test('VAL-07 menolak interval kosong atau bukan angka', () {
    expect(validateWateringInterval(''), 'Interval harus berupa angka');
    expect(validateWateringInterval('   '), 'Interval harus berupa angka');
    expect(validateWateringInterval('abc'), 'Interval harus berupa angka');
    expect(validateWateringInterval('1.5'), 'Interval harus berupa angka');
  });

  test('VAL-08 membatasi interval 1 sampai 90', () {
    expect(validateWateringInterval('0'), 'Interval harus antara 1 dan 90 hari');
    expect(validateWateringInterval('91'), 'Interval harus antara 1 dan 90 hari');
    expect(
      validateWateringInterval('99999999999'),
      'Interval harus antara 1 dan 90 hari',
    );
    expect(validateWateringInterval('1'), isNull);
    expect(validateWateringInterval('90'), isNull);
    expect(validateWateringInterval(' 7 '), isNull);
  });

  test('VAL-09 membatasi catatan 200 karakter dan mengizinkan kosong', () {
    expect(validateNotes(''), isNull);
    expect(validateNotes('   '), isNull);
    expect(validateNotes('A' * 200), isNull);
    expect(validateNotes('A' * 201), 'Catatan maksimal 200 karakter');
  });

  test('VAL-10 menganggap spasi saja sebagai kosong pada field form', () {
    expect(validatePlantName('   '), 'Nama tanaman wajib diisi');
    expect(validateSpecies('\t'), 'Jenis tanaman wajib diisi');
    expect(validateLocation(' \n '), 'Lokasi wajib diisi');
    expect(validateWateringInterval('  '), 'Interval harus berupa angka');
    expect(validateNotes(' \n '), isNull);
  });
}
