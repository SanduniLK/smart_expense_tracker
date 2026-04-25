import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_expense_tracker/providers/transaction_provider.dart';
import 'package:smart_expense_tracker/utils/app_colors.dart';

class SummaryCard extends ConsumerWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // සටහන: ඔයාගේ provider එකේ මේ values ටික ගණනය කරන logic එක තියෙන්න ඕනේ
    final totalExpense = ref.watch(totalExpenseProvider);
    final totalIncome = ref.watch(totalIncomeProvider);
    final balance = totalIncome - totalExpense;
    final formatter = NumberFormat('#,##0.00');

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.mainGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(
              color: AppColors.textWhite70, 
              fontSize: 13, 
              fontWeight: FontWeight.w500
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'LKR ${formatter.format(balance)}',
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: 'Income',
                  amount: 'LKR ${formatter.format(totalIncome)}',
                  icon: Icons.arrow_downward_rounded,
                  color: AppColors.incomeGreen,
                ),
              ),
              Container(width: 1, height: 36, color: AppColors.dividerWhite),
              Expanded(
                child: _StatItem(
                  label: 'Expenses',
                  amount: 'LKR ${formatter.format(totalExpense)}',
                  icon: Icons.arrow_upward_rounded,
                  color: AppColors.expenseRed,
                  isRight: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String amount;
  final IconData icon;
  final Color color;
  final bool isRight;

  const _StatItem({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    this.isRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: isRight ? 16 : 0, right: isRight ? 0 : 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12), // Background based on surface
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: AppColors.textWhite60, fontSize: 11)),
                Text(
                  amount,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}