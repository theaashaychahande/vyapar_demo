// This is a basic Flutter widget test for the Vyapar app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:vyapar/main.dart';

void main() {
  testWidgets('Vyapar app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed.
    expect(find.text('Vyapar'), findsOneWidget);
    
    // Verify that the welcome message is displayed.
    expect(find.text('Welcome to Vyapar!'), findsOneWidget);
    
    // Verify that quick actions are displayed (testing just the first two which should always render).
    expect(find.text('Manage Products'), findsOneWidget);
    expect(find.text('New Sale'), findsOneWidget);
  });
}
