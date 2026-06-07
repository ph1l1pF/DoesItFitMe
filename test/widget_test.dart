import 'package:flutter_test/flutter_test.dart';

import 'package:does_it_fit_me/main.dart';

void main() {
  testWidgets('Welcome screen shows start button', (WidgetTester tester) async {
    await tester.pumpWidget(const DoesItFitMeApp());
    await tester.pumpAndSettle();

    expect(find.text('Get started'), findsOneWidget);
    expect(find.textContaining('Try it on virtually'), findsOneWidget);
  });
}
