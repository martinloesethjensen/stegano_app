// Ignore for testing purposes
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:stegano_app/app/app.dart';
import 'package:stegano_app/cloaker/view/cloaker_page.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(App());
      expect(find.byType(CloakerPage), findsOneWidget);
    });
  });
}
