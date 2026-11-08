import 'package:flutter/material.dart';

import '../app/app_theme.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    required this.subtitle,
    super.key,
    this.showNotifications = true,
    this.onProfileTap,
  });

  final String subtitle;
  final bool showNotifications;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.health_and_safety_outlined,
              color: AppTheme.primary,
              size: 29,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sehat Bersama',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryDark,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: AppTheme.secondaryText),
                ),
              ],
            ),
          ),
          if (showNotifications)
            IconButton(
              tooltip: 'Peringatan lokasi',
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Peringatan area hanya aktif saat fitur geofence diaktifkan.',
                  ),
                ),
              ),
              icon: const Icon(Icons.notifications_none),
            ),
          IconButton.filled(
            tooltip: 'Profil dan izin',
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: onProfileTap,
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
    );
  }
}
