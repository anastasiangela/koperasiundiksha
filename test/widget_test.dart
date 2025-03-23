import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart'; // Pastikan path ini benar

void main() {
  testWidgets('Aplikasi bisa dibuka tanpa error', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp()); // Gunakan const

    // Pastikan MaterialApp ada dalam widget tree
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
