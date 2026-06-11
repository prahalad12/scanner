import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scaner/main.dart';

void main() {
  testWidgets('Marketplace home screen renders and opens create prompt', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('YWC Crew Marketplace'), findsOneWidget);
    expect(find.text('Browse Categories'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    expect(find.text('Create Listing (Coming Soon)'), findsOneWidget);
  });
}
