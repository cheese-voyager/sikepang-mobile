/// Model data untuk komoditas pangan SiKePang
class CommodityModel {
  final int id;
  final String namaKomoditas;
  final String kategori;
  final String satuan;
  final int hargaPerSatuan;
  final String deskripsi;
  final int stokTersedia;

  const CommodityModel({
    required this.id,
    required this.namaKomoditas,
    required this.kategori,
    required this.satuan,
    required this.hargaPerSatuan,
    required this.deskripsi,
    required this.stokTersedia,
  });
}

