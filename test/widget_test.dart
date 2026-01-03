// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myapp/main.dart';

void main() {
  testWidgets('ExpenseApp UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: ExpenseApp()));

    // Verify that the title is rendered.
    expect(find.text('บันทึกค่าใช้จ่าย'), findsOneWidget);

    // Verify that the input fields are present.
    expect(find.widgetWithText(TextField, 'รายการ'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'จำนวนเงิน'), findsOneWidget);

    // Verify that the 'บันทึก' button is present.
    expect(find.widgetWithText(ElevatedButton, 'บันทึก'), findsOneWidget);
  });
}
