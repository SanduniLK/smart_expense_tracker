import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_expense_tracker/model/transaction_model.dart';
import 'package:smart_expense_tracker/utils/app_colors.dart'; 

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
        side: BorderSide(color: AppColors.borderGrey), 
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: bgColor, 
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
                            color: AppColors.indigoBg, 
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            transaction.category.displayName,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryIndigo, 
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            formattedDate,
                            style: TextStyle(
                                fontSize: 11, color: AppColors.textGrey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$amountPrefix LKR $formattedAmount',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: amountColor, 
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.accountRef, 
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textGrey), 
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