import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insightmind_app/src/app.dart';

void main() {
  testWidgets('InsightMindApp renders correctly', (WidgetTester tester) async {
    // Build the app inside a ProviderScope (as the app expects).
    await tester.pumpWidget(const ProviderScope(child: InsightMindApp()));

    // The app should render without errors
    expect(find.byType(MaterialApp), findsOneWidget);

    // The app title should be 'InsightMind'
    expect(find.text('InsightMind'), findsWidgets);
  });
}
