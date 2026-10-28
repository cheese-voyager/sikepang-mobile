/// Model data transaksi stok panen SiKePang
class StockModel {
  final int id;
  final String namaKomoditas;
  final int jumlah;
  final String satuan;
  final String jenisTransaksi; // 'MASUK' atau 'KELUAR'
  final String tanggal;
  final String catatan;

  const StockModel({
    required this.id,
    required this.namaKomoditas,
    required this.jumlah,
    required this.satuan,
    required this.jenisTransaksi,
    required this.tanggal,
    required this.catatan,
  });
}

