// lib/widgets/transaction_tile.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_expense_tracker/model/transaction_model.dart';
import 'package:smart_expense_tracker/utils/app_colors.dart'; // AppColors import කරන්න

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onTap;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == TransactionType.expense;
    
    // AppColors පාවිච්චි කරමු
    final amountColor = isExpense ? AppColors.expenseRed : AppColors.incomeGreen;
    final bgColor = isExpense ? AppColors.expenseRedBg : AppColors.incomeGreenBg;
    
    final amountPrefix = isExpense ? '-' : '+';
    final formattedAmount = NumberFormat('#,##0.00').format(transaction.amount);
    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(transaction.dateTime);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.borderGrey), // Border color updated
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Category emoji badge
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: bgColor, // Dynamic background updated
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    transaction.category.emoji, 
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Merchant & category info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.merchant,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.indigoBg, // Indigo background updated
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            transaction.category.displayName,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryIndigo, // Primary color updated
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            formattedDate,
                            style: TextStyle(
                                fontSize: 11, color: AppColors.textGrey), // Grey text updated
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              
              // Amount + account ref
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$amountPrefix LKR $formattedAmount',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: amountColor, // Dynamic amount color updated
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.accountRef, 
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textGrey), // Grey text updated
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}