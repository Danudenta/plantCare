# Arsitektur PlantCare

Aplikasi memakai MVVM. Widget hanya menampilkan state dan mengirim aksi. ViewModel (`ChangeNotifier`) memegang state layar. Repository menyimpan satu daftar tanaman di memori.

```text
Layar (Widget)
  | aksi pengguna
  v
ViewModel (Auth, Plant, PlantForm, Settings)
  | panggil method
  v
PlantRepository (ValueNotifier<List<Plant>>)
  |
  v
DummyData
```

Provider di `PlantCareRoot` membuat satu `PlantRepository`, `AuthViewModel`, `SettingsViewModel`, dan `PlantViewModel` untuk seluruh aplikasi. `PlantFormViewModel` dibuat di layar form dan ikut hilang saat layar ditutup.

Perubahan daftar memberi tahu `PlantViewModel`. Angka ringkasan bukan salinan data: `totalCount`, `needsWaterCount`, dan `favoriteCount` dihitung ulang dari daftar yang sama. Daftar yang tampil disaring di getter `visiblePlants`.

## Navigasi

`go_router` memakai konstanta di `Routes`.

| Rute | Layar | Bottom bar |
| :--- | :--- | :--- |
| `/splash` | Splash | Tidak |
| `/login` | Login | Tidak |
| `/dashboard` | Beranda | Ya |
| `/favorites` | Favorit | Ya |
| `/profile` | Profil | Ya |
| `/plant/:id` | Detail | Tidak |
| `/plant/form` | Tambah atau edit | Tidak |

Beranda, Favorit, dan Profil berada di `StatefulShellRoute.indexedStack`, jadi pindah tab tidak membuat ulang layar. Detail dan form memakai navigator root supaya bottom bar tidak ikut tampil. Back di login dan di tab Beranda menutup aplikasi. Back di tab lain kembali ke Beranda.

## State yang bertahan saat rotasi

Orientasi tidak membuat ulang proses Dart (`android:configChanges` memuat `orientation`). Selain itu:

- Teks login memakai `RestorationMixin` dan `RestorableTextEditingController`.
- Dialog hapus memakai `RestorableBool`.
- Pencarian, filter, dan urutan ada di `PlantViewModel`.
- Isi form ada di `PlantFormViewModel`.
- Posisi scroll daftar memakai `PageStorageKey`.

## Error

| ID | Perilaku |
| :--- | :--- |
| ERR-01 | Simulasi offline membuat `loadPlants` melempar `NetworkException`. Dashboard menampilkan `ErrorState` dan tombol Coba Lagi. |
| ERR-02 / ERR-03 | Id tidak ada atau bukan angka menampilkan "Tanaman tidak ditemukan". |
| ERR-04 | Daftar kosong menampilkan `EmptyState`. |
| ERR-05 | Siram, hapus, atau simpan yang gagal menampilkan SnackBar. |
| ERR-06 | Interval dibaca dengan `int.tryParse` dan dibatasi 3 digit. |
| ERR-07 | Tombol Masuk dan Simpan nonaktif selama proses berjalan. |
| ERR-08 | `FlutterError.onError`, `PlatformDispatcher.onError`, dan `runZonedGuarded` menampilkan SnackBar umum. |
