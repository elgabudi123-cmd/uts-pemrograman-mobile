import 'package:flutter_test/flutter_test.dart';
import 'package:sehat_bersama/data/facility_repository.dart';
import 'package:sehat_bersama/domain/distance_formatter.dart';
import 'package:sehat_bersama/domain/facility.dart';
import 'package:sehat_bersama/domain/facility_filter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Facility', () {
    test('calculates straight-line distance from coordinates', () {
      final facility = Facility(
        id: 'test',
        name: 'Fasilitas simulasi',
        type: FacilityType.hospital,
        address: 'Alamat simulasi',
        latitude: 0,
        longitude: 0,
        services: const [],
        isSimulation: true,
      );

      expect(facility.distanceTo(0, 0), 0);
      expect(facility.distanceTo(1, 0), closeTo(111195, 1000));
    });

    test('formats distance using meters and kilometers', () {
      expect(formatDistance(420), '420 m');
      expect(formatDistance(1250), '1.3 km');
    });

    test('rejects invalid coordinates', () {
      expect(
        () => Facility.fromJson({
          'id': 'invalid',
          'name': 'Fasilitas',
          'type': 'hospital',
          'address': 'Alamat',
          'latitude': 91,
          'longitude': 0,
          'services': <String>[],
          'geofenceRadiusMeters': 500,
          'isSimulation': true,
        }),
        throwsFormatException,
      );
    });
  });

  test('loads unique local facilities and labels simulated data', () async {
    final facilities = await const FacilityRepository().loadFacilities();

    expect(facilities, hasLength(3));
    expect(
      facilities.map((facility) => facility.id).toSet(),
      hasLength(facilities.length),
    );
    expect(facilities.every((facility) => facility.isSimulation), isTrue);
    expect(facilities.every((facility) => facility.phone == null), isTrue);
    expect(
      facilities.every((facility) => facility.openingHours == null),
      isTrue,
    );
  });

  test(
    'searches name, address, and services with category filtering',
    () async {
      final facilities = await const FacilityRepository().loadFacilities();

      expect(
        filterFacilities(facilities, query: 'imunisasi').single.name,
        'Puskesmas Sukamaju',
      );
      expect(
        filterFacilities(
          facilities,
          query: 'klinik',
          type: FacilityType.clinic,
        ).single.name,
        'Klinik Sehat Mandiri',
      );
      expect(filterFacilities(facilities, query: 'tidak ada'), isEmpty);
      expect(
        filterFacilities(facilities, query: ''),
        hasLength(facilities.length),
      );
    },
  );
}
