import 'package:flutter_test/flutter_test.dart';
import 'package:nextrade/main.dart';

void main() {
  testWidgets('App loads splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const NexTradeApp());
    expect(find.text('NexTrade'), findsOneWidget);
  });
}
