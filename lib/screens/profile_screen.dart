import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/constants/app_colors.dart';
import '../models/user_profile_model.dart';
import '../widgets/confirmation_dialog.dart';

/// Halaman Profil Pengguna dengan fitur edit data diri dan foto (Kamera/Galeri)
class ProfileScreen extends StatefulWidget {
  final UserProfileModel profile;
  final ValueChanged<UserProfileModel> onUpdateProfile;

  const ProfileScreen({
    super.key,
    required this.profile,
    required this.onUpdateProfile,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _groupController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _landAreaController;
  String? _currentPhotoPath;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) {
      _initializeFields();
    }
  }

  void _initializeFields() {
    _nameController = TextEditingController(text: widget.profile.nama);
    _groupController = TextEditingController(text: widget.profile.kelompokTani);
    _addressController = TextEditingController(text: widget.profile.alamat);
    _phoneController = TextEditingController(text: widget.profile.nomorTelepon);
    _landAreaController = TextEditingController(text: widget.profile.luasLahan.toString());
    _currentPhotoPath = widget.profile.fotoPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groupController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _landAreaController.dispose();
    super.dispose();
  }

  /// Menampilkan menu modal untuk memilih sumber foto (Kamera atau Galeri)
  void _showImagePickerSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ubah Foto Profil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Pilih sumber gambar untuk memperbarui foto profil petani Anda:',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.plantation100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: AppColors.plantation800),
                  ),
                  title: const Text(
                    'Ambil Foto dari Kamera',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Buka kamera gawai dan potret langsung foto baru'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.camera);
                  },
                ),
                const Divider(height: 12),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.earth100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.photo_library_rounded, color: AppColors.earth800),
                  ),
                  title: const Text(
                    'Pilih Foto dari Galeri',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Jelajahi berkas gambar pada memori perangkat Anda'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                if (_currentPhotoPath != null) ...[
                  const Divider(height: 12),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE4E6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
                    ),
                    title: const Text(
                      'Hapus Foto Profil',
                      style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.danger),
                    ),
                    subtitle: const Text('Kembalikan tampilan avatar ke inisial nama'),
                    onTap: () {
                      Navigator.pop(ctx);
                      _removeProfilePhoto();
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Mengeksekusi pemilihan gambar melalui ImagePicker
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? selected = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (selected != null) {
        if (!mounted) return;
        setState(() {
          _currentPhotoPath = selected.path;
        });

        // Langsung simpan ke model profil lokal
        final updated = widget.profile.copyWith(fotoPath: selected.path);
        widget.onUpdateProfile(updated);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.plantation700,
            content: Text('Foto profil berhasil diperbarui!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.danger,
          content: Text('Gagal mengakses sumber foto: $e'),
        ),
      );
    }
  }

  /// Menghapus foto profil lokal dengan dialog konfirmasi
  Future<void> _removeProfilePhoto() async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Hapus Foto Profil',
      message: 'Apakah Anda yakin ingin menghapus foto profil dan kembali menggunakan avatar inisial?',
      confirmText: 'Ya, Hapus',
      cancelText: 'Batal',
      icon: Icons.delete_outline_rounded,
      iconColor: AppColors.danger,
      confirmButtonColor: AppColors.danger,
    );

    if (!confirmed) return;
    if (!mounted) return;

    setState(() {
      _currentPhotoPath = null;
    });
    final updated = widget.profile.copyWith(clearFoto: true);
    widget.onUpdateProfile(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.plantation700,
        content: Text('Foto profil berhasil dihapus.'),
      ),
    );
  }

  /// Menyimpan formulir pembaruan data diri dengan konfirmasi
  Future<void> _saveProfileChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Konfirmasi Simpan Profil',
      message: 'Apakah seluruh data profil yang Anda masukkan sudah benar dan ingin disimpan?',
      confirmText: 'Ya, Simpan',
      cancelText: 'Periksa Lagi',
      icon: Icons.save_outlined,
      iconColor: AppColors.plantation700,
    );

    if (!confirmed) return;
    if (!mounted) return;

    final updated = widget.profile.copyWith(
      nama: _nameController.text.trim(),
      kelompokTani: _groupController.text.trim(),
      alamat: _addressController.text.trim(),
      nomorTelepon: _phoneController.text.trim(),
      luasLahan: double.tryParse(_landAreaController.text.trim()) ?? widget.profile.luasLahan,
      fotoPath: _currentPhotoPath,
    );

    widget.onUpdateProfile(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.plantation700,
        content: Text('Data profil Anda berhasil disimpan secara lokal!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Menampilkan dialog konfirmasi keluar aplikasi / logout lokal
  Future<void> _onLogoutWithConfirmation() async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Konfirmasi Keluar',
      message: 'Apakah Anda ingin mengakhiri sesi dan keluar dari aplikasi SiKePang?',
      confirmText: 'Keluar',
      cancelText: 'Tetap di Sini',
      icon: Icons.logout_rounded,
      iconColor: AppColors.danger,
      confirmButtonColor: AppColors.danger,
    );

    if (!confirmed) return;
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.plantation700,
        content: Text('Sesi lokal ditutup. Anda dapat masuk kembali kapan saja.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            tooltip: 'Keluar Akun',
            onPressed: _onLogoutWithConfirmation,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Area Avatar dan Penggantian Foto Profil
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.plantation600, AppColors.leaf500],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x20000000),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: _buildAvatarImage(),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _showImagePickerSourceSheet,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.plantation800,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Identitas Dasar
            Text(
              widget.profile.nama,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.profile.email,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.plantation100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'PERAN: ${widget.profile.role}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.plantation800,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Formulir Perubahan Data Diri
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informasi Data Diri Petani',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Ubah data profil Anda di bawah ini lalu tekan tombol Simpan Perubahan.',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 18),

                      // Nama Lengkap
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Lengkap',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Nama lengkap tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Kelompok Tani
                      TextFormField(
                        controller: _groupController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Kelompok Tani',
                          prefixIcon: Icon(Icons.groups_outlined),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Kelompok tani wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Alamat
                      TextFormField(
                        controller: _addressController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Alamat Tempat Tinggal / Lahan',
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Alamat tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Nomor Telepon
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Nomor Telepon / WhatsApp',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Nomor telepon wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Luas Lahan
                      TextFormField(
                        controller: _landAreaController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Luas Lahan Garapan (Hektar)',
                          prefixIcon: Icon(Icons.square_foot_outlined),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Luas lahan wajib diisi';
                          }
                          if (double.tryParse(val.trim()) == null) {
                            return 'Masukkan nilai desimal yang valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 22),

                      // Tombol Simpan
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _saveProfileChanges,
                          icon: const Icon(Icons.save_rounded),
                          label: const Text('Simpan Perubahan Data Diri'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarImage() {
    if (_currentPhotoPath != null) {
      if (!kIsWeb) {
        final file = File(_currentPhotoPath!);
        if (file.existsSync()) {
          return Image.file(
            file,
            fit: BoxFit.cover,
            width: 110,
            height: 110,
          );
        }
      }
      // Fallback jika berupa image XFile / network / cross-platform
      return Image.network(
        _currentPhotoPath!,
        fit: BoxFit.cover,
        width: 110,
        height: 110,
        errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
      );
    }
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    final initial = widget.profile.nama.isNotEmpty
        ? widget.profile.nama.substring(0, 1).toUpperCase()
        : 'P';
    return Center(
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 42,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
