import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sehat_bersama/app/sehat_bersama_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('onboarding continues to the facility home', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const SehatBersamaApp());
    await tester.pumpAndSettle();

    expect(find.byType(SehatBersamaApp), findsOneWidget);
    expect(find.text('Sehat Bersama'), findsOneWidget);
    final continueButton = find.text('Jelajahi sebagai warga');
    await tester.scrollUntilVisible(
      continueButton,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('RSUD Kabupaten X'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('RSUD Kabupaten X'), findsOneWidget);
    expect(find.text('SIMULASI'), findsWidgets);
    expect(find.text('Navigasi'), findsWidgets);

    await tester.tap(find.text('Peta').last);
    await tester.pumpAndSettle();
    expect(
      find.text('Marker memakai koordinat simulasi; bukan tujuan nyata.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Favorit').last);
    await tester.pumpAndSettle();
    expect(find.text('Belum ada fasilitas favorit'), findsOneWidget);

    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    expect(find.text('LAYANAN LOKASI & GEOFENCE'), findsOneWidget);
  });
}
