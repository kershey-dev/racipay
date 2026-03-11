import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../../mock/mock_data.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/gradient_header_card.dart';
import '../../shared/widgets/info_row.dart';
import '../../shared/widgets/status_badge.dart';

class CurrentBillScreen extends StatelessWidget {
  const CurrentBillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bill = MockData.currentBill;
    final user = MockData.subscriberUser;
    final totalDue = bill.total;
    final planFee = bill.planFee;
    final tax = bill.tax;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.currentBillTitle),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GradientHeaderCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current Bill',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bill.period,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            Formatters.currency(totalDue),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Due Date',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    Formatters.date(bill.dueDate),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: StatusBadge(status: bill.status),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Bill breakdown.
                    const Text(
                      'Bill Breakdown',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AppCard(
                      child: Column(
                        children: [
                          _BreakdownRow(
                            label: 'Plan Fee',
                            value: Formatters.currency(planFee),
                          ),
                          _BreakdownRow(
                            label: 'Tax (12% VAT)',
                            value: Formatters.currency(tax),
                          ),
                          const Divider(),
                          _BreakdownRow(
                            label: 'Total Due',
                            value: Formatters.currency(totalDue),
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Account details.
                    const Text(
                      'Account Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AppCard(
                      child: Column(
                        children: [
                          InfoRow(
                            icon: Icons.confirmation_number_outlined,
                            label: 'Account Number',
                            value: user.accountNumber,
                          ),
                          InfoRow(
                            icon: Icons.wifi,
                            label: 'Plan',
                            value: user.planName,
                          ),
                          InfoRow(
                            icon: Icons.speed,
                            label: 'Speed',
                            value: user.planSpeed,
                          ),
                          InfoRow(
                            icon: Icons.date_range,
                            label: 'Billing Period',
                            value: bill.period,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              decoration: const BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(20, 0, 0, 0),
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/subscriber/payment'),
                  child: Text('Pay Now  ${Formatters.currency(totalDue)}'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _BreakdownRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
          color: isTotal ? AppColors.textDark : AppColors.textGray,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}

