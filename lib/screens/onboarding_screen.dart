import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../app/app_theme.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({required this.appState, super.key});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 38, 22, 24),
          children: [
            const SizedBox(height: 4),
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFFD8F5E9),
              child: Icon(
                Icons.health_and_safety_outlined,
                color: AppTheme.primary,
                size: 46,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Sehat Bersama',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w800, color: AppTheme.text),
            ),
            const SizedBox(height: 6),
            Center(
              child: Chip(
                avatar: const Icon(Icons.holiday_village_outlined, size: 18),
                label: const Text('Smart Village Desa Sehat'),
                backgroundColor: const Color(0xFFE2F2E9),
                side: BorderSide.none,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Temukan lokasi klinik, puskesmas, dan rumah sakit dari satu aplikasi.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.secondaryText,
                fontSize: 17,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 26),
            Container(
              height: 294,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF8DD9C5), Color(0xFFE4F5EC)],
                ),
                borderRadius: BorderRadius.circular(26),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned(
                    left: -45,
                    bottom: 82,
                    child: _Hill(size: 210, color: const Color(0xFF65B998)),
                  ),
                  Positioned(
                    right: -54,
                    bottom: 65,
                    child: _Hill(size: 220, color: const Color(0xFF4FAF8D)),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 33,
                    child: Container(
                      height: 42,
                      color: const Color(0xFFC8E5D4),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.add_road,
                        color: AppTheme.primary,
                        size: 32,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 166,
                      height: 148,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FFF9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_hospital,
                            color: AppTheme.primary,
                            size: 56,
                          ),
                          SizedBox(height: 7),
                          Text(
                            'Fasilitas Kesehatan',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Ilustrasi',
                            style: TextStyle(
                              color: AppTheme.secondaryText,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 14,
                    top: 14,
                    child: _StatusPill(
                      icon: Icons.location_on_outlined,
                      label: 'Lokasi saat dibutuhkan',
                    ),
                  ),
                  const Positioned(
                    right: 14,
                    top: 14,
                    child: _StatusPill(
                      icon: Icons.wifi_off_outlined,
                      label: 'Data lokal',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const _FeatureLine(
              icon: Icons.place_outlined,
              title: 'Peta dan pencarian fasilitas',
              subtitle: 'Akses daftar lokal tanpa harus memberi izin lokasi.',
            ),
            const _FeatureLine(
              icon: Icons.shield_outlined,
              title: 'Privasi lokasi',
              subtitle: 'Lokasi hanya digunakan di perangkat saat diperlukan.',
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _continue(context),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Mulai Sekarang'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => _continue(context),
              child: const Text('Jelajahi sebagai warga'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Versi MVP • Sebagian data pada aplikasi ini masih berupa simulasi.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.secondaryText, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _continue(BuildContext context) async {
    try {
      await appState.finishOnboarding();
    } on Exception catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pengaturan belum tersimpan: $error')),
      );
    }
  }
}

class _Hill extends StatelessWidget {
  const _Hill({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 0.65,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size),
          topRight: Radius.circular(size),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppTheme.primary),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}

class _FeatureLine extends StatelessWidget {
  const _FeatureLine({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFDDEFE5),
        foregroundColor: AppTheme.primary,
        child: Icon(icon),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppTheme.secondaryText),
      ),
    );
  }
}
