import 'package:url_launcher/url_launcher.dart';

import '../domain/facility.dart';

Future<void> openExternalMap(Facility facility) async {
  final destination =
      '${facility.latitude},${facility.longitude}(${Uri.encodeComponent(facility.name)})';
  final uri = Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=$destination',
  );
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Aplikasi peta eksternal tidak dapat dibuka.');
  }
}
