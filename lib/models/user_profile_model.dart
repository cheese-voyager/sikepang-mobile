/// Model data untuk profil pengguna / petani SiKePang
class UserProfileModel {
  final String nama;
  final String email;
  final String role;
  final String kelompokTani;
  final String alamat;
  final String nomorTelepon;
  final double luasLahan;
  final String? fotoPath;

  const UserProfileModel({
    required this.nama,
    required this.email,
    required this.role,
    required this.kelompokTani,
    required this.alamat,
    required this.nomorTelepon,
    required this.luasLahan,
    this.fotoPath,
  });

  /// Menggandakan objek dengan properti yang diperbarui
  UserProfileModel copyWith({
    String? nama,
    String? email,
    String? role,
    String? kelompokTani,
    String? alamat,
    String? nomorTelepon,
    double? luasLahan,
    String? fotoPath,
    bool clearFoto = false,
  }) {
    return UserProfileModel(
      nama: nama ?? this.nama,
      email: email ?? this.email,
      role: role ?? this.role,
      kelompokTani: kelompokTani ?? this.kelompokTani,
      alamat: alamat ?? this.alamat,
      nomorTelepon: nomorTelepon ?? this.nomorTelepon,
      luasLahan: luasLahan ?? this.luasLahan,
      fotoPath: clearFoto ? null : (fotoPath ?? this.fotoPath),
    );
  }
}

