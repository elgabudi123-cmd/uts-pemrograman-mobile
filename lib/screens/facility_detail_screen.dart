import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../app/app_theme.dart';
import '../domain/distance_formatter.dart';
import '../domain/facility.dart';
import '../services/navigation_service.dart';
import '../widgets/simulation_badge.dart';

class FacilityDetailScreen extends StatelessWidget {
  const FacilityDetailScreen({
    required this.facility,
    required this.appState,
    super.key,
  });

  final Facility facility;
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final isFavorite = appState.favoriteIds.contains(facility.id);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Kembali',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Detail Fasilitas'),
        actions: [
          IconButton(
            tooltip: isFavorite ? 'Hapus favorit' : 'Simpan favorit',
            onPressed: () => _toggleFavorite(context),
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? AppTheme.red : AppTheme.primary,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          Container(
            height: 172,
            decoration: BoxDecoration(
              color: const Color(0xFFDCEFE5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  _iconFor(facility.type),
                  color: AppTheme.primary.withValues(alpha: 0.8),
                  size: 78,
                ),
                Positioned(left: 14, top: 14, child: SimulationBadge()),
                Positioned(
                  right: 14,
                  bottom: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      'Gambar fasilitas tidak tersedia',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  facility.type.label.toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.secondaryText,
                    letterSpacing: 0.7,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  facility.name,
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                const SimulationBadge(),
                const SizedBox(height: 12),
                const Text(
                  'Data dan koordinat simulasi untuk pengembangan; bukan informasi fasilitas terverifikasi.',
                  style: TextStyle(color: AppTheme.secondaryText, height: 1.4),
                ),
                const SizedBox(height: 16),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  title: 'Alamat',
                  value: facility.address,
                ),
                if (!facility.isSimulation &&
                    appState.currentPosition != null) ...[
                  const SizedBox(height: 14),
                  _InfoRow(
                    icon: Icons.near_me_outlined,
                    title: 'Jarak garis lurus (estimasi)',
                    value: formatDistance(
                      facility.distanceTo(
                        appState.currentPosition!.latitude,
                        appState.currentPosition!.longitude,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jenis Pelayanan',
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 14),
                if (facility.services.isEmpty)
                  const Text(
                    'Informasi layanan belum tersedia.',
                    style: TextStyle(color: AppTheme.secondaryText),
                  )
                else
                  Wrap(
                    spacing: 9,
                    runSpacing: 9,
                    children: facility.services
                        .map(
                          (service) => Chip(
                            avatar: const Icon(
                              Icons.medical_services_outlined,
                              size: 16,
                            ),
                            label: Text(service),
                            backgroundColor: AppTheme.surfaceLow,
                            side: BorderSide.none,
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
          if (facility.phone != null || facility.openingHours != null) ...[
            const SizedBox(height: 14),
            _InfoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informasi & Kontak',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  if (facility.openingHours case final hours?) ...[
                    const SizedBox(height: 14),
                    _InfoRow(
                      icon: Icons.access_time,
                      title: 'Jam operasional',
                      value: hours,
                    ),
                  ],
                  if (facility.phone case final phone?) ...[
                    const SizedBox(height: 14),
                    _InfoRow(
                      icon: Icons.call_outlined,
                      title: 'Telepon',
                      value: phone,
                    ),
                  ],
                ],
              ),
            ),
          ],
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showOnMap(context),
                  icon: const Icon(Icons.map_outlined),
                  label: const Text('Lihat di Peta'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _openMap(context),
                  icon: const Icon(Icons.navigation_outlined),
                  label: const Text('Mulai Navigasi'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _toggleFavorite(BuildContext context) async {
    try {
      await appState.toggleFavorite(facility);
    } on Exception catch (error) {
      if (!context.mounted) return;
      _showError(context, error.toString());
    }
  }

  Future<void> _openMap(BuildContext context) async {
    try {
      await openExternalMap(facility);
    } on Exception catch (error) {
      if (!context.mounted) return;
      _showError(context, error.toString());
    }
  }

  void _showOnMap(BuildContext context) {
    appState.showFacilityOnMap(facility.id);
    Navigator.of(context).pop();
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static IconData _iconFor(FacilityType type) => switch (type) {
    FacilityType.hospital => Icons.local_hospital_outlined,
    FacilityType.puskesmas => Icons.medical_services_outlined,
    FacilityType.clinic => Icons.health_and_safety_outlined,
  };
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(18), child: child),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppTheme.surfaceLow,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, size: 20, color: AppTheme.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.secondaryText,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 3),
              Text(value, style: const TextStyle(height: 1.35)),
            ],
          ),
        ),
      ],
    );
  }
}
