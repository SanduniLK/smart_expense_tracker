import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_tracker/providers/transaction_provider.dart';
import 'package:smart_expense_tracker/screens/add_sms_screen.dart';
import 'package:smart_expense_tracker/screens/transaction_detail_screen.dart';
import 'package:smart_expense_tracker/widgets/summary_card.dart';
import 'package:smart_expense_tracker/widgets/transaction_tile.dart';
import 'package:smart_expense_tracker/utils/app_colors.dart'; 

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.cardBg,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Finance Tracker',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.darkBlue,
              ),
            ),
            Text(
              'SMS Transaction Parser',
              style: TextStyle(
                  fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Add SMS Message',
            icon: const Icon(Icons.add_comment_outlined, color: AppColors.primaryIndigo),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddSmsScreen()),
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderGrey),
        ),
      ),
      body: transactions.isEmpty
          ? _EmptyState()
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const SummaryCard(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Transactions',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkBlue,
                              ),
                            ),
                            Text(
                              '${transactions.length} records',
                              style: TextStyle(
                                  fontSize: 13, color: AppColors.textGrey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final tx = transactions[index];
                      return TransactionTile(
                        transaction: tx,
                        onTap: () {
                          ref.read(selectedTransactionIdProvider.notifier).state = tx.id;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TransactionDetailScreen(),
                            ),
                          );
                        },
                      );
                    },
                    childCount: transactions.length,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sms_outlined, size: 64, color: AppColors.iconLight),
          const SizedBox(height: 16),
          Text(
            'No transactions yet',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textLight),
          ),
          const SizedBox(height: 8),
          Text('Tap + to add an SMS message',
              style: TextStyle(color: AppColors.textLight)),
        ],
      ),
    );
  }
}