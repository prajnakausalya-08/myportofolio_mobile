# MyPortfolio Mobile

MyPortfolio Mobile adalah aplikasi mobile portofolio pribadi saya yang dibuat menggunakan Flutter. Proyek ini melanjutkan Tutorial 08 dan menampilkan identitas saya, Prajna Kausalya Damdami (2506657213, PBP F), serta tiga menu portofolio. Untuk Tugas 7, tombol-tombolnya baru menampilkan SnackBar dan belum terhubung ke backend atau autentikasi.

## Teknologi

- Flutter dan Dart dengan Material Design 3.
- `flutter_test` untuk widget test dan `flutter_lints` untuk memeriksa kode.

## Struktur proyek

- `lib/main.dart`: titik masuk aplikasi, `MyApp`, dan tema.
- `lib/menu.dart`: halaman utama, model menu, serta kartu identitas dan menu.
- `test/widget_test.dart`: tes tampilan, warna, interaksi, dan layar kecil.
- `pubspec.yaml`: konfigurasi SDK dan dependensi.
- `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/`: konfigurasi untuk masing-masing platform.

## Setup dan menjalankan

Pastikan Flutter SDK yang terpasang memenuhi persyaratan Dart di `pubspec.yaml`, lalu siapkan Chrome atau perangkat lain yang didukung Flutter. Dari folder `myportofolio_mobile`, jalankan:

```bash
flutter pub get
flutter run -d chrome
```

Untuk memformat dan memeriksa kode serta menjalankan tes:

```bash
dart format lib test
flutter analyze
flutter test
```

## Fitur

- Tiga kartu identitas: NPM, nama, dan kelas.
- Menu Lihat Proyek, Tambah Proyek, dan Logout dengan ikon dan warna yang berbeda.
- SnackBar yang menampilkan nama tombol yang ditekan. Jika tombol lain ditekan, pesan sebelumnya disembunyikan.
- Layout yang menyesuaikan lebar layar dan bisa digulir pada layar kecil. Tombol Logout saat ini hanya menampilkan SnackBar.

## Pertanyaan reflektif

### Tugas 7

1. Widget tree adalah susunan widget yang membentuk tampilan aplikasi. Sebuah widget bisa memiliki satu `child` atau beberapa `children`, dan setiap anak juga bisa memiliki anak lagi. Di proyek ini, `MyApp` membangun `MaterialApp` dengan `MyHomePage` sebagai `home`. Halaman tersebut membangun `Scaffold`, lalu body-nya berisi `Column` yang menyusun kartu identitas dan menu. Dari hubungan ini, Flutter tahu bagaimana menyusun tampilan dan memperbaruinya saat diperlukan.

2. Widget yang saya gunakan secara langsung dalam kode aplikasi adalah:

   - `MyApp` mengatur aplikasi dan temanya, sedangkan `MyHomePage` membuat halaman utama.
   - `MaterialApp` menyediakan konfigurasi aplikasi Material. `Scaffold` menyediakan kerangka halaman, termasuk tempat untuk `AppBar`, body, dan SnackBar. `AppBar` menampilkan judul di bagian atas.
   - `LayoutBuilder` membaca lebar yang tersedia untuk menentukan jumlah kolom menu. `SingleChildScrollView` membuat isi halaman bisa digulir, `Center` memusatkan isi, dan `ConstrainedBox` membatasi lebar konten pada layar besar.
   - `Column` menyusun widget secara vertikal. `Wrap` menyusun kartu identitas dan memindahkannya ke baris berikutnya jika ruang tidak cukup. `GridView.count` menyusun kartu menu dalam grid.
   - `InfoCard` adalah komponen kartu identitas yang dipakai ulang. `SizedBox` mengatur lebar atau memberi jarak, `Card` membuat permukaan kartu, `Padding` memberi ruang di sekitar isi, dan `Text` menampilkan tulisan.
   - `ItemCard` adalah komponen kartu menu yang dipakai ulang. `Material` menyediakan permukaan berwarna dan dasar efek sentuh, `InkWell` menangani sentuhan, `Icon` menampilkan ikon, dan `SnackBar` menampilkan pesan sementara.

   `ItemHomepage` sendiri adalah model data, bukan widget. Sementara itu, `StatelessWidget` adalah kelas dasar untuk widget yang saya buat, dan `ThemeData`, `Color`, serta `TextStyle` adalah objek konfigurasi.

3. `MaterialApp` menyiapkan konfigurasi yang dipakai bersama oleh aplikasi Material, seperti tema dan navigasi. Karena itu, widget ini biasanya diletakkan dekat akar aplikasi agar halaman-halaman di bawahnya bisa memakai konfigurasi yang sama. Di proyek ini, `MyApp` mengatur tema Material 3 melalui `MaterialApp` dan menjadikan `MyHomePage` sebagai `home`. Widget di bawahnya bisa mengambil tema tersebut lewat `Theme.of(context)`.

4. `StatelessWidget` tidak memiliki objek `State` untuk menyimpan keadaan lokal yang berubah. Tampilannya mengikuti konfigurasi dan konteks saat `build` dipanggil. Saya menggunakannya untuk `MyHomePage`, `InfoCard`, dan `ItemCard` karena data yang ditampilkan di halaman ini tetap. Widget stateless tetap bisa dibangun ulang jika induk atau dependensinya berubah.

   `StatefulWidget` memiliki objek `State` yang bisa berubah selama widget berada di tree. Widget ini cocok saat perlu menyimpan keadaan lokal, misalnya nilai input atau pilihan yang berubah, lalu memperbarui tampilan dengan `setState`. Pada proyek ini, SnackBar dikelola oleh `ScaffoldMessenger`, jadi `ItemCard` tidak perlu menyimpan state sendiri untuk menampilkannya.

5. `BuildContext` menunjukkan posisi widget di dalam tree. Melalui context, widget bisa mencari informasi atau layanan yang tersedia dari widget leluhurnya. Metode `build` menerima context untuk widget yang sedang dibangun. Contohnya, `Theme.of(context)` di halaman utama mengambil tema aplikasi, sedangkan `ScaffoldMessenger.of(context)` di `ItemCard` digunakan untuk menyembunyikan SnackBar sebelumnya dan menampilkan pesan baru. Context harus berada di bawah penyedia yang ingin dicari agar pemanggilan tersebut berhasil.

6. Hot reload memasukkan perubahan kode ke aplikasi yang sedang berjalan dan membangun ulang tampilannya sambil berusaha mempertahankan state. Ini membantu saat saya menyesuaikan UI. Hot restart menjalankan ulang aplikasi Dart dari awal sehingga state di memori hilang; ini berguna jika perubahan inisialisasi atau state tidak terlihat lewat hot reload. Untuk perubahan kode native, dependensi tertentu, atau konfigurasi platform, aplikasi mungkin perlu dihentikan dan dijalankan ulang sepenuhnya agar proses build dan inisialisasi native dilakukan lagi.

### AI Disclosure Tugas 7

Saya menggunakan ChatGPT untuk membantu memahami instruksi tugas dan struktur widget, mengaudit kode Tutorial 08, menyusun instruksi implementasi, serta membahas jawaban reflektif. Saya juga menggunakan bantuan GPT untuk menyusun dan meninjau perubahan kode secara langsung, termasuk `ItemHomepage`, `ItemCard`, layout, widget test, dan dokumentasi, serta membantu mengidentifikasi masalah saat validasi.

Saya tetap memeriksa dan berusaha memahami hasilnya, lalu menjalankan analisis dan pengujian sendiri melalui Terminal lokal. Di lingkungan bantuan AI, Dart VM sempat berhenti dengan error `cpuinfo_macos.cc`, sehingga formatter, analyzer, dan tes tidak bisa berjalan di sana. Saya kemudian memvalidasi ulang secara lokal: `flutter analyze` menghasilkan *No issues found* dan `flutter test` melewati empat tes. Saya juga mengevaluasi pilihan tampilan dan memilih kembali desain yang menurut saya paling sesuai. Pengalaman ini mengingatkan saya bahwa saran AI dan hasil pemeriksaannya tetap perlu dicek sesuai kondisi proyek dan lingkungan yang saya gunakan.

### Log Prompting Tugas 7

1. Saya meminta bantuan untuk memahami tugas dan mengaudit kode Tutorial 08.
2. Saya menyusun instruksi implementasi yang mencakup identitas, menu, layout, dokumentasi, dan pengujian.
3. Saya meminta bantuan GPT untuk menerapkan perubahan, lalu mengevaluasi tampilan dan memilih desain yang saya inginkan.
4. Saya meninjau hasilnya dan menjalankan analisis serta tes kembali melalui Terminal lokal setelah validasi di lingkungan bantuan AI terkendala.
