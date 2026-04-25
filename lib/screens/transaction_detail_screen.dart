import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_expense_tracker/model/transaction_model.dart';
import 'package:smart_expense_tracker/providers/transaction_provider.dart';
import 'package:smart_expense_tracker/utils/app_colors.dart';

class TransactionDetailScreen extends ConsumerWidget {
  const TransactionDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transaction = ref.watch(selectedTransactionProvider);

    if (transaction == null) {
      return const Scaffold(body: Center(child: Text('Transaction not found.')));
    }

    final isExpense = transaction.type == TransactionType.expense;
    final amountColor = isExpense ? AppColors.expenseRed : AppColors.incomeGreen;
    final amountPrefix = isExpense ? '- ' : '+ ';
    final formattedAmount = NumberFormat('#,##0.00').format(transaction.amount);
    final formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(transaction.dateTime);
    final formattedTime = DateFormat('hh:mm:ss a').format(transaction.dateTime);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.cardBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transaction Details',
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.w700, 
            color: AppColors.darkBlue
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderGrey),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            
            _HeroAmountCard(
              emoji: transaction.category.emoji,
              merchant: transaction.merchant,
              amount: '$amountPrefix LKR $formattedAmount',
              amountColor: amountColor,
              type: isExpense ? 'Expense' : 'Income',
            ),
            const SizedBox(height: 16),

            
            _SectionCard(
              title: 'DETAILS',
              children: [
                _DetailRow(icon: Icons.store_outlined, label: 'Merchant', value: transaction.merchant),
                _DetailRow(icon: Icons.credit_card_outlined, label: 'Account', value: transaction.accountRef),
                _DetailRow(icon: Icons.calendar_today_outlined, label: 'Date', value: formattedDate),
                _DetailRow(icon: Icons.access_time_outlined, label: 'Time', value: formattedTime),
              ],
            ),
            const SizedBox(height: 16),

           
            _CategoryCard(transaction: transaction),
            const SizedBox(height: 16),

          
            _SectionCard(
              title: 'RAW SMS MESSAGE',
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    transaction.rawMessage,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textGrey,
                      height: 1.6,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}


class _CategoryCard extends ConsumerWidget {
  final TransactionModel transaction;
  const _CategoryCard({required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CATEGORY',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryIndigo,
              letterSpacing: 0.5
            )
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(transaction.category.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.category.displayName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.darkBlue)
                    ),
                    Text(
                      'Auto-categorized',
                      style: TextStyle(fontSize: 12, color: AppColors.textGrey)
                    ),
                  ],
                ),
              ),
              
              TextButton.icon(
                onPressed: () => _showCategoryPicker(context, ref),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Change'),
                style: TextButton.styleFrom(foregroundColor: AppColors.primaryIndigo),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCategoryPicker(BuildContext context, WidgetRef ref) {
    final categories = TransactionCategory.values
        .where((c) => c != TransactionCategory.income)
        .toList();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.darkBlue)
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categories.map((cat) {
                final isSelected = cat == transaction.category;
                return ChoiceChip(
                  label: Text('${cat.emoji} ${cat.displayName}'),
                  selected: isSelected,
                  selectedColor: AppColors.indigo100,
                  onSelected: (_) {
                    ref.read(transactionProvider.notifier).updateCategory(transaction.id, cat);
                    Navigator.pop(ctx);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}



class _HeroAmountCard extends StatelessWidget {
  final String emoji, merchant, amount, type;
  final Color amountColor;
  const _HeroAmountCard({required this.emoji, required this.merchant, required this.amount, required this.amountColor, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            merchant,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.darkBlue),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: amountColor, letterSpacing: -0.5),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: amountColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              type,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: amountColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryIndigo, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.indigo400),
          const SizedBox(width: 12),
          SizedBox(
            width: 90,
            child: Text(label, style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.darkBlue)),
          ),
        ],
      ),
    );
  }
}