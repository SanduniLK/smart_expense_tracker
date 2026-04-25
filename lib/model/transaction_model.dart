// lib/model/transaction_model.dart

enum TransactionType { expense, income }

enum TransactionCategory {
  transport,
  groceries,
  fuel,
  food,
  shopping,
  utilities,
  health,
  entertainment,
  other,
  income,
}

extension TransactionCategoryExtension on TransactionCategory {
  String get displayName {
    switch (this) {
      case TransactionCategory.transport:     return 'Transport';
      case TransactionCategory.groceries:     return 'Groceries';
      case TransactionCategory.fuel:          return 'Fuel';
      case TransactionCategory.food:          return 'Food & Dining';
      case TransactionCategory.shopping:      return 'Shopping';
      case TransactionCategory.utilities:     return 'Utilities';
      case TransactionCategory.health:        return 'Health';
      case TransactionCategory.entertainment: return 'Entertainment';
      case TransactionCategory.other:         return 'Other';
      case TransactionCategory.income:        return 'Income';
    }
  }

  String get emoji {
    switch (this) {
      case TransactionCategory.transport:     return '🚌';
      case TransactionCategory.groceries:     return '🛒';
      case TransactionCategory.fuel:          return '⛽';
      case TransactionCategory.food:          return '🍽️';
      case TransactionCategory.shopping:      return '🛍️';
      case TransactionCategory.utilities:     return '💡';
      case TransactionCategory.health:        return '🏥';
      case TransactionCategory.entertainment: return '🎬';
      case TransactionCategory.other:         return '📦';
      case TransactionCategory.income:        return '💰';
    }
  }
}

class TransactionModel {
  final String id;
  final double amount;
  final TransactionType type;
  final String merchant;
  final DateTime dateTime;
  final TransactionCategory category;
  final String accountRef;
  final String rawMessage;

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.merchant,
    required this.dateTime,
    required this.category,
    required this.accountRef,
    required this.rawMessage,
  });

  TransactionModel copyWith({
    String? id,
    double? amount,
    TransactionType? type,
    String? merchant,
    DateTime? dateTime,
    TransactionCategory? category,
    String? accountRef,
    String? rawMessage,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      merchant: merchant ?? this.merchant,
      dateTime: dateTime ?? this.dateTime,
      category: category ?? this.category,
      accountRef: accountRef ?? this.accountRef,
      rawMessage: rawMessage ?? this.rawMessage,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type.toString(),
      'merchant': merchant,
      'dateTime': dateTime.toIso8601String(),
      'category': category.toString(),
      'accountRef': accountRef,
      'rawMessage': rawMessage,
    };
  }

  // Create from JSON for loading
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: _parseTransactionType(json['type'] as String),
      merchant: json['merchant'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      category: _parseTransactionCategory(json['category'] as String),
      accountRef: json['accountRef'] as String,
      rawMessage: json['rawMessage'] as String,
    );
  }

  static TransactionType _parseTransactionType(String value) {
    return TransactionType.values.firstWhere(
      (type) => type.toString() == value,
      orElse: () => TransactionType.expense,
    );
  }

  static TransactionCategory _parseTransactionCategory(String value) {
    return TransactionCategory.values.firstWhere(
      (cat) => cat.toString() == value,
      orElse: () => TransactionCategory.other,
    );
  }
}