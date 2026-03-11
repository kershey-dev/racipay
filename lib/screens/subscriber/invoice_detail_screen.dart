import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/models/invoice_model.dart';
import '../../mock/mock_data.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/gradient_header_card.dart';
import '../../shared/widgets/info_row.dart';
import '../../shared/widgets/status_badge.dart';

class InvoiceDetailScreen extends StatelessWidget {
  final InvoiceModel invoice;

  const InvoiceDetailScreen({
    super.key,
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMMM d, yyyy');
    final currencyFormatter = NumberFormat('#,##0.00', 'en_PH');
    final user = MockData.subscriberUser;

    // Use mock breakdown figures for presentation.
    const planFee = 1199.00;
    const vat = 143.88;
    const total = 1342.88;

    final relatedPayment = MockData.payments
        .where((p) => p.invoiceId == invoice.id)
        .toList()
        .cast<dynamic>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.invoiceDetailTitle),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientHeaderCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoice.invoiceNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      invoice.period,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: StatusBadge(status: invoice.status),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Invoice info.
              const Text(
                'Invoice Information',
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
                      icon: Icons.date_range,
                      label: 'Issue Date',
                      value: dateFormatter.format(invoice.issueDate),
                    ),
                    InfoRow(
                      icon: Icons.event,
                      label: 'Due Date',
                      value: dateFormatter.format(invoice.dueDate),
                    ),
                    InfoRow(
                      icon: Icons.calendar_month,
                      label: 'Billing Period',
                      value: invoice.period,
                    ),
                    InfoRow(
                      icon: Icons.confirmation_number_outlined,
                      label: 'Account Number',
                      value: user.accountNumber,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Amount breakdown.
              const Text(
                'Amount Breakdown',
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
                    _AmountRow(
                      label: 'Plan Fee',
                      value: '₱${currencyFormatter.format(planFee)}',
                    ),
                    _AmountRow(
                      label: 'VAT (12%)',
                      value: '₱${currencyFormatter.format(vat)}',
                    ),
                    const Divider(),
                    _AmountRow(
                      label: 'Total Amount',
                      value: '₱${currencyFormatter.format(total)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Payment status.
              const Text(
                'Payment Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              AppCard(
                child: _PaymentStatusSection(
                  invoice: invoice,
                  relatedPayment:
                      relatedPayment.isNotEmpty ? relatedPayment.first : null,
                  onPay: () => context.push(
                    '/subscriber/payment',
                    extra: invoice,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _AmountRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.bodyMedium;
    final style = baseStyle?.copyWith(
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

class _PaymentStatusSection extends StatelessWidget {
  final InvoiceModel invoice;
  final dynamic relatedPayment;
  final VoidCallback onPay;

  const _PaymentStatusSection({
    required this.invoice,
    required this.relatedPayment,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMMM d, yyyy');

    if (invoice.status == 'paid' && relatedPayment != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.success,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This invoice has been paid.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Payment Date: ${dateFormatter.format(relatedPayment.paidAt)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textGray,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Reference No.: ${relatedPayment.referenceNumber}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textGray,
                ),
          ),
        ],
      );
    }

    final isOverdue = invoice.status == 'overdue';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isOverdue ? AppColors.errorLight : AppColors.warningLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: isOverdue ? AppColors.error : AppColors.warning,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isOverdue
                      ? 'This invoice is overdue. Please settle your payment as soon as possible.'
                      : 'This invoice is still unpaid. Please settle on or before the due date.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isOverdue
                            ? AppColors.error
                            : AppColors.warning,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Due on ${dateFormatter.format(invoice.dueDate)}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textGray,
              ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onPay,
          child: const Text('Pay This Invoice'),
        ),
      ],
    );
  }
}

