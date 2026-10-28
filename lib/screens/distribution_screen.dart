import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/dummy_data.dart';
import '../models/distribution_model.dart';
import '../widgets/confirmation_dialog.dart';

/// Halaman Riwayat Pengiriman & Distribusi Pangan Komunitas
class DistributionScreen extends StatefulWidget {
  const DistributionScreen({super.key});

  @override
  State<DistributionScreen> createState() => _DistributionScreenState();
}

class _DistributionScreenState extends State<DistributionScreen> {
  late List<DistributionModel> _distributions;

  @override
  void initState() {
    super.initState();
    _distributions = List.from(DummyData.initialDistributions);
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SELESAI':
        return AppColors.success;
      case 'DIKIRIM':
        return AppColors.info;
      case 'DIPROSES':
        return AppColors.warning;
      case 'MENUNGGU':
      default:
        return AppColors.danger;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toUpperCase()) {
      case 'SELESAI':
        return AppColors.plantation100;
      case 'DIKIRIM':
        return const Color(0xFFE0F2FE);
      case 'DIPROSES':
        return const Color(0xFFFEF3C7);
      case 'MENUNGGU':
      default:
        return const Color(0xFFFFE4E6);
    }
  }

  Future<void> _markAsCompleted(int index) async {
    final item = _distributions[index];
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Konfirmasi Penyelesaian',
      message: 'Apakah pengiriman komoditas ${item.namaKomoditas} ke ${item.tujuan} telah selesai diterima?',
      confirmText: 'Ya, Tandai Selesai',
      cancelText: 'Belum',
      icon: Icons.check_circle_outline,
      iconColor: AppColors.success,
    );

    if (!confirmed) return;
    if (!mounted) return;

    setState(() {
      _distributions[index] = DistributionModel(
        id: item.id,
        tujuan: item.tujuan,
        namaKomoditas: item.namaKomoditas,
        jumlah: item.jumlah,
        satuan: item.satuan,
        tanggal: item.tanggal,
        status: 'SELESAI',
        catatan: '${item.catatan} (Diselesaikan secara lokal)',
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.success,
        content: Text('Status distribusi berhasil diperbarui menjadi SELESAI.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Distribusi Pangan'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _distributions.length,
        itemBuilder: (context, index) {
          final item = _distributions[index];
          final statusColor = _getStatusColor(item.status);
          final statusBg = _getStatusBgColor(item.status);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.tujuan,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.inventory_2_outlined, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        '${item.namaKomoditas} (${item.jumlah} ${item.satuan})',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.notes_rounded, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.catatan,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20, color: AppColors.border),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 12, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            item.tanggal,
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                      if (item.status != 'SELESAI')
                        TextButton.icon(
                          onPressed: () => _markAsCompleted(index),
                          icon: const Icon(Icons.done_all, size: 16, color: AppColors.plantation700),
                          label: const Text(
                            'Tandai Selesai',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.plantation700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
