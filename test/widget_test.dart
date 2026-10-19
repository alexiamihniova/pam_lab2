import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pam_lab2/app.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('home loads, favorite toggles, details opens', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 1400));
    await tester.pumpWidget(MedicalApp(repository: testRepository()));

    // Loading -> Success
    await _settleAsync(tester);
    await tester.pump();
    expect(find.text('Hi, Jonathan'), findsOneWidget);
    expect(find.text('Dr. Emmly Lestiryno'), findsOneWidget);

    // Favorite
    await tester.tap(find.byIcon(Icons.favorite_border).last);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Favorites (1)'), findsOneWidget);

    // Search -> Empty
    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump();
    expect(find.text('No doctors found'), findsOneWidget);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Clear filters'));
    await tester.pump();
    expect(find.text('Dr. Sonja Litel'), findsOneWidget);

    // Details
    await tester.tap(find.text('Dr. Sonja Litel'));
    await tester.pump();
    await _settleAsync(tester);
    await tester.pumpAndSettle();
    expect(find.text('Book an Appointment'), findsOneWidget);
    expect(find.text('\$120.00'), findsOneWidget);
  });
}

// Lasă operațiile asincrone reale (citire fișier, compute) să se termine
Future<void> _settleAsync(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 20));
  }
}
