import 'facility.dart';

List<Facility> filterFacilities(
  Iterable<Facility> facilities, {
  required String query,
  FacilityType? type,
}) {
  final normalizedQuery = query.trim().toLowerCase();
  return facilities.where((facility) {
    if (type != null && facility.type != type) return false;
    if (normalizedQuery.isEmpty) return true;

    final searchable =
        '${facility.name} ${facility.address} ${facility.services.join(' ')}'
            .toLowerCase();
    return searchable.contains(normalizedQuery);
  }).toList();
}
