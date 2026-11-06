# PlantCare

Aplikasi Android untuk mencatat koleksi tanaman hias, memantau jadwal penyiraman, dan menandai tanaman favorit. Data bersifat dummy dan hanya hidup di memori selama aplikasi berjalan.

## Fitur

- Login dummy (`admin` / `123456`) dengan validasi input.
- Dashboard: ringkasan, pencarian, filter, urutan, dan daftar tanaman.
- Tambah, ubah, dan hapus tanaman.
- Tandai sudah disiram dan favorit.
- Simulasi offline untuk menguji tampilan tanpa koneksi.
- Tujuh layar: Splash, Login, Beranda, Detail, Form, Favorit, dan Profil.

## Menjalankan

```bash
flutter pub get
flutter run
```

Untuk berkas rilis:

```bash
flutter build apk
```

## Pengujian

```bash
flutter analyze
flutter test
```

Cakupan otomatis: validasi `VAL-01` s.d. `VAL-10`, perhitungan jadwal tanaman, CRUD repository, ViewModel, widget reusable, serta alur login sampai ringkasan Dashboard.

## Struktur folder

```text
lib/
├── main.dart
├── app/            tema, rute, shell navigasi
├── data/           model, data awal, repository in-memory
├── viewmodels/     state layar
├── screens/        tujuh layar
├── widgets/        komponen yang dipakai ulang
└── utils/          tanggal dan validasi
test/               unit test dan widget test
```

## Asumsi

- Target Android API 24 ke atas. `minSdk` diatur di `android/app/build.gradle.kts` karena Flutter 3.47 membuat proyek Gradle Kotlin, bukan `build.gradle` Groovy.
- Tidak ada basis data. Menutup aplikasi mengembalikan 10 data awal.
- Nama pembuat di dialog Tentang ada di `appCreatorName` pada `lib/screens/profile_screen.dart`.
- Urutan daftar (paling mendesak atau nama) ikut tersedia. Tema gelap tidak dibuat.
- Pada hari pertama, ringkasan menampilkan total 10 dan perlu disiram 4: Monstera, Aglonema, Lavender, dan Bonsai Beringin.
