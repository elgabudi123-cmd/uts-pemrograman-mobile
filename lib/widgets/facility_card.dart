import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../app/app_theme.dart';
import '../domain/facility.dart';
import '../domain/distance_formatter.dart';
import 'simulation_badge.dart';

class FacilityCard extends StatelessWidget {
  const FacilityCard({
    required this.facility,
    required this.appState,
    required this.onOpen,
    super.key,
    this.showActions = true,
  });

  final Facility facility;
  final AppState appState;
  final VoidCallback onOpen;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final isFavorite = appState.favoriteIds.contains(facility.id);
    final position = appState.currentPosition;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5F3EC),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _iconFor(facility.type),
                      color: AppTheme.primary,
                      size: 31,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 7,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _TypeBadge(type: facility.type),
                            if (facility.isSimulation)
                              const SimulationBadge(compact: true),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          facility.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          facility.address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppTheme.secondaryText,
                            fontSize: 13,
                          ),
                        ),
                        if (!facility.isSimulation && position != null) ...[
                          const SizedBox(height: 5),
                          Text(
                            'Jarak garis lurus • ${formatDistance(facility.distanceTo(position.latitude, position.longitude))}',
                            style: const TextStyle(
                              color: AppTheme.blue,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: isFavorite
                        ? 'Hapus dari favorit'
                        : 'Simpan ke favorit',
                    onPressed: () => _toggleFavorite(context),
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? AppTheme.red : AppTheme.primary,
                    ),
                  ),
                ],
              ),
              if (facility.services.isNotEmpty) ...[
                const SizedBox(height: 13),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: facility.services
                      .take(4)
                      .map(
                        (service) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceLow,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            service,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
              if (showActions) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onOpen,
                        icon: const Icon(Icons.info_outline),
                        label: const Text('Detail'),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _openNavigation(context),
                        icon: const Icon(Icons.near_me_outlined),
                        label: const Text('Navigasi'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
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

  Future<void> _openNavigation(BuildContext context) async {
    try {
      await appState.openNavigation(facility);
    } on Exception catch (error) {
      if (!context.mounted) return;
      _showError(context, error.toString());
    }
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

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final FacilityType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        type.label,
        style: const TextStyle(
          color: Color(0xFF245B80),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
