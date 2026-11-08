import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../app/app_theme.dart';
import '../domain/facility.dart';
import '../domain/facility_filter.dart';
import 'facility_detail_screen.dart';
import '../widgets/app_header.dart';
import '../widgets/empty_state.dart';
import '../widgets/facility_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.appState,
    required this.onOpenProfile,
    required this.onOpenMap,
    super.key,
  });

  final AppState appState;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenMap;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  FacilityType? _selectedType;

  List<Facility> get _results {
    final results = filterFacilities(
      widget.appState.facilities,
      query: _query,
      type: _selectedType,
    );
    final position = widget.appState.currentPosition;
    if (position != null) {
      results.sort((first, second) {
        if (first.isSimulation != second.isSimulation) {
          return first.isSimulation ? 1 : -1;
        }
        if (first.isSimulation) return 0;
        return first
            .distanceTo(position.latitude, position.longitude)
            .compareTo(
              second.distanceTo(position.latitude, position.longitude),
            );
      });
    }
    return results;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          AppHeader(subtitle: 'Beranda', onProfileTap: widget.onOpenProfile),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
              children: [
                _locationSummary(),
                const SizedBox(height: 15),
                _searchField(),
                const SizedBox(height: 17),
                _noticeCard(),
                const SizedBox(height: 22),
                _sectionHeading('Kategori Layanan', 'Pilihan cepat'),
                const SizedBox(height: 12),
                _categoryGrid(),
                const SizedBox(height: 24),
                _sectionHeading(
                  _query.isEmpty ? 'Fasilitas Kesehatan' : 'Hasil Pencarian',
                  '${_results.length} ditemukan',
                ),
                const SizedBox(height: 6),
                const Text(
                  'Dataset lokal • data simulasi ditandai pada setiap fasilitas',
                  style: TextStyle(color: AppTheme.secondaryText, fontSize: 12),
                ),
                const SizedBox(height: 12),
                if (_results.isEmpty)
                  const SizedBox(
                    height: 230,
                    child: EmptyState(
                      title: 'Fasilitas tidak ditemukan',
                      message:
                          'Coba kata kunci lain atau pilih kategori Semua.',
                    ),
                  )
                else
                  ..._results.map(
                    (facility) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FacilityCard(
                        facility: facility,
                        appState: widget.appState,
                        onOpen: () => _openFacility(facility),
                      ),
                    ),
                  ),
                const SizedBox(height: 6),
                _locationPermissionCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationSummary() {
    final position = widget.appState.currentPosition;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4EC),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFD5EDE2),
            foregroundColor: AppTheme.primary,
            child: Icon(Icons.location_on_outlined),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position == null
                      ? 'Lokasi tidak digunakan'
                      : 'Lokasi tersedia',
                  style: const TextStyle(
                    color: AppTheme.secondaryText,
                    fontSize: 12,
                  ),
                ),
                Text(
                  position == null
                      ? 'Smart Village • Kab. X'
                      : 'Koordinat diperoleh dari perangkat',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  size: 9,
                  color: position == null
                      ? AppTheme.secondaryText
                      : Colors.green,
                ),
                const SizedBox(width: 6),
                Text(position == null ? 'GPS nonaktif' : 'GPS aktif'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _query = value),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Cari nama, alamat, atau layanan...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _query.isEmpty
            ? IconButton(
                tooltip: 'Filter kategori',
                onPressed: _showCategoryPicker,
                icon: const Icon(Icons.tune),
              )
            : IconButton(
                tooltip: 'Hapus pencarian',
                onPressed: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
                icon: const Icon(Icons.close),
              ),
      ),
    );
  }

  Widget _noticeCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFE4F3EA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            child: Icon(Icons.health_and_safety_outlined),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informasi layanan kesehatan',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 3),
                Text(
                  'Gunakan pencarian untuk melihat data yang tersedia.',
                  style: TextStyle(color: AppTheme.secondaryText, fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Buka peta',
            onPressed: widget.onOpenMap,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeading(String title, String trailing) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        Text(
          trailing,
          style: const TextStyle(color: AppTheme.secondaryText, fontSize: 12),
        ),
      ],
    );
  }

  Widget _categoryGrid() {
    final categories = <(String, FacilityType?)>[
      ('Rumah Sakit', FacilityType.hospital),
      ('Puskesmas', FacilityType.puskesmas),
      ('Klinik', FacilityType.clinic),
      ('Semua', null),
    ];
    final icons = <FacilityType?, IconData>{
      FacilityType.hospital: Icons.local_hospital_outlined,
      FacilityType.puskesmas: Icons.medical_services_outlined,
      FacilityType.clinic: Icons.health_and_safety_outlined,
      null: Icons.apps,
    };

    return Row(
      children: categories.map((item) {
        final selected = _selectedType == item.$2;
        return Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => setState(() => _selectedType = item.$2),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFD7EEE3)
                          : const Color(0xFFE8F4EC),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      icons[item.$2],
                      color: AppTheme.primary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    item.$1,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _locationPermissionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4EC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.privacy_tip_outlined, color: AppTheme.primary),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Jarak hanya dihitung jika lokasi dan koordinat fasilitas terverifikasi.',
              style: TextStyle(color: AppTheme.secondaryText),
            ),
          ),
          TextButton(onPressed: _requestLocation, child: const Text('Lokasi')),
        ],
      ),
    );
  }

  void _showCategoryPicker() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _categoryOption('Semua kategori', null),
            for (final type in FacilityType.values)
              _categoryOption(type.label, type),
          ],
        ),
      ),
    );
  }

  Widget _categoryOption(String label, FacilityType? type) {
    return ListTile(
      title: Text(label),
      trailing: _selectedType == type ? const Icon(Icons.check) : null,
      onTap: () {
        setState(() => _selectedType = type);
        Navigator.of(context).pop();
      },
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

  Future<void> _requestLocation() async {
    try {
      await widget.appState.refreshLocation();
    } on Exception catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}
