import 'package:flutter_test/flutter_test.dart';
import 'package:practice/app/app.dart';

void main() {
  testWidgets('CardVault app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const CardVaultApp());

    expect(find.text('CardVault'), findsOneWidget);
  });
}
