// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:madl_aditya/main.dart';

void main() {
  testWidgets('Hello world app renders a clickable greeting button with a count', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Hello World'), findsNWidgets(2));
    expect(find.text('Say Hello'), findsOneWidget);
    expect(find.text('Count: 0'), findsOneWidget);

    await tester.tap(find.text('Say Hello'));
    await tester.pump();

    expect(find.text('Count: 1'), findsOneWidget);
  });
}
