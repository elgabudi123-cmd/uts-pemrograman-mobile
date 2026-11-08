import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/facility.dart';

class FacilityRepository {
  const FacilityRepository();

  Future<List<Facility>> loadFacilities() async {
    final source = await rootBundle.loadString('assets/data/facilities.json');
    final decoded = jsonDecode(source);
    if (decoded is! List<Object?>) {
      throw const FormatException(
        'Dataset fasilitas harus berupa daftar JSON.',
      );
    }

    final facilities = decoded
        .map((item) {
          if (item is! Map<String, Object?>) {
            throw const FormatException(
              'Data fasilitas memiliki format yang salah.',
            );
          }
          return Facility.fromJson(item);
        })
        .toList(growable: false);
    final ids = facilities.map((facility) => facility.id).toSet();
    if (ids.length != facilities.length) {
      throw const FormatException('ID fasilitas pada dataset harus unik.');
    }
    return facilities;
  }
}
