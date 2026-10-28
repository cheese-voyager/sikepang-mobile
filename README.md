# SiKePang Mobile (Sistem Informasi Ketahanan Pangan Komunitas)

Aplikasi mobile SiKePang merupakan implementasi antarmuka klien berbasis Flutter yang mengadaptasi rancangan desain antarmuka web SiKePang (Sistem Informasi Ketahanan Pangan Komunitas). Proyek ini dirancang secara khusus untuk memfasilitasi kebutuhan praktikum Pemrograman Mobile Semester 5 dengan fokus pada pemahaman konsep dasar arsitektur widget, manajemen status lokal (local state management), navigasi bertingkat, dialog konfirmasi modal, kalkulator fungsi aritmetika dan konversi satuan, serta integrasi pemilihan citra (kamera dan galeri).

## 1. Arsitektur dan Struktur Direktori

Aplikasi ini menggunakan pola arsitektur berlapis yang memisahkan tanggung jawab antarmuka, model data, dan konstanta utilitas:

- `lib/core/constants/app_colors.dart`: Menyimpan representasi palet warna resmi SiKePang (Plantation Green, Leaf Accent, Earth Brown).
- `lib/core/theme/app_theme.dart`: Mengonfigurasi ThemeData Material 3 global untuk konsistensi visual.
- `lib/models/`: Berisi struktur data objek murni (UserProfileModel, CommodityModel, StockModel, DistributionModel).
- `lib/data/dummy_data.dart`: Menyediakan himpunan data simulasi awal yang merefleksikan data web SiKePang.
- `lib/widgets/`: Menyediakan widget modular yang dapat digunakan berulang (ConfirmationDialog, StatCard, CommodityItemCard).
- `lib/screens/`: Menyimpan setiap halaman antarmuka utama aplikasi:
  - `main_navigation_screen.dart`: Mengontrol BottomNavigationBar 5 tab navigasi.
  - `dashboard_screen.dart`: Tab Beranda dengan ringkasan panen, luas lahan, dan katalog komoditas.
  - `stock_screen.dart`: Tab Data Panen untuk mencatat transaksi panen masuk dan keluar.
  - `distribution_screen.dart`: Tab Distribusi untuk memantau status pengiriman pangan.
  - `calculator_screen.dart`: Tab Kalkulator aritmetika dan konversi satuan massa panen.
  - `profile_screen.dart`: Tab Profil untuk memperbarui identitas petani serta foto profil melalui kamera atau galeri.

## 2. Panduan Menjalankan Aplikasi

Anda dapat menjalankan aplikasi ini melalui terminal pada direktori proyek dengan langkah:

1. Buka terminal PowerShell pada direktori `c:\KULIAH\Semester 5\Pemrograman Mobile\sikepangMobile`.
2. Pastikan gawai Android fisik atau emulator Android telah terhubung dan aktif.
3. Jalankan perintah `flutter pub get` untuk memastikan seluruh pustaka dependensi terpasang.
4. Jalankan perintah `flutter run` untuk memulai kompilasi dan peluncuran aplikasi ke gawai target.
