import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_tracker/providers/transaction_provider.dart';
import 'package:smart_expense_tracker/utils/app_colors.dart';

class AddSmsScreen extends ConsumerStatefulWidget {
  const AddSmsScreen({super.key});

  @override
  ConsumerState<AddSmsScreen> createState() => _AddSmsScreenState();
}

class _AddSmsScreenState extends ConsumerState<AddSmsScreen> {
  final _controller = TextEditingController();
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _parseSms() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Please paste an SMS message.';
      });
      return;
    }

    // සටහන: ඔබේ provider එකේ function එක 'addFromSms' ලෙස තිබිය යුතුය
    final success = ref.read(transactionProvider.notifier).addFromSms(text);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction added successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      setState(() {
        _hasError = true;
        _errorMessage = 'Could not parse this SMS. Make sure it contains a valid LKR amount.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Add SMS Transaction',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.darkBlue),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderGrey),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Info box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.shade100),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline,
                      color: Colors.indigo.shade400, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Paste a bank SMS message below. The app will extract the amount, merchant, date, and auto-categorize it.',
                      style: TextStyle(
                          color: Colors.indigo.shade700,
                          fontSize: 13,
                          height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('SMS Message',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBlue)),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              maxLines: 6,
              onChanged: (_) => setState(() => _hasError = false),
              decoration: InputDecoration(
                hintText: 'e.g. LKR 150.00 debited from AC **1111 via POS at KOTTAWA INTERCHANGE...',
                hintStyle: TextStyle(color: AppColors.textLight, fontSize: 13),
                filled: true,
                fillColor: AppColors.cardBg,
                errorText: _hasError ? _errorMessage : null,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.borderGrey)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.borderGrey)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryIndigo, width: 2)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _parseSms,
                icon: const Icon(Icons.auto_awesome_outlined),
                label: const Text('Parse & Add Transaction',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryIndigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text('Sample Messages',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBlue)),
            const SizedBox(height: 8),
            ..._sampleMessages.map(
              (msg) => _SampleChip(
                message: msg,
                onTap: () {
                  _controller.text = msg;
                  setState(() => _hasError = false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SampleChip extends StatelessWidget {
  final String message;
  final VoidCallback onTap;

  const _SampleChip({required this.message, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(message,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.content_paste_outlined,
                size: 18, color: AppColors.primaryIndigo),
          ],
        ),
      ),
    );
  }
}

const _sampleMessages = [
  'LKR 150.00 debited from AC **1111 via POS at KOTTAWA INTERCHANGE 10500302 28/03/2026 14:19:13 To Inq Call 0112303050 Get protected - Do not Share OTP',
  'LKR 1,692.00 debited from AC **1114 via POS at KEELLS SUPER - KOTTAWA 10402483 25/03/2026 17:46:49 To Inq Call 0112303050 Get protected - Do not Share OTP',
  'LKR 5,970.00 debited from AC **1114 via POS at P AND B FUEL MART 10000759 25/03/2026 18:58:40 To Inq Call 0112303050 Get protected - Do not Share OTP',
  'LKR 25,000.00 credited to AC **1114 via Fund Transfer from EMPLOYER SALARY 25/03/2026 10:30:15 To Inq Call 0112303050 Get protected - Do not Share OTP',
];