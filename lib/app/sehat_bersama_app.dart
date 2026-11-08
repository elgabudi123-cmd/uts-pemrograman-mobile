import 'dart:async';

import 'package:flutter/material.dart';

import 'app_state.dart';
import 'app_theme.dart';
import '../domain/facility.dart';
import '../screens/favorites_screen.dart';
import '../screens/facility_detail_screen.dart';
import '../screens/home_screen.dart';
import '../screens/map_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/profile_screen.dart';

class SehatBersamaApp extends StatelessWidget {
  const SehatBersamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sehat Bersama',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const _AppBootstrap(),
    );
  }
}

class _AppBootstrap extends StatefulWidget {
  const _AppBootstrap();

  @override
  State<_AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<_AppBootstrap> {
  late Future<AppState> _stateFuture;

  @override
  void initState() {
    super.initState();
    _stateFuture = AppState.create();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppState>(
      future: _stateFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _StartupError(
            error: snapshot.error.toString(),
            onRetry: () => setState(() => _stateFuture = AppState.create()),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return _AppRoot(appState: snapshot.requireData);
      },
    );
  }
}

class _StartupError extends StatelessWidget {
  const _StartupError({required this.error, required this.onRetry});

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 46, color: AppTheme.red),
              const SizedBox(height: 12),
              const Text(
                'Aplikasi belum dapat dimulai',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.secondaryText),
              ),
              const SizedBox(height: 15),
              FilledButton(onPressed: onRetry, child: const Text('Coba lagi')),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppRoot extends StatefulWidget {
  const _AppRoot({required this.appState});

  final AppState appState;

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  @override
  void initState() {
    super.initState();
    widget.appState.addListener(_refresh);
  }

  @override
  void didUpdateWidget(covariant _AppRoot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.appState != widget.appState) {
      oldWidget.appState.removeListener(_refresh);
      widget.appState.addListener(_refresh);
    }
  }

  @override
  void dispose() {
    widget.appState
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.appState.hasSeenOnboarding) {
      return OnboardingScreen(appState: widget.appState);
    }
    return _MainShell(appState: widget.appState);
  }
}

class _MainShell extends StatefulWidget {
  const _MainShell({required this.appState});

  final AppState appState;

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  int _lastGeofenceEvent = 0;
  bool _mapCreated = false;
  final _mapKey = GlobalKey<MapScreenState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.appState.addListener(_onAppStateChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.appState.setNotificationTapHandler(_openFacilityById);
        widget.appState.onShowFacilityOnMap = _showFacilityOnMap;
        final pendingId = widget.appState.pendingMapFacilityId;
        if (pendingId != null) {
          widget.appState.pendingMapFacilityId = null;
          _showFacilityOnMap(pendingId);
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.appState
      ..removeListener(_onAppStateChanged)
      ..setNotificationTapHandler((_) {});
    widget.appState.onShowFacilityOnMap = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && widget.appState.geofenceEnabled) {
      unawaited(widget.appState.setGeofenceEnabled(false));
    }
  }

  void _onAppStateChanged() {
    if (!mounted ||
        widget.appState.geofenceEventVersion <= _lastGeofenceEvent) {
      return;
    }
    _lastGeofenceEvent = widget.appState.geofenceEventVersion;
    final facility = widget.appState.latestGeofenceEntry;
    if (facility == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showGeofenceAlert(facility);
    });
  }

  void _openFacilityById(String facilityId) {
    final facility = widget.appState.facilities
        .where((item) => item.id == facilityId)
        .firstOrNull;
    if (facility == null || !mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            FacilityDetailScreen(facility: facility, appState: widget.appState),
      ),
    );
  }

  void _showGeofenceAlert(Facility facility) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppTheme.background,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundColor: Color(0xFFD8F1E5),
                foregroundColor: AppTheme.primary,
                child: Icon(Icons.verified_outlined, size: 35),
              ),
              const SizedBox(height: 12),
              Text(
                'Anda memasuki area geofence',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                '${facility.name} berada dalam radius ${facility.geofenceRadiusMeters} m.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.secondaryText),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  _openFacilityById(facility.id);
                },
                icon: const Icon(Icons.place_outlined),
                label: const Text('Lihat Lokasi & Layanan'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(sheetContext).pop(),
                child: const Text('Tutup peringatan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = widget.appState;
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(
            appState: appState,
            onOpenProfile: () => _selectTab(3),
            onOpenMap: () => _selectTab(1),
          ),
          if (_mapCreated)
            MapScreen(
              key: _mapKey,
              appState: appState,
              onOpenProfile: () => _selectTab(3),
              onOpenList: () => _selectTab(0),
            )
          else
            const SizedBox.shrink(),
          FavoritesScreen(
            appState: appState,
            onOpenProfile: () => _selectTab(3),
          ),
          ProfileScreen(appState: appState, onOpenHome: () => _selectTab(0)),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Peta',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  void _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) _mapCreated = true;
    });
  }

  void _showFacilityOnMap(String facilityId) {
    _selectTab(1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapKey.currentState?.selectFacility(facilityId);
    });
  }
}
