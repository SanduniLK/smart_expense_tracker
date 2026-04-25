// lib/providers/transaction_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:smart_expense_tracker/model/transaction_model.dart'; // ← single import

import 'package:smart_expense_tracker/services/sample_sms_data.dart';
import 'package:smart_expense_tracker/services/sms_parser_service.dart';

class TransactionNotifier extends Notifier<List<TransactionModel>> {
  @override
  List<TransactionModel> build() {
    return _loadFromSampleMessages();
  }

  List<TransactionModel> _loadFromSampleMessages() {
    final parsed = <TransactionModel>[];
    for (final msg in SampleSmsData.messages) {
      final transaction = SmsParser.parse(msg);
      if (transaction != null) {
        parsed.add(transaction.copyWith(
          id: '${parsed.length}_${DateTime.now().microsecondsSinceEpoch}',
        ));
      }
    }
    return parsed;
  }

  void updateCategory(String id, TransactionCategory newCategory) {
    state = [
      for (final tx in state)
        if (tx.id == id) tx.copyWith(category: newCategory) else tx,
    ];
  }

  bool addFromSms(String rawSms) {
    final transaction = SmsParser.parse(rawSms);
    if (transaction == null) return false;
    final withId = transaction.copyWith(
      id: '${state.length}_${DateTime.now().microsecondsSinceEpoch}',
    );
    state = [...state, withId];
    return true;
  }
}

final transactionProvider =
    NotifierProvider<TransactionNotifier, List<TransactionModel>>(
  TransactionNotifier.new,
);

final totalExpenseProvider = Provider<double>((ref) {
  return ref
      .watch(transactionProvider)
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);
});

final totalIncomeProvider = Provider<double>((ref) {
  return ref
      .watch(transactionProvider)
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);
});

final selectedTransactionIdProvider = StateProvider<String?>((ref) => null);

final selectedTransactionProvider = Provider<TransactionModel?>((ref) {
  final id = ref.watch(selectedTransactionIdProvider);
  if (id == null) return null;
  final transactions = ref.watch(transactionProvider);
  try {
    return transactions.firstWhere((t) => t.id == id);
  } catch (_) {
    return null;
  }
});