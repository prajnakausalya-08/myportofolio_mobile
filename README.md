# MyPortfolio Mobile

MyPortfolio Mobile adalah aplikasi mobile portofolio pribadi saya yang dibuat menggunakan Flutter. Proyek ini melanjutkan Tutorial 08 dan menampilkan identitas saya, Prajna Kausalya Damdami (2506657213, PBP F), serta menu portofolio untuk melihat atau menambahkan data proyek dan pendidikan. Aplikasi ini belum terhubung ke backend atau autentikasi.

## Teknologi

- Flutter dan Dart dengan Material Design 3.
- `flutter_test` untuk widget test dan `flutter_lints` untuk memeriksa kode.

## Struktur proyek

- `lib/main.dart`: titik masuk aplikasi, `MyApp`, dan tema.
- `lib/screens/`: halaman utama serta form proyek dan pendidikan.
- `lib/widgets/`: drawer dan kartu aksi yang digunakan kembali pada halaman aplikasi.
- `test/widget_test.dart`: tes navigasi, validasi form, dialog, dan layar kecil.
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
- Menu Lihat Proyek, Tambah Proyek, Tambah Pendidikan, dan Logout dengan ikon serta warna yang berbeda.
- Form Tambah Pendidikan dengan lima field, validasi input, dan dialog ringkasan data.
- Navigasi ke form pendidikan dari kartu aksi dan drawer, serta navigasi kembali ke halaman utama.
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

### Tugas 8

1. `Navigator.push()` menambahkan halaman baru di atas halaman saat ini sehingga tombol Back dapat kembali ke halaman sebelumnya. Kartu Tambah Pendidikan membuka `EducationFormPage` dengan `push()`. `Navigator.pushReplacement()` mengganti halaman yang sedang aktif; opsi Home pada drawer menutup drawer lalu mengganti halaman form dengan halaman utama. `Navigator.pop()` menutup halaman atau dialog teratas, seperti saat pengguna menekan Tutup di dialog ringkasan.

2. Setiap halaman memakai `Scaffold` sebagai kerangka, `AppBar` sebagai bagian judul, dan `LeftDrawer` yang sama untuk navigasi. Warna utama indigo dari tema dipakai pada AppBar halaman utama dan halaman Tambah Pendidikan, serta tombol Simpan.

3. Form memakai `Column` agar urutan field mudah diikuti, `Padding` dan `SizedBox` untuk memberi ruang antarbagian, serta `SingleChildScrollView` agar seluruh field dan tombol Simpan tetap dapat dicapai pada layar sempit atau saat keyboard tampil.

4. `GlobalKey<FormState>` menghubungkan tombol Simpan dengan state `Form`. Setiap `validator` memeriksa nilai field, lalu `validate()` menjalankan semua validator dan hanya membuka dialog jika semuanya lolos. Contohnya, nama sekolah yang hanya berisi spasi dan tahun mulai 2025 dengan tahun selesai 2022 akan ditolak. Keyboard numerik membantu memasukkan tahun, tetapi tidak menjamin nilainya bilangan bulat yang valid; karena itu nilai tetap diparsing dengan `int.tryParse()` dan diperiksa rentangnya serta urutan tahunnya.

### AI Disclosure Tugas 8

AI digunakan sebagai pendamping belajar selama pengerjaan tugas. Saya memanfaatkannya untuk menganalisis kebutuhan tugas, memahami konsep dan widget Flutter yang digunakan, mendiskusikan pendekatan implementasi, mengevaluasi kode, serta membantu memahami error yang muncul selama proses pengerjaan. Melalui diskusi tersebut, saya dapat memahami alasan di balik setiap implementasi dan memperbaiki masalah secara bertahap. AI berperan sebagai teman belajar dan diskusi, bukan sebagai pihak yang diminta mengerjakan seluruh tugas secara otomatis. Saya tetap memeriksa hasil implementasi dan menjalankan pengujian sendiri; `flutter analyze` berhasil dengan hasil *No issues found* dan `flutter test` berhasil dengan seluruh test passed.

### Log Prompting Tugas 8

1. Saya berdiskusi dengan AI untuk memahami instruksi Tugas 8 dan konsep yang dipelajari pada Tutorial 09, khususnya penggunaan Form, validasi input, dan navigasi antarhalaman di Flutter.
2. Saya menggunakan AI untuk mempelajari bagaimana atribut pada model Education dapat diterapkan menjadi field pada form serta menentukan validasi yang sesuai untuk setiap input.
3. Selama proses pengerjaan, saya berdiskusi mengenai hubungan antara halaman Home, drawer, dan halaman Tambah Pendidikan agar lebih memahami alur navigasi menggunakan Navigator.
4. Ketika menemukan error pada pengujian, saya berdiskusi dengan AI untuk memahami penyebabnya dan mempertimbangkan perbaikan yang sesuai. Setelah itu, saya mencoba kembali pengujian di lingkungan lokal.
