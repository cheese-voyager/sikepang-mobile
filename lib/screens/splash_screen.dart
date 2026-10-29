import 'dart:async';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'auth_screen.dart';

/// Layar pembuka (splash screen) sederhana berbasis logo gambar resmi SiKePang
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Mengalihkan navigasi ke halaman autentikasi secara otomatis
    Timer(const Duration(milliseconds: 2200), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AuthScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Gambar SiKePang
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: AppColors.plantation50,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.plantation100, width: 2),
                ),
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              // Nama Aplikasi
              const Text(
                'SiKePang',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.plantation900,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 6),
              // Subtitle
              const Text(
                'Sistem Informasi Ketahanan Pangan Komunitas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 36),
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.plantation600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

