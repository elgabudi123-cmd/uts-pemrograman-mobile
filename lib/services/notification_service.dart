import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  ValueChanged<String?>? _onSelect;

  Future<void> initialize(ValueChanged<String?> onSelect) async {
    _onSelect = onSelect;
    if (_initialized) return;

    try {
      final initialized = await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('ic_launcher'),
        ),
        onDidReceiveNotificationResponse: (response) {
          _onSelect?.call(response.payload);
        },
      );
      if (initialized != true) {
        throw const NotificationServiceException(
          'Layanan notifikasi lokal tidak dapat diinisialisasi.',
        );
      }
      _initialized = true;
    } on NotificationServiceException {
      rethrow;
    } on Object catch (error) {
      throw NotificationServiceException(
        'Layanan notifikasi lokal tidak tersedia: $error',
      );
    }
  }

  Future<bool> requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) {
      throw Exception('Notifikasi geofence hanya tersedia pada Android.');
    }

    return await android.requestNotificationsPermission() ?? true;
  }

  Future<NotificationAppLaunchDetails?>
  getNotificationAppLaunchDetails() async {
    if (!_initialized) return null;
    return _plugin.getNotificationAppLaunchDetails();
  }

  Future<void> showGeofenceEntry({
    required int id,
    required String facilityId,
    required String facilityName,
  }) async {
    if (!_initialized) {
      throw Exception('Layanan notifikasi belum diinisialisasi.');
    }

    await _plugin.show(
      id: id,
      title: 'Anda memasuki area fasilitas kesehatan',
      body: '$facilityName berada dalam jangkauan lokasi Anda.',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'geofence_alerts',
          'Peringatan area fasilitas',
          channelDescription:
              'Pemberitahuan saat memasuki radius fasilitas kesehatan.',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      payload: facilityId,
    );
  }
}

class NotificationServiceException implements Exception {
  const NotificationServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}
