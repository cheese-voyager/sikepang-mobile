/// Model data riwayat pengiriman / distribusi pangan SiKePang
class DistributionModel {
  final int id;
  final String tujuan;
  final String namaKomoditas;
  final int jumlah;
  final String satuan;
  final String tanggal;
  final String status; // 'SELESAI', 'DIKIRIM', 'DIPROSES', 'MENUNGGU'
  final String catatan;

  const DistributionModel({
    required this.id,
    required this.tujuan,
    required this.namaKomoditas,
    required this.jumlah,
    required this.satuan,
    required this.tanggal,
    required this.status,
    required this.catatan,
  });
}

