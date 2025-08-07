// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:jarwik/main.dart';

void main() {
  testWidgets('Jarwik app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: JarwikApp()));

    // Verify that the splash screen shows Jarwik title
    expect(find.text('Jarwik'), findsOneWidget);
    expect(find.text('Your AI Voice Assistant'), findsOneWidget);

    // Verify the mic icon is present
    expect(find.byIcon(Icons.mic), findsOneWidget);
  });
}
