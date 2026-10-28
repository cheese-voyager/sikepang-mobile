import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/dummy_data.dart';
import '../models/stock_model.dart';
import '../widgets/confirmation_dialog.dart';

/// Halaman Pencatatan Data Panen & Stok Pangan
class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  late List<StockModel> _stockList;

  @override
  void initState() {
    super.initState();
    _stockList = List.from(DummyData.initialStocks);
  }

  void _showAddStockDialog() {
    final formKey = GlobalKey<FormState>();
    final commodityController = TextEditingController(text: 'Beras Premium');
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    String selectedType = 'MASUK';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Catat Transaksi Panen',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(bottomSheetContext),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Jenis Transaksi
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setModalState(() => selectedType = 'MASUK'),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedType == 'MASUK'
                                    ? AppColors.plantation100
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedType == 'MASUK'
                                      ? AppColors.plantation700
                                      : AppColors.border,
                                  width: selectedType == 'MASUK' ? 2 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'PANEN MASUK',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: selectedType == 'MASUK'
                                        ? AppColors.plantation800
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => setModalState(() => selectedType = 'KELUAR'),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedType == 'KELUAR'
                                    ? const Color(0xFFFFE4E6)
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedType == 'KELUAR'
                                      ? AppColors.danger
                                      : AppColors.border,
                                  width: selectedType == 'KELUAR' ? 2 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'STOK KELUAR',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: selectedType == 'KELUAR'
                                        ? AppColors.danger
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Nama Komoditas
                    DropdownButtonFormField<String>(
                      initialValue: commodityController.text,
                      decoration: const InputDecoration(labelText: 'Komoditas Pangan'),
                      items: DummyData.commodities.map((c) {
                        return DropdownMenuItem(
                          value: c.namaKomoditas,
                          child: Text(c.namaKomoditas),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => commodityController.text = val);
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    // Jumlah
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Jumlah (Kg)',
                        hintText: 'Contoh: 150',
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Jumlah panen wajib diisi';
                        }
                        if (int.tryParse(val.trim()) == null) {
                          return 'Masukkan angka bulat yang valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    // Catatan
                    TextFormField(
                      controller: noteController,
                      decoration: const InputDecoration(
                        labelText: 'Catatan Lokasi / Blok Lahan',
                        hintText: 'Contoh: Panen sawah blok timur',
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Tombol Simpan dengan Konfirmasi
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          final amount = int.parse(amountController.text.trim());
                          final commodity = commodityController.text;
                          final note = noteController.text.trim().isEmpty
                              ? 'Pencatatan panen mandiri'
                              : noteController.text.trim();

                          // Tampilkan Pop up Konfirmasi
                          final confirmed = await ConfirmationDialog.show(
                            context: bottomSheetContext,
                            title: 'Konfirmasi Catatan Panen',
                            message: 'Simpan transaksi $selectedType sebesar $amount Kg untuk $commodity?',
                            confirmText: 'Ya, Simpan',
                            cancelText: 'Periksa Kembali',
                            icon: Icons.check_circle_outline,
                            iconColor: AppColors.plantation700,
                          );

                          if (confirmed && mounted) {
                            setState(() {
                              _stockList.insert(
                                0,
                                StockModel(
                                  id: DateTime.now().millisecondsSinceEpoch,
                                  namaKomoditas: commodity,
                                  jumlah: amount,
                                  satuan: 'Kg',
                                  jenisTransaksi: selectedType,
                                  tanggal: 'Hari ini',
                                  catatan: note,
                                ),
                              );
                            });
                            if (bottomSheetContext.mounted) {
                              Navigator.pop(bottomSheetContext);
                            }
                            if (mounted) {
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: AppColors.plantation700,
                                  content: Text('Transaksi panen berhasil disimpan secara lokal!'),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('Simpan Transaksi'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Panen & Stok Pangan'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.plantation700,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Catat Panen'),
        onPressed: _showAddStockDialog,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemCount: _stockList.length,
        itemBuilder: (context, index) {
          final item = _stockList[index];
          final isMasuk = item.jenisTransaksi == 'MASUK';

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isMasuk
                          ? AppColors.plantation100
                          : const Color(0xFFFFE4E6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isMasuk ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                      color: isMasuk ? AppColors.plantation700 : AppColors.danger,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.namaKomoditas,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '${isMasuk ? '+' : '-'}${item.jumlah} ${item.satuan}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isMasuk ? AppColors.plantation700 : AppColors.danger,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.catatan,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 12,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.tanggal,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isMasuk
                                    ? AppColors.plantation100
                                    : const Color(0xFFFFE4E6),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item.jenisTransaksi,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: isMasuk ? AppColors.plantation800 : AppColors.danger,
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
          );
        },
      ),
    );
  }
}
