import 'dart:math' as math;

enum FacilityType {
  hospital('hospital'),
  puskesmas('puskesmas'),
  clinic('clinic');

  const FacilityType(this.value);

  final String value;

  static FacilityType fromValue(String value) {
    return FacilityType.values.firstWhere(
      (type) => type.value == value,
      orElse: () =>
          throw FormatException('Jenis fasilitas tidak dikenal: $value'),
    );
  }
}

class Facility {
  const Facility({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.services,
    required this.isSimulation,
    this.phone,
    this.openingHours,
    this.geofenceRadiusMeters = 500,
  });

  final String id;
  final String name;
  final FacilityType type;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> services;
  final bool isSimulation;
  final String? phone;
  final String? openingHours;
  final int geofenceRadiusMeters;

  factory Facility.fromJson(Map<String, Object?> json) {
    final id = json['id'];
    final name = json['name'];
    final address = json['address'];
    final latitude = json['latitude'];
    final longitude = json['longitude'];
    final type = json['type'];
    final services = json['services'];
    final radius = json['geofenceRadiusMeters'];

    if (id is! String || id.trim().isEmpty) {
      throw const FormatException('ID fasilitas wajib diisi.');
    }
    if (name is! String || name.trim().isEmpty) {
      throw FormatException('Nama fasilitas tidak valid: $id');
    }
    if (address is! String || address.trim().isEmpty) {
      throw FormatException('Alamat fasilitas tidak valid: $id');
    }
    if (type is! String) {
      throw FormatException('Jenis fasilitas tidak valid: $id');
    }
    if (latitude is! num || longitude is! num) {
      throw FormatException('Koordinat fasilitas tidak valid: $id');
    }
    if (latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      throw FormatException('Koordinat fasilitas di luar rentang: $id');
    }
    if (services is! List<Object?> || services.any((item) => item is! String)) {
      throw FormatException('Daftar layanan tidak valid: $id');
    }
    if (radius is! int || radius <= 0) {
      throw FormatException('Radius geofence tidak valid: $id');
    }
    final isSimulation = json['isSimulation'];
    if (isSimulation is! bool) {
      throw FormatException('Status data simulasi wajib ditentukan: $id');
    }

    return Facility(
      id: id,
      name: name,
      type: FacilityType.fromValue(type),
      address: address,
      latitude: latitude.toDouble(),
      longitude: longitude.toDouble(),
      services: List.unmodifiable(services.cast<String>()),
      isSimulation: isSimulation,
      phone: json['phone'] as String?,
      openingHours: json['openingHours'] as String?,
      geofenceRadiusMeters: radius,
    );
  }

  double distanceTo(double latitude, double longitude) {
    const earthRadiusMeters = 6371000.0;
    final lat1 = _toRadians(this.latitude);
    final lat2 = _toRadians(latitude);
    final deltaLat = _toRadians(latitude - this.latitude);
    final deltaLon = _toRadians(longitude - this.longitude);
    final haversine =
        math.pow(math.sin(deltaLat / 2), 2) +
        math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(deltaLon / 2), 2);
    final boundedHaversine = haversine.clamp(0.0, 1.0).toDouble();

    return earthRadiusMeters *
        2 *
        math.atan2(
          math.sqrt(boundedHaversine),
          math.sqrt(1 - boundedHaversine),
        );
  }

  static double _toRadians(double degrees) => degrees * math.pi / 180;
}

extension FacilityTypeLabel on FacilityType {
  String get label => switch (this) {
    FacilityType.hospital => 'Rumah Sakit',
    FacilityType.puskesmas => 'Puskesmas',
    FacilityType.clinic => 'Klinik',
  };
}
