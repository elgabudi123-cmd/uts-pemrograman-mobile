import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../app/app_theme.dart';
import '../widgets/app_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    required this.appState,
    required this.onOpenHome,
    super.key,
  });

  final AppState appState;
  final VoidCallback onOpenHome;

  @override
  Widget build(BuildContext context) {
    final locationAvailable = appState.currentPosition != null;

    return SafeArea(
      child: Column(
        children: [
          AppHeader(subtitle: 'Profil & Izin', onProfileTap: onOpenHome),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
              children: [
                _profileSummary(),
                const SizedBox(height: 22),
                _sectionTitle('LAYANAN LOKASI & GEOFENCE'),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: const _SettingIcon(
                          icon: Icons.my_location_outlined,
                        ),
                        title: const Text(
                          'Lokasi saya & izin GPS',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          locationAvailable
                              ? 'Lokasi hanya digunakan di perangkat'
                              : 'Minta izin saat ingin melihat posisi atau jarak',
                        ),
                        value: locationAvailable,
                        onChanged: (value) => _toggleLocation(context, value),
                      ),
                      const Divider(height: 1, indent: 18, endIndent: 18),
                      SwitchListTile(
                        secondary: const _SettingIcon(
                          icon: Icons.radar_outlined,
                        ),
                        title: const Text(
                          'Peringatan area geofence',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          appState.geofenceEnabled
                              ? 'Aktif saat aplikasi terbuka'
                              : 'Radius awal 500 m; membutuhkan data terverifikasi',
                        ),
                        value: appState.geofenceEnabled,
                        onChanged: (value) => _setGeofence(context, value),
                      ),
                      if (appState.geofenceMessage != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                          child: _hint(appState.geofenceMessage!),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                          child: _hint(
                            'Geofence tidak berjalan di latar belakang pada versi ini. Data contoh simulasi tidak digunakan untuk mengirim notifikasi.',
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _sectionTitle('PENGATURAN APLIKASI'),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: const [
                      _SettingRow(
                        icon: Icons.notifications_none,
                        title: 'Pengaturan notifikasi',
                        subtitle: 'Izin notifikasi diminta saat mengaktifkan geofence.',
                      ),
                      Divider(height: 1, indent: 18, endIndent: 18),
                      _SettingRow(
                        icon: Icons.storage_outlined,
                        title: 'Penyimpanan lokal',
                        subtitle: 'Dataset fasilitas dan favorit tersimpan di perangkat.',
                      ),
                      Divider(height: 1, indent: 18, endIndent: 18),
                      _SettingRow(
                        icon: Icons.info_outline,
                        title: 'Tentang aplikasi',
                        subtitle:
                            'Sehat Bersama • MVP pencarian fasilitas kesehatan',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _sectionTitle('PRIVASI & KETERBATASAN'),
                const SizedBox(height: 8),
                _hint(
                  'Lokasi tidak dikirim ke server. Peta membutuhkan internet. '
                  'Koordinat fasilitas saat ini adalah simulasi, sehingga jarak '
                  'dan notifikasi geofence belum ditampilkan untuk data tersebut.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 27,
                  backgroundColor: Color(0xFFDCEFE5),
                  foregroundColor: AppTheme.primary,
                  child: Icon(Icons.person_outline, size: 31),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pengaturan warga',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Tanpa akun dan tanpa data pribadi',
                        style: TextStyle(
                          color: AppTheme.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.shield_outlined, color: AppTheme.primary),
              ],
            ),
            const SizedBox(height: 14),
            _hint(
              'Izin lokasi hanya diminta saat Anda memakai fitur lokasi. '
              'Daftar dan detail tetap bisa diakses tanpa izin.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.secondaryText,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  static Widget _hint(String text) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.secondaryText,
          fontSize: 12,
          height: 1.45,
        ),
      ),
    );
  }

  Future<void> _toggleLocation(BuildContext context, bool enabled) async {
    try {
      if (enabled) {
        await appState.refreshLocation();
      } else {
        await appState.clearLocation();
      }
    } on Exception catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _setGeofence(BuildContext context, bool value) async {
    try {
      await appState.setGeofenceEnabled(value);
    } on Exception catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}

class _SettingIcon extends StatelessWidget {
  const _SettingIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2E9),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(icon, color: AppTheme.primary),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
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
      leading: _SettingIcon(icon: icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
    );
  }
}
