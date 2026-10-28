import '../models/commodity_model.dart';
import '../models/distribution_model.dart';
import '../models/stock_model.dart';
import '../models/user_profile_model.dart';

/// Kumpulan data tiruan lokal (mock dummy) yang mengadaptasi mockData frontend web SiKePang
class DummyData {
  /// Data profil default pengguna peran Petani
  static const UserProfileModel initialProfile = UserProfileModel(
    nama: 'Budi Santoso',
    email: 'budi@sikepang.id',
    role: 'PETANI',
    kelompokTani: 'Tani Makmur',
    alamat: 'Desa Sukamaju, Kec. Ciamis, Jawa Barat',
    nomorTelepon: '081234567890',
    luasLahan: 2.5,
    fotoPath: null,
  );

  /// Daftar komoditas pangan lokal
  static const List<CommodityModel> commodities = [
    CommodityModel(
      id: 1,
      namaKomoditas: 'Beras Premium',
      kategori: 'Padi-padian',
      satuan: 'Kg',
      hargaPerSatuan: 14000,
      deskripsi: 'Beras varietas IR-64 hasil panen sawah irigasi teknis',
      stokTersedia: 700,
    ),
    CommodityModel(
      id: 2,
      namaKomoditas: 'Jagung Pipil Kering',
      kategori: 'Padi-padian',
      satuan: 'Kg',
      hargaPerSatuan: 6500,
      deskripsi: 'Jagung pipil kadar air rendah untuk pakan dan industri olahan',
      stokTersedia: 250,
    ),
    CommodityModel(
      id: 3,
      namaKomoditas: 'Cabai Merah Keriting',
      kategori: 'Sayuran',
      satuan: 'Kg',
      hargaPerSatuan: 45000,
      deskripsi: 'Cabai merah segar pilihan tanpa pestisida kimia berlebih',
      stokTersedia: 80,
    ),
    CommodityModel(
      id: 4,
      namaKomoditas: 'Kedelai Lokal Kuning',
      kategori: 'Kacang-kacangan',
      satuan: 'Kg',
      hargaPerSatuan: 12000,
      deskripsi: 'Kedelai lokal non-GMO untuk bahan baku tahu dan tempe',
      stokTersedia: 150,
    ),
    CommodityModel(
      id: 5,
      namaKomoditas: 'Bawang Merah Brebes',
      kategori: 'Sayuran',
      satuan: 'Kg',
      hargaPerSatuan: 35000,
      deskripsi: 'Bawang merah umbi padat dengan aroma kuat dan tahan simpan',
      stokTersedia: 120,
    ),
    CommodityModel(
      id: 6,
      namaKomoditas: 'Singkong Organik',
      kategori: 'Umbi-umbian',
      satuan: 'Kg',
      hargaPerSatuan: 3500,
      deskripsi: 'Singkong empuk kualitas konsumsi keluarga dan UMKM keripik',
      stokTersedia: 300,
    ),
  ];

  /// Riwayat transaksi stok panen masuk dan keluar
  static const List<StockModel> initialStocks = [
    StockModel(
      id: 1,
      namaKomoditas: 'Beras Premium',
      jumlah: 500,
      satuan: 'Kg',
      jenisTransaksi: 'MASUK',
      tanggal: '28 Okt 2026',
      catatan: 'Hasil panen musim tanam kedua blok barat',
    ),
    StockModel(
      id: 2,
      namaKomoditas: 'Cabai Merah Keriting',
      jumlah: 50,
      satuan: 'Kg',
      jenisTransaksi: 'MASUK',
      tanggal: '27 Okt 2026',
      catatan: 'Pemetikan perdana lahan percontohan',
    ),
    StockModel(
      id: 3,
      namaKomoditas: 'Beras Premium',
      jumlah: 100,
      satuan: 'Kg',
      jenisTransaksi: 'KELUAR',
      tanggal: '26 Okt 2026',
      catatan: 'Penyaluran ke Pasar Induk Ciamis',
    ),
    StockModel(
      id: 4,
      namaKomoditas: 'Jagung Pipil Kering',
      jumlah: 200,
      satuan: 'Kg',
      jenisTransaksi: 'MASUK',
      tanggal: '25 Okt 2026',
      catatan: 'Panen serentak kelompok tani',
    ),
    StockModel(
      id: 5,
      namaKomoditas: 'Kedelai Lokal Kuning',
      jumlah: 150,
      satuan: 'Kg',
      jenisTransaksi: 'MASUK',
      tanggal: '24 Okt 2026',
      catatan: 'Hasil tumpangsari sawah tadah hujan',
    ),
  ];

  /// Riwayat pengiriman / distribusi pangan
  static const List<DistributionModel> initialDistributions = [
    DistributionModel(
      id: 1,
      tujuan: 'Pasar Induk Ciamis',
      namaKomoditas: 'Beras Premium',
      jumlah: 100,
      satuan: 'Kg',
      tanggal: '28 Okt 2026',
      status: 'SELESAI',
      catatan: 'Tiba tepat waktu dan diterima oleh pengelola pasar',
    ),
    DistributionModel(
      id: 2,
      tujuan: 'BULOG Regional Garut',
      namaKomoditas: 'Jagung Pipil Kering',
      jumlah: 150,
      satuan: 'Kg',
      tanggal: '29 Okt 2026',
      status: 'DIKIRIM',
      catatan: 'Armada pengangkut telah bergerak menuju gudang BULOG',
    ),
    DistributionModel(
      id: 3,
      tujuan: 'Koperasi Desa Mekarjaya',
      namaKomoditas: 'Kedelai Lokal Kuning',
      jumlah: 50,
      satuan: 'Kg',
      tanggal: '29 Okt 2026',
      status: 'DIPROSES',
      catatan: 'Tahap pengemasan dalam karung bertanda',
    ),
    DistributionModel(
      id: 4,
      tujuan: 'Pasar Tradisional Tasikmalaya',
      namaKomoditas: 'Cabai Merah Keriting',
      jumlah: 30,
      satuan: 'Kg',
      tanggal: '30 Okt 2026',
      status: 'MENUNGGU',
      catatan: 'Menunggu konfirmasi ketersediaan armada pick-up',
    ),
  ];
}

