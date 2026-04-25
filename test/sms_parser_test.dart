import 'package:flutter_test/flutter_test.dart';

import 'package:smart_expense_tracker/model/transaction_model.dart';
import 'package:smart_expense_tracker/services/sms_parser_service.dart';

void main() {
  group('SmsParser', () {
    const debitMsg =
        'LKR 150.00 debited from AC **1111 via POS at KOTTAWA INTERCHANGE 10500302 28/03/2026 14:19:13 To Inq Call 0112303050 Get protected - Do not Share OTP';
    const supermarketMsg =
        'LKR 1,692.00 debited from AC **1114 via POS at KEELLS SUPER - KOTTAWA 10402483 25/03/2026 17:46:49 To Inq Call 0112303050 Get protected - Do not Share OTP';
    const fuelMsg =
        'LKR 5,970.00 debited from AC **1114 via POS at P AND B FUEL MART 10000759 25/03/2026 18:58:40 To Inq Call 0112303050 Get protected - Do not Share OTP';
    const creditMsg =
        'LKR 45,000.00 credited to AC **1111 via SALARY TRANSFER 20300100 22/03/2026 08:00:00 To Inq Call 0112303050 Get protected - Do not Share OTP';

    test('parses amount correctly', () {
      expect(SmsParser.parse(debitMsg)!.amount, 150.00);
    });

    test('parses amount with comma separator', () {
      expect(SmsParser.parse(supermarketMsg)!.amount, 1692.00);
    });

    test('identifies debit as expense', () {
      expect(SmsParser.parse(debitMsg)!.type, TransactionType.expense);
    });

    test('identifies credit as income', () {
      expect(SmsParser.parse(creditMsg)!.type, TransactionType.income);
    });

    test('categorizes interchange as transport', () {
      expect(SmsParser.parse(debitMsg)!.category, TransactionCategory.transport);
    });

    test('categorizes Keells Super as groceries', () {
      expect(SmsParser.parse(supermarketMsg)!.category, TransactionCategory.groceries);
    });

    test('categorizes fuel mart as fuel', () {
      expect(SmsParser.parse(fuelMsg)!.category, TransactionCategory.fuel);
    });

    test('extracts account reference', () {
      expect(SmsParser.parse(debitMsg)!.accountRef, '**1111');
    });

    test('extracts merchant name', () {
      expect(SmsParser.parse(debitMsg)!.merchant.toLowerCase(), contains('kottawa interchange'));
    });

    test('parses date correctly', () {
      final tx = SmsParser.parse(debitMsg)!;
      expect(tx.dateTime.day, 28);
      expect(tx.dateTime.month, 3);
      expect(tx.dateTime.year, 2026);
      expect(tx.dateTime.hour, 14);
      expect(tx.dateTime.minute, 19);
    });

    test('returns null for invalid SMS', () {
      expect(SmsParser.parse('Hello there!'), isNull);
    });

    test('income gets income category', () {
      expect(SmsParser.parse(creditMsg)!.category, TransactionCategory.income);
    });
  });
}