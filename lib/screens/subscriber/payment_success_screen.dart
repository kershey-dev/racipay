import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/invoice_model.dart';
import '../../core/utils/formatters.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/info_row.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/status_badge.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({
    super.key,
    required this.method,
    required this.invoice,
  });

  final String method;
  final InvoiceModel invoice;

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  late final String _referenceNumber;

  @override
  void initState() {
    super.initState();
    final rand = Random();
    final digits = List.generate(8, (_) => rand.nextInt(10)).join();
    _referenceNumber = 'RTC-$digits';
  }

  @override
  Widget build(BuildContext context) {
    final amount = widget.invoice.amount;
    final methodLabel =
        widget.method == 'gcash' ? 'GCash' : 'Credit/Debit Card';
    final now = DateTime.now();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppColors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Payment Successful!',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your payment has been processed successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textGray,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 24),

                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'Transaction Details'),
                      InfoRow(
                        icon: Icons.receipt_long_outlined,
                        label: 'Reference No.',
                        value: _referenceNumber,
                      ),
                      InfoRow(
                        icon: Icons.payments_outlined,
                        label: 'Amount Paid',
                        value: Formatters.currency(amount),
                      ),
                      InfoRow(
                        icon: Icons.account_balance_wallet_outlined,
                        label: 'Payment Method',
                        value: methodLabel,
                      ),
                      InfoRow(
                        icon: Icons.access_time,
                        label: 'Date & Time',
                        value: Formatters.dateTime(now),
                      ),
                      InfoRow(
                        icon: Icons.confirmation_number_outlined,
                        label: 'Invoice No.',
                        value: widget.invoice.invoiceNumber,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Status',
                            style: TextStyle(
                              color: AppColors.textGray,
                            ),
                          ),
                          const StatusBadge(status: 'completed'),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                AppCard(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Payment Recorded',
                                style: TextStyle(
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Your subscription will remain active. '
                                'You can view this transaction in Payment History.',
                                style: TextStyle(
                                  color: AppColors.textGray,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/subscriber/dashboard'),
                    child: const Text('Back to Home'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () =>
                        context.go('/subscriber/payment-history'),
                    child: const Text('View Payment History'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

