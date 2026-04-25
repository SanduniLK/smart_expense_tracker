
import 'package:smart_expense_tracker/model/transaction_model.dart';

class SmsParser {
  static TransactionModel? parse(String rawMessage) {
    final amount = _extractAmount(rawMessage);
    if (amount == null) return null;

    // Date/time extraction is critical - SMS without proper date should be rejected
    final dateTime = _extractDateTime(rawMessage);
    if (dateTime == null) return null;

    final type = _extractType(rawMessage);
    final merchant = _extractMerchant(rawMessage);
    final accountRef = _extractAccountRef(rawMessage);
    final category = _categorize(merchant, type);

    return TransactionModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      amount: amount,
      type: type,
      merchant: merchant,
      dateTime: dateTime,
      category: category,
      accountRef: accountRef,
      rawMessage: rawMessage,
    );
  }

  static double? _extractAmount(String message) {
    // Try "for LKR 200.00" format first
    var regex = RegExp(
      r'for\s+LKR\s+([\d,]+(?:\.\d{1,2})?)',
      caseSensitive: false,
    );
    var match = regex.firstMatch(message);
    if (match != null) {
      final raw = match.group(1)!.replaceAll(',', '');
      return double.tryParse(raw);
    }
    
    // Try "LKR 200.00" format (original)
    regex = RegExp(
      r'LKR\s*([\d,]+(?:\.\d{1,2})?)',
      caseSensitive: false,
    );
    match = regex.firstMatch(message);
    if (match == null) return null;
    final raw = match.group(1)!.replaceAll(',', '');
    return double.tryParse(raw);
  }

  static TransactionType _extractType(String message) {
    final lower = message.toLowerCase();
    // Check for income indicators
    if (lower.contains('credited') || lower.contains('credit') || lower.contains('deposited') || lower.contains('received')) {
      return TransactionType.income;
    }
    // Default to expense for debit/purchase/authorised transactions
    return TransactionType.expense;
  }

  static String _extractMerchant(String message) {
    // Pattern 1: "Purchase at MERCHANT LOCATION" (Card SMS format)
    var regex = RegExp(
      r'Purchase\s+at\s+([A-Z][A-Z0-9 &\-\/]*?)(?:\s+(?:on|for|LK|has))',
      caseSensitive: false,
    );
    var match = regex.firstMatch(message);
    if (match != null) {
      final merchant = match.group(1)!.trim();
      if (merchant.isNotEmpty && merchant.length > 2) {
        return _toTitleCase(merchant);
      }
    }

    // Pattern 2: "via POS at [MERCHANT] [TRANS_REF] [DATE]"
    regex = RegExp(
      r'via\s+POS\s+at\s+(.+?)(?:\s+\d{6,8}\s+\d{2}\/\d{2}\/\d{4})',
      caseSensitive: false,
    );
    match = regex.firstMatch(message);
    if (match != null) {
      final merchant = match.group(1)!.trim();
      if (merchant.isNotEmpty) {
        return _toTitleCase(merchant);
      }
    }

    // Pattern 3: Generic "via [TYPE] [MERCHANT]" format
    regex = RegExp(
      r'via\s+(.+?)(?:\s+\d{6,8}\s+\d{2}\/\d{2}\/\d{4})',
      caseSensitive: false,
    );
    match = regex.firstMatch(message);
    if (match != null) {
      final merchant = match.group(1)!.trim();
      if (merchant.isNotEmpty && merchant.toLowerCase() != 'pos') {
        return _toTitleCase(merchant);
      }
    }

    // Pattern 4: Fallback - extract anything between "at" and before reference/date
    regex = RegExp(
      r'at\s+([A-Z0-9 &\-\/]+?)(?:\s+\d{6,8}|$)',
      caseSensitive: false,
    );
    match = regex.firstMatch(message);
    if (match != null) {
      final merchant = match.group(1)!.trim();
      if (merchant.isNotEmpty) {
        return _toTitleCase(merchant);
      }
    }

    return 'Unknown Merchant';
  }

  static DateTime? _extractDateTime(String message) {
    // Pattern 1: DD/MM/YY HH:MM AM/PM (e.g., 26/02/26 03:35 AM)
    var regex = RegExp(r'(\d{2})\/(\d{2})\/(\d{2})\s+(\d{1,2}):(\d{2})\s+(AM|PM)', caseSensitive: false);
    var match = regex.firstMatch(message);
    if (match != null) {
      try {
        final day = int.parse(match.group(1)!);
        final month = int.parse(match.group(2)!);
        var year = int.parse(match.group(3)!);
        var hour = int.parse(match.group(4)!);
        final minute = int.parse(match.group(5)!);
        final ampm = match.group(6)!.toUpperCase();
        final second = 0;

        // Convert 2-digit year to 4-digit year
        if (year < 100) {
          year = year > 50 ? 1900 + year : 2000 + year;
        }

        // Convert 12-hour to 24-hour format
        if (ampm == 'PM' && hour != 12) {
          hour += 12;
        } else if (ampm == 'AM' && hour == 12) {
          hour = 0;
        }

        // Validate
        if (month < 1 || month > 12 || day < 1 || day > 31 || hour < 0 || hour > 23 || minute < 0 || minute > 59) {
          return null;
        }

        return DateTime(year, month, day, hour, minute, second);
      } catch (e) {
        return null;
      }
    }

    // Pattern 2: DD/MM/YYYY HH:MM:SS (original format)
    regex = RegExp(r'(\d{2})\/(\d{2})\/(\d{4})\s+(\d{2}):(\d{2}):(\d{2})');
    match = regex.firstMatch(message);
    if (match == null) return null;

    try {
      final day = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      final year = int.parse(match.group(3)!);
      final hour = int.parse(match.group(4)!);
      final minute = int.parse(match.group(5)!);
      final second = int.parse(match.group(6)!);

      // Validate the parsed values
      if (month < 1 || month > 12 || day < 1 || day > 31 || hour < 0 || hour > 23 || minute < 0 || minute > 59 || second < 0 || second > 59) {
        return null;
      }

      return DateTime(year, month, day, hour, minute, second);
    } catch (e) {
      return null;
    }
  }

  static String _extractAccountRef(String message) {
    // Try account format first: AC **1111
    var regex = RegExp(r'AC\s*(\*{1,4}\d+)');
    var match = regex.firstMatch(message);
    if (match != null) return match.group(1)!;
    
    // Try card ending format: ending #0346
    regex = RegExp(r'ending\s*#(\d+)', caseSensitive: false);
    match = regex.firstMatch(message);
    if (match != null) return '****${match.group(1)}';
    
    return 'N/A';
  }

  static TransactionCategory _categorize(
    String merchant,
    TransactionType type,
  ) {
    if (type == TransactionType.income) return TransactionCategory.income;

    final lower = merchant.toLowerCase();

    if (_matchesAny(lower, [
      'interchange', 'expressway', 'highway', 'toll',
      'bus', 'train', 'uber', 'pickme',
    ])) return TransactionCategory.transport;

    if (_matchesAny(lower, [
      'fuel', 'petrol', 'ceypetco', 'shell', 'ioc',
      'laugfs', 'fuel mart', 'filling',
    ])) return TransactionCategory.fuel;

    if (_matchesAny(lower, [
      'super', 'keells', 'cargills', 'arpico',
      'supermarket', 'grocery', 'mart',
    ])) return TransactionCategory.groceries;

    if (_matchesAny(lower, [
      'restaurant', 'cafe', 'coffee', 'pizza', 'kfc',
      'mcdonalds', 'burger', 'bakery', 'food', 'dine',
    ])) return TransactionCategory.food;

    if (_matchesAny(lower, [
      'pharmacy', 'hospital', 'clinic', 'medical', 'health', 'doctor',
    ])) return TransactionCategory.health;

    if (_matchesAny(lower, [
      'electricity', 'water', 'utility', 'ceb', 'leco',
      'telecom', 'dialog', 'mobitel', 'airtel', 'hutch', 'hutchison',
      'vodafone', 'robi', 'phone', 'internet', 'cable',
    ])) return TransactionCategory.utilities;

    if (_matchesAny(lower, [
      'cinema', 'movie', 'theatre', 'netflix', 'spotify', 'game',
    ])) return TransactionCategory.entertainment;

    if (_matchesAny(lower, [
      'fashion', 'clothing', 'shoes', 'shop', 'store', 'mall',
    ])) return TransactionCategory.shopping;

    return TransactionCategory.other;
  }

  static bool _matchesAny(String text, List<String> keywords) {
    return keywords.any((k) => text.contains(k));
  }

  static String _toTitleCase(String text) {
    return text
        .split(' ')
        .map((w) => w.isEmpty
            ? w
            : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }
}