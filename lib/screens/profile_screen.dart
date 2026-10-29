import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants/app_colors.dart';
import '../models/user_profile_model.dart';
import '../widgets/confirmation_dialog.dart';
import 'auth_screen.dart';
import 'camera_capture_screen.dart';

/// Halaman Profil Pengguna dengan fitur edit data diri serta kamera dan galeri
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
  Uint8List? _currentPhotoBytes;
  String? _currentPhotoPath;

  static const String _instagramUrl = 'https://www.instagram.com/i.will24/';

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
    _currentPhotoBytes = widget.profile.fotoBytes;
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

  /// Membuka tautan profil Instagram pada peramban eksternal
  Future<void> _openInstagram() async {
    final Uri uri = Uri.parse(_instagramUrl);
    try {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        // Opsi kedua jika externalApplication tidak dapat membuka tautan
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.danger,
          content: Text('Tidak dapat membuka tautan Instagram: $e'),
        ),
      );
    }
  }

  /// Menampilkan lembar modal untuk memilih antara kamera langsung atau galeri berkas
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
                const SizedBox(height: 4),
                const Text(
                  'Pilih sumber pengambilan foto profil Anda:',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 18),
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
                    'Buka Kamera Langsung',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Aktifkan sensor kamera atau webcam laptop'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _openLiveCamera();
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
                    'Pilih dari Galeri Berkas',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Jelajahi berkas gambar dari memori perangkat'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickFromGallery();
                  },
                ),
                if (_currentPhotoBytes != null || _currentPhotoPath != null) ...[
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
                    subtitle: const Text('Kembalikan ke avatar inisial nama default'),
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

  /// Membuka layar kamera langsung dengan live preview
  Future<void> _openLiveCamera() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const CameraCaptureScreen()),
    );

    if (result != null && mounted) {
      final bytes = result['bytes'] as Uint8List;
      final path = result['path'] as String;

      setState(() {
        _currentPhotoBytes = bytes;
        _currentPhotoPath = path;
      });

      final updated = widget.profile.copyWith(
        fotoBytes: bytes,
        fotoPath: path,
      );
      widget.onUpdateProfile(updated);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.plantation700,
          content: Text('Foto profil berhasil diambil melalui kamera!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Memilih gambar melalui pemilih galeri berkas
  Future<void> _pickFromGallery() async {
    try {
      final XFile? selected = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (selected != null) {
        final bytes = await selected.readAsBytes();
        if (!mounted) return;

        setState(() {
          _currentPhotoBytes = bytes;
          _currentPhotoPath = selected.path;
        });

        final updated = widget.profile.copyWith(
          fotoBytes: bytes,
          fotoPath: selected.path,
        );
        widget.onUpdateProfile(updated);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.plantation700,
            content: Text('Foto profil dari galeri berhasil dipasang!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.danger,
          content: Text('Gagal memilih gambar dari galeri: $e'),
        ),
      );
    }
  }

  /// Menghapus foto profil dengan dialog konfirmasi
  Future<void> _removeProfilePhoto() async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Hapus Foto Profil',
      message: 'Apakah Anda yakin ingin menghapus foto profil saat ini?',
      confirmText: 'Ya, Hapus',
      cancelText: 'Batal',
      icon: Icons.delete_outline_rounded,
      iconColor: AppColors.danger,
      confirmButtonColor: AppColors.danger,
    );

    if (!confirmed) return;
    if (!mounted) return;

    setState(() {
      _currentPhotoBytes = null;
      _currentPhotoPath = null;
    });

    final updated = widget.profile.copyWith(clearFoto: true);
    widget.onUpdateProfile(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.plantation700,
        content: Text('Foto profil telah dihapus.'),
      ),
    );
  }

  /// Menyimpan formulir pembaruan data diri dengan konfirmasi
  Future<void> _saveProfileChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Simpan Perubahan',
      message: 'Apakah seluruh data profil yang Anda masukkan ingin disimpan sekarang?',
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
      fotoBytes: _currentPhotoBytes,
      fotoPath: _currentPhotoPath,
    );

    widget.onUpdateProfile(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.plantation700,
        content: Text('Perubahan data diri berhasil disimpan!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Menampilkan dialog konfirmasi keluar akun dan kembali ke halaman Login
  Future<void> _onLogoutWithConfirmation() async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Konfirmasi Keluar',
      message: 'Apakah Anda ingin mengakhiri sesi dan kembali ke halaman masuk?',
      confirmText: 'Keluar Akun',
      cancelText: 'Batal',
      icon: Icons.logout_rounded,
      iconColor: AppColors.danger,
      confirmButtonColor: AppColors.danger,
    );

    if (!confirmed) return;
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Petani'),
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
            // Area Avatar dan Tombol Kamera
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.plantation600,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x18000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: _buildAvatarWidget(),
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
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Text(
              widget.profile.nama,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.profile.email,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),

            const SizedBox(height: 16),

            // Tombol Sosial Media Instagram
            InkWell(
              onTap: _openInstagram,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF833AB4), // Ungu Instagram
                      Color(0xFFFD1D1D), // Merah Instagram
                      Color(0xFFFCB045), // Kuning Instagram
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x28FD1D1D),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '@i.will24',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.open_in_new_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Formulir Perubahan Data Diri
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Data Diri Pengguna',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Nama Lengkap
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Lengkap',
                          prefixIcon: Icon(Icons.person_outline, size: 20),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Nama lengkap tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Kelompok Tani
                      TextFormField(
                        controller: _groupController,
                        decoration: const InputDecoration(
                          labelText: 'Kelompok Tani',
                          prefixIcon: Icon(Icons.groups_outlined, size: 20),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Kelompok tani wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Alamat
                      TextFormField(
                        controller: _addressController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Alamat',
                          prefixIcon: Icon(Icons.location_on_outlined, size: 20),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Alamat wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Nomor Telepon
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Nomor Telepon',
                          prefixIcon: Icon(Icons.phone_outlined, size: 20),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Nomor telepon wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Luas Lahan
                      TextFormField(
                        controller: _landAreaController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Luas Lahan (Ha)',
                          prefixIcon: Icon(Icons.square_foot_outlined, size: 20),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Luas lahan wajib diisi';
                          }
                          if (double.tryParse(val.trim()) == null) {
                            return 'Masukkan format angka desimal yang valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),

                      // Tombol Simpan
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveProfileChanges,
                          child: const Text('Simpan Data Diri'),
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

  Widget _buildAvatarWidget() {
    if (_currentPhotoBytes != null) {
      return Image.memory(
        _currentPhotoBytes!,
        fit: BoxFit.cover,
        width: 104,
        height: 104,
      );
    }

    final initial = widget.profile.nama.isNotEmpty
        ? widget.profile.nama.substring(0, 1).toUpperCase()
        : 'P';
    return Center(
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 38,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
