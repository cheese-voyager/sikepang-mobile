import 'package:flutter_test/flutter_test.dart';
import 'package:sikepang_mobile/main.dart';

void main() {
  testWidgets('SiKePang App smoke test', (WidgetTester tester) async {
    // Membangun aplikasi dan memicu satu frame
    await tester.pumpWidget(const SikepangApp());

    // Memverifikasi teks nama aplikasi pada antarmuka
    expect(find.text('SiKePang'), findsWidgets);
  });
}
