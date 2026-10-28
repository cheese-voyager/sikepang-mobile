import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/dummy_data.dart';
import '../models/user_profile_model.dart';
import '../widgets/commodity_item_card.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/stat_card.dart';

/// Halaman Beranda (Dashboard) SiKePang
class DashboardScreen extends StatelessWidget {
  final UserProfileModel profile;
  final VoidCallback onNavigateToStock;
  final VoidCallback onNavigateToDistribution;

  const DashboardScreen({
    super.key,
    required this.profile,
    required this.onNavigateToStock,
    required this.onNavigateToDistribution,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.plantation500.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.eco, color: AppColors.leaf400, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SiKePang',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Portal Petani Komunitas',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.plantation200,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
            tooltip: 'Notifikasi',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sistem informasi lokal: tidak ada notifikasi baru.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Selamat Datang
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.plantation900, AppColors.plantation700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.plantation500.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.plantation400.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified, size: 12, color: AppColors.leaf400),
                            const SizedBox(width: 4),
                            Text(
                              profile.role,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        profile.kelompokTani,
                        style: const TextStyle(
                          color: AppColors.plantation200,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Halo, ${profile.nama}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Pantau panen pangan dan ketersediaan stok komunitas Anda hari ini.',
                    style: TextStyle(
                      color: AppColors.plantation100,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Ringkasan Statistik
            const Text(
              'Ringkasan Aktivitas Pertanian',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Total Stok Masuk',
                    value: '1.250',
                    unit: 'Kg',
                    icon: Icons.move_to_inbox_rounded,
                    accentColor: AppColors.plantation600,
                    subtitle: '+12% bulan ini',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Total Disalurkan',
                    value: '330',
                    unit: 'Kg',
                    icon: Icons.local_shipping_outlined,
                    accentColor: AppColors.info,
                    subtitle: '4 pengiriman',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Komoditas Terdata',
                    value: '${DummyData.commodities.length}',
                    unit: 'Jenis',
                    icon: Icons.category_outlined,
                    accentColor: AppColors.earth700,
                    subtitle: 'Pangan pokok lokal',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Luas Lahan Olah',
                    value: '${profile.luasLahan}',
                    unit: 'Hektar',
                    icon: Icons.landscape_outlined,
                    accentColor: AppColors.leaf700,
                    subtitle: 'Lahan produktif aktif',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Tombol Aksi Cepat dengan Pop up Konfirmasi
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.plantation50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.plantation200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.plantation800, size: 28),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Uji Coba Dialog Konfirmasi',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.plantation900,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Tekan tombol untuk menguji pop-up konfirmasi aksi lokal.',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.plantation700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final confirmed = await ConfirmationDialog.show(
                        context: context,
                        title: 'Konfirmasi Sinkronisasi Lokal',
                        message: 'Apakah Anda ingin memperbarui ringkasan statistik panen lokal sekarang?',
                        confirmText: 'Ya, Sinkronkan',
                        cancelText: 'Batal',
                        icon: Icons.sync_rounded,
                        iconColor: AppColors.plantation700,
                      );
                      if (confirmed && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: AppColors.plantation700,
                            content: Text('Statistik panen lokal berhasil disinkronkan!'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Uji Pop-up'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Daftar Komoditas Pangan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Katalog Komoditas Pangan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${DummyData.commodities.length} Komoditas',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.plantation700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...DummyData.commodities.take(4).map(
                  (c) => CommodityItemCard(commodity: c),
                ),
          ],
        ),
      ),
    );
  }
}
