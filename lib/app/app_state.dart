import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/facility_repository.dart';
import '../domain/facility.dart';
import '../services/location_service.dart';
import '../services/navigation_service.dart';
import '../services/notification_service.dart';

class AppState extends ChangeNotifier {
  AppState._(
    this.facilities,
    this._preferences,
    this._locationService,
    this._notificationService,
    this._favoriteIds,
    this.hasSeenOnboarding,
  );

  static const _favoritesKey = 'favorite_facility_ids';
  static const _onboardingKey = 'onboarding_seen';
  static const _cooldown = Duration(minutes: 30);

  final List<Facility> facilities;
  final SharedPreferences _preferences;
  final LocationService _locationService;
  final NotificationService _notificationService;
  final Set<String> _favoriteIds;
  final Set<String> _insideGeofences = {};

  Position? currentPosition;
  bool hasSeenOnboarding;
  bool geofenceEnabled = false;
  String? geofenceMessage;
  Facility? latestGeofenceEntry;
  int geofenceEventVersion = 0;
  String? pendingNotificationFacilityId;
  void Function(String facilityId)? onOpenFacility;
  String? pendingMapFacilityId;
  void Function(String facilityId)? onShowFacilityOnMap;
  StreamSubscription<Position>? _positionSubscription;

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  static Future<AppState> create() async {
    final facilities = await const FacilityRepository().loadFacilities();
    final preferences = await SharedPreferences.getInstance();
    final state = AppState._(
      facilities,
      preferences,
      LocationService(),
      NotificationService(),
      preferences.getStringList(_favoritesKey)?.toSet() ?? {},
      preferences.getBool(_onboardingKey) ?? false,
    );

    try {
      await state._notificationService.initialize(state._handleNotificationTap);
      final launchDetails = await state._notificationService
          .getNotificationAppLaunchDetails();
      if (launchDetails?.didNotificationLaunchApp ?? false) {
        state._handleNotificationTap(
          launchDetails?.notificationResponse?.payload,
        );
      }
    } on Exception catch (error) {
      state.geofenceMessage = 'Notifikasi lokal tidak tersedia: $error';
    }
    return state;
  }

  Future<void> finishOnboarding() async {
    final saved = await _preferences.setBool(_onboardingKey, true);
    if (!saved) {
      throw Exception('Status pengenalan aplikasi tidak dapat disimpan.');
    }
    hasSeenOnboarding = true;
    notifyListeners();
  }

  Future<void> toggleFavorite(Facility facility) async {
    final wasFavorite = _favoriteIds.contains(facility.id);
    if (wasFavorite) {
      _favoriteIds.remove(facility.id);
    } else {
      _favoriteIds.add(facility.id);
    }
    try {
      final saved = await _preferences.setStringList(
        _favoritesKey,
        _favoriteIds.toList()..sort(),
      );
      if (saved) {
        notifyListeners();
        return;
      }
      throw Exception('Favorit tidak dapat disimpan di perangkat.');
    } on Exception {
      if (wasFavorite) {
        _favoriteIds.add(facility.id);
      } else {
        _favoriteIds.remove(facility.id);
      }
      rethrow;
    }
  }

  Future<void> refreshLocation() async {
    currentPosition = await _locationService.getCurrentPosition();
    notifyListeners();
  }

  Future<void> clearLocation() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    _insideGeofences.clear();
    geofenceEnabled = false;
    currentPosition = null;
    geofenceMessage = 'Lokasi dan pemantauan geofence dinonaktifkan.';
    notifyListeners();
  }

  Future<void> openNavigation(Facility facility) {
    if (facility.isSimulation) {
      throw Exception('Navigasi tidak tersedia untuk koordinat simulasi.');
    }
    return openExternalMap(facility);
  }

  void showFacilityOnMap(String facilityId) {
    final handler = onShowFacilityOnMap;
    if (handler == null) {
      pendingMapFacilityId = facilityId;
    } else {
      handler(facilityId);
    }
  }

  Future<void> setGeofenceEnabled(bool enabled) async {
    if (!enabled) {
      await _positionSubscription?.cancel();
      _positionSubscription = null;
      _insideGeofences.clear();
      geofenceEnabled = false;
      geofenceMessage = 'Peringatan area dinonaktifkan.';
      notifyListeners();
      return;
    }

    if (!facilities.any((facility) => !facility.isSimulation)) {
      throw Exception(
        'Geofence belum dapat diaktifkan karena dataset hanya berisi koordinat simulasi.',
      );
    }

    await _notificationService.initialize(_handleNotificationTap);
    if (!await _notificationService.requestPermission()) {
      throw Exception(
        'Izin notifikasi belum diberikan. Peringatan area tidak diaktifkan.',
      );
    }
    final position = await _locationService.getCurrentPosition();
    currentPosition = position;
    _insideGeofences
      ..clear()
      ..addAll(_facilitiesWithinRadius(position));
    geofenceEnabled = true;
    geofenceMessage =
        'Peringatan hanya dipantau saat aplikasi aktif di perangkat.';
    await _positionSubscription?.cancel();
    _positionSubscription = _locationService.watchPosition().listen(
      _onPositionChanged,
      onError: (Object error) {
        geofenceEnabled = false;
        geofenceMessage = 'Pemantauan lokasi berhenti: $error';
        notifyListeners();
      },
    );
    notifyListeners();
  }

  void setNotificationTapHandler(void Function(String facilityId) handler) {
    onOpenFacility = handler;
    final pendingId = pendingNotificationFacilityId;
    if (pendingId != null) {
      pendingNotificationFacilityId = null;
      handler(pendingId);
    }
  }

  void _handleNotificationTap(String? facilityId) {
    if (facilityId == null ||
        !facilities.any((facility) => facility.id == facilityId)) {
      return;
    }
    final handler = onOpenFacility;
    if (handler == null) {
      pendingNotificationFacilityId = facilityId;
    } else {
      handler(facilityId);
    }
  }

  Set<String> _facilitiesWithinRadius(Position position) {
    return facilities
        .where((facility) => !facility.isSimulation)
        .where(
          (facility) =>
              facility.distanceTo(position.latitude, position.longitude) <=
              facility.geofenceRadiusMeters,
        )
        .map((facility) => facility.id)
        .toSet();
  }

  void _onPositionChanged(Position position) {
    currentPosition = position;
    final insideNow = _facilitiesWithinRadius(position);
    final enteredIds = insideNow.difference(_insideGeofences);
    _insideGeofences
      ..clear()
      ..addAll(insideNow);
    notifyListeners();

    for (final facilityId in enteredIds) {
      unawaited(_sendEntryNotification(facilityId));
    }
  }

  Future<void> _sendEntryNotification(String facilityId) async {
    final facility = facilities.firstWhere((item) => item.id == facilityId);
    final key = 'geofence_last_sent_$facilityId';
    final lastSent = _preferences.getInt(key);
    final now = DateTime.now();
    if (lastSent != null &&
        now.difference(DateTime.fromMillisecondsSinceEpoch(lastSent)) <
            _cooldown) {
      return;
    }

    try {
      final saved = await _preferences.setInt(key, now.millisecondsSinceEpoch);
      if (!saved) {
        throw Exception('Cooldown notifikasi tidak dapat disimpan.');
      }
      await _notificationService.showGeofenceEntry(
        id: facility.id.hashCode & 0x7fffffff,
        facilityId: facility.id,
        facilityName: facility.name,
      );
      latestGeofenceEntry = facility;
      geofenceEventVersion++;
      geofenceMessage =
          'Anda memasuki radius ${facility.geofenceRadiusMeters} m.';
      notifyListeners();
    } on Exception catch (error) {
      geofenceMessage = 'Notifikasi tidak dapat dikirim: $error';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    unawaited(_positionSubscription?.cancel());
    super.dispose();
  }
}
