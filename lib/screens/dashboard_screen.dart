import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/dummy_data.dart';
import '../models/user_profile_model.dart';
import '../widgets/commodity_item_card.dart';
import '../widgets/stat_card.dart';

/// Halaman Beranda (Dashboard) SiKePang dengan tata letak bersih dan ringkas
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
              width: 32,
              height: 32,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.plantation200),
              ),
              child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
            ),
            const SizedBox(width: 10),
            const Text(
              'SiKePang',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kartu Profil Ringkas (Clean Greeting)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.plantation900, AppColors.plantation700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.plantation500,
                    backgroundImage: profile.fotoBytes != null
                        ? MemoryImage(profile.fotoBytes!)
                        : null,
                    child: profile.fotoBytes == null
                        ? Text(
                            profile.nama.isNotEmpty ? profile.nama[0].toUpperCase() : 'P',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.nama,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.plantation500.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                profile.role,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                profile.kelompokTani,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.plantation200,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 4 Kartu Metrik Statistik Panen
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Stok Masuk',
                    value: '1.250',
                    unit: 'Kg',
                    icon: Icons.inventory_2_outlined,
                    accentColor: AppColors.plantation600,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Tersalurkan',
                    value: '330',
                    unit: 'Kg',
                    icon: Icons.local_shipping_outlined,
                    accentColor: AppColors.info,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Komoditas',
                    value: '${DummyData.commodities.length}',
                    unit: 'Jenis',
                    icon: Icons.grass_rounded,
                    accentColor: AppColors.earth700,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Luas Lahan',
                    value: '${profile.luasLahan}',
                    unit: 'Ha',
                    icon: Icons.landscape_outlined,
                    accentColor: AppColors.leaf700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Daftar Komoditas Utama
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Komoditas Pangan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${DummyData.commodities.length} Terdata',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.plantation700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...DummyData.commodities.map((c) => CommodityItemCard(commodity: c)),
          ],
        ),
      ),
    );
  }
}
