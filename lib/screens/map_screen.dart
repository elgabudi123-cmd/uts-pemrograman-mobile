import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/app_state.dart';
import '../app/app_theme.dart';
import '../domain/distance_formatter.dart';
import '../domain/facility.dart';
import '../domain/facility_filter.dart';
import '../widgets/app_header.dart';
import '../widgets/simulation_badge.dart';
import 'facility_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    required this.appState,
    required this.onOpenProfile,
    required this.onOpenList,
    super.key,
  });

  final AppState appState;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenList;

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final _mapController = MapController();
  final _searchController = TextEditingController();
  String _query = '';
  FacilityType? _selectedType;
  String? _selectedFacilityId;

  List<Facility> get _results {
    return filterFacilities(
      widget.appState.facilities,
      query: _query,
      type: _selectedType,
    );
  }

  Facility? get _selectedFacility {
    final results = _results;
    if (results.isEmpty) return null;
    return results.firstWhere(
      (facility) => facility.id == _selectedFacilityId,
      orElse: () => results.first,
    );
  }

  void selectFacility(String facilityId) {
    final facility = widget.appState.facilities
        .where((item) => item.id == facilityId)
        .firstOrNull;
    if (facility == null) return;
    _searchController.clear();
    setState(() {
      _query = '';
      _selectedType = null;
      _selectedFacilityId = facilityId;
    });
    _mapController.move(LatLng(facility.latitude, facility.longitude), 14);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final facilities = _results;
    return SafeArea(
      child: Column(
        children: [
          AppHeader(
            subtitle: 'Peta lokasi',
            onProfileTap: widget.onOpenProfile,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 11),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.map_outlined, color: AppTheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.appState.currentPosition == null
                            ? 'Peta lokasi fasilitas'
                            : 'Lokasi Anda tersedia',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      '${facilities.length} lokasi',
                      style: const TextStyle(
                        color: AppTheme.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: 'Cari fasilitas...',
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
                const SizedBox(height: 8),
                _categoryFilters(),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _initialCenter(facilities),
                    initialZoom: 12.5,
                    minZoom: 4,
                    maxZoom: 18,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'id.sehatbersama.sehat_bersama',
                    ),
                    CircleLayer(
                      circles: facilities
                          .where((facility) => !facility.isSimulation)
                          .map(
                            (facility) => CircleMarker(
                              point: LatLng(
                                facility.latitude,
                                facility.longitude,
                              ),
                              radius: facility.geofenceRadiusMeters.toDouble(),
                              useRadiusInMeter: true,
                              color: AppTheme.primary.withValues(alpha: 0.1),
                              borderColor: AppTheme.primary.withValues(
                                alpha: 0.6,
                              ),
                              borderStrokeWidth: 2,
                            ),
                          )
                          .toList(),
                    ),
                    MarkerLayer(
                      markers: [
                        for (final facility in facilities)
                          Marker(
                            point: LatLng(
                              facility.latitude,
                              facility.longitude,
                            ),
                            width: 52,
                            height: 64,
                            child: GestureDetector(
                              onTap: () => setState(
                                () => _selectedFacilityId = facility.id,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: _markerColor(facility.type),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x33000000),
                                          blurRadius: 5,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      _markerIcon(facility.type),
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: _markerColor(facility.type),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (widget.appState.currentPosition
                            case final position?)
                          Marker(
                            point: LatLng(
                              position.latitude,
                              position.longitude,
                            ),
                            width: 25,
                            height: 25,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.blue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution(
                          '© OpenStreetMap contributors',
                          onTap: _openMapAttribution,
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.96),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 17,
                          color: Color(0xFF815300),
                        ),
                        SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            'Marker memakai koordinat simulasi; bukan tujuan nyata.',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 65,
                  child: FloatingActionButton.small(
                    heroTag: 'locate-map',
                    tooltip: 'Gunakan lokasi saya',
                    onPressed: _requestLocation,
                    child: const Icon(Icons.my_location),
                  ),
                ),
                if (facilities.isEmpty)
                  const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Tidak ada marker untuk filter ini.'),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_selectedFacility case final facility?)
            _selectedFacilityCard(facility),
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE5F3EA),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(Icons.wifi_outlined, color: AppTheme.primary),
                const SizedBox(width: 9),
                const Expanded(
                  child: Text(
                    'Peta memerlukan internet. Daftar lokal tetap tersedia offline.',
                    style: TextStyle(
                      color: AppTheme.secondaryText,
                      fontSize: 11,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: widget.onOpenList,
                  child: const Text('Daftar'),
                ),
              ],
            ),
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
          _categoryChip('Semua', null),
          for (final type in FacilityType.values)
            _categoryChip(type.label, type),
        ],
      ),
    );
  }

  Widget _categoryChip(String label, FacilityType? type) {
    final selected = _selectedType == type;
    return Padding(
      padding: const EdgeInsets.only(right: 7),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => setState(() => _selectedType = type),
        selectedColor: AppTheme.primary,
        backgroundColor: Colors.white,
        side: BorderSide.none,
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppTheme.secondaryText,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _selectedFacilityCard(Facility facility) {
    final position = widget.appState.currentPosition;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFFE3F2E9),
                    foregroundColor: AppTheme.primary,
                    child: Icon(_markerIcon(facility.type)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          facility.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          facility.type.label,
                          style: const TextStyle(
                            color: AppTheme.secondaryText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (facility.isSimulation)
                    const SimulationBadge(compact: true),
                ],
              ),
              const SizedBox(height: 9),
              Text(
                facility.address,
                style: const TextStyle(
                  color: AppTheme.secondaryText,
                  fontSize: 12,
                ),
              ),
              if (!facility.isSimulation && position != null) ...[
                const SizedBox(height: 5),
                Text(
                  'Jarak garis lurus • ${formatDistance(facility.distanceTo(position.latitude, position.longitude))}',
                  style: const TextStyle(color: AppTheme.blue, fontSize: 11),
                ),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _openDetails(facility),
                      child: const Text('Lihat Detail'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _openNavigation(facility),
                      icon: const Icon(Icons.near_me_outlined),
                      label: const Text('Navigasi'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  LatLng _initialCenter(List<Facility> facilities) {
    final position = widget.appState.currentPosition;
    if (position != null) {
      return LatLng(position.latitude, position.longitude);
    }
    if (facilities.isNotEmpty) {
      return LatLng(facilities.first.latitude, facilities.first.longitude);
    }
    return const LatLng(-6.2, 106.8);
  }

  Future<void> _requestLocation() async {
    try {
      await widget.appState.refreshLocation();
      final position = widget.appState.currentPosition;
      if (position != null) {
        _mapController.move(LatLng(position.latitude, position.longitude), 14);
      }
    } on Exception catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _openNavigation(Facility facility) async {
    try {
      await widget.appState.openNavigation(facility);
    } on Exception catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  void _openDetails(Facility facility) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            FacilityDetailScreen(facility: facility, appState: widget.appState),
      ),
    );
  }

  Future<void> _openMapAttribution() async {
    final uri = Uri.parse('https://www.openstreetmap.org/copyright');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Color _markerColor(FacilityType type) => switch (type) {
    FacilityType.hospital => AppTheme.red,
    FacilityType.puskesmas => AppTheme.primary,
    FacilityType.clinic => const Color(0xFFBC7700),
  };

  static IconData _markerIcon(FacilityType type) => switch (type) {
    FacilityType.hospital => Icons.local_hospital,
    FacilityType.puskesmas => Icons.medical_services_outlined,
    FacilityType.clinic => Icons.health_and_safety_outlined,
  };
}
