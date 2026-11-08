import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../app/app_theme.dart';
import '../domain/facility.dart';
import '../domain/facility_filter.dart';
import '../widgets/app_header.dart';
import '../widgets/empty_state.dart';
import '../widgets/facility_card.dart';
import 'facility_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({
    required this.appState,
    required this.onOpenProfile,
    super.key,
  });

  final AppState appState;
  final VoidCallback onOpenProfile;

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  FacilityType? _selectedType;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = filterFacilities(
      widget.appState.facilities.where(
        (facility) => widget.appState.favoriteIds.contains(facility.id),
      ),
      query: _query,
      type: _selectedType,
    );

    return SafeArea(
      child: Column(
        children: [
          AppHeader(subtitle: 'Favorit', onProfileTap: widget.onOpenProfile),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
              children: [
                _summary(favorites.length),
                const SizedBox(height: 15),
                TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: 'Cari fasilitas favorit...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Hapus pencarian',
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                            icon: const Icon(Icons.close),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                _categoryFilters(),
                const SizedBox(height: 16),
                if (favorites.isEmpty)
                  SizedBox(
                    height: 300,
                    child: EmptyState(
                      icon: Icons.favorite_border,
                      title: widget.appState.favoriteIds.isEmpty
                          ? 'Belum ada fasilitas favorit'
                          : 'Tidak ada hasil',
                      message: widget.appState.favoriteIds.isEmpty
                          ? 'Simpan fasilitas dari Beranda agar mudah ditemukan kembali.'
                          : 'Ubah kata kunci atau filter kategori.',
                    ),
                  )
                else
                  ...favorites.map(
                    (facility) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FacilityCard(
                        facility: facility,
                        appState: widget.appState,
                        onOpen: () => _openFacility(facility),
                      ),
                    ),
                  ),
                if (favorites.isNotEmpty) _offlineNote(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summary(int count) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4EC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            child: Icon(Icons.favorite_border),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fasilitas Favorit',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  '$count disimpan di perangkat',
                  style: const TextStyle(
                    color: AppTheme.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('$count'),
          ),
        ],
      ),
    );
  }

  Widget _categoryFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterChip('Semua', null),
          for (final type in FacilityType.values) _filterChip(type.label, type),
        ],
      ),
    );
  }

  Widget _filterChip(String label, FacilityType? type) {
    final selected = _selectedType == type;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => setState(() => _selectedType = type),
        selectedColor: AppTheme.primary,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppTheme.secondaryText,
          fontSize: 12,
        ),
        side: BorderSide.none,
      ),
    );
  }

  Widget _offlineNote() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4EC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.offline_pin_outlined, color: AppTheme.primary),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Daftar favorit tersimpan secara lokal dan dapat dibuka tanpa jaringan.',
              style: TextStyle(color: AppTheme.secondaryText, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _openFacility(Facility facility) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            FacilityDetailScreen(facility: facility, appState: widget.appState),
      ),
    );
  }
}
