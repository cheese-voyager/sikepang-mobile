import 'dart:typed_data';

/// Model data untuk profil pengguna atau petani SiKePang
class UserProfileModel {
  final String nama;
  final String email;
  final String role;
  final String kelompokTani;
  final String alamat;
  final String nomorTelepon;
  final double luasLahan;
  final String? fotoPath;
  final Uint8List? fotoBytes;

  const UserProfileModel({
    required this.nama,
    required this.email,
    required this.role,
    required this.kelompokTani,
    required this.alamat,
    required this.nomorTelepon,
    required this.luasLahan,
    this.fotoPath,
    this.fotoBytes,
  });

  /// Menggandakan objek profil dengan atribut yang diperbarui
  UserProfileModel copyWith({
    String? nama,
    String? email,
    String? role,
    String? kelompokTani,
    String? alamat,
    String? nomorTelepon,
    double? luasLahan,
    String? fotoPath,
    Uint8List? fotoBytes,
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
      fotoBytes: clearFoto ? null : (fotoBytes ?? this.fotoBytes),
    );
  }
}
