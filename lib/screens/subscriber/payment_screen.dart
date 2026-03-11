import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/models/invoice_model.dart';
import '../../core/utils/formatters.dart';
import '../../mock/mock_data.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/status_badge.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, this.invoice});

  final InvoiceModel? invoice;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'gcash';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Use provided invoice or fall back to first mock invoice.
    final invoice =
        widget.invoice ?? (MockData.invoices.isNotEmpty ? MockData.invoices.first : null);

    if (invoice == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.paymentTitle),
        ),
        body: const Center(
          child: Text('No invoice available for payment.'),
        ),
      );
    }

    // For presentation, use a breakdown total figure.
    const subscriptionFee = 1299.00;
    const vat = 43.88;
    const totalAmount = 1342.88;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay Bill'),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Invoice summary.
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'You are paying',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textGray,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            invoice.invoiceNumber,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryBlue,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            invoice.period,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textGray,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Formatters.currency(totalAmount),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textDark,
                                    ),
                              ),
                              StatusBadge(status: invoice.status),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Select Payment Method',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                    ),
                    const SizedBox(height: 12),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 500;
                        final children = [
                          Expanded(
                            child: _PaymentMethodCard(
                              icon: Icons.account_balance_wallet,
                              label: 'GCash',
                              subtitle: 'Pay via GCash e-wallet',
                              selected: _selectedMethod == 'gcash',
                              accentColor: const Color(0xFF0066CC),
                              onTap: () {
                                setState(() {
                                  _selectedMethod = 'gcash';
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _PaymentMethodCard(
                              icon: Icons.credit_card,
                              label: 'Credit / Debit Card',
                              subtitle: 'Visa, Mastercard accepted',
                              selected: _selectedMethod == 'card',
                              accentColor: AppColors.primaryBlue,
                              onTap: () {
                                setState(() {
                                  _selectedMethod = 'card';
                                });
                              },
                            ),
                          ),
                        ];

                        if (isWide) {
                          return Row(children: children);
                        }

                        return Column(
                          children: [
                            children[0],
                            const SizedBox(height: 12),
                            children[2],
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Order Summary',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                    ),
                    const SizedBox(height: 8),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SummaryRow(
                            label: 'Subscription Fee',
                            value: Formatters.currency(subscriptionFee),
                          ),
                          _SummaryRow(
                            label: 'VAT (12%)',
                            value: Formatters.currency(vat),
                          ),
                          const Divider(),
                          _SummaryRow(
                            label: 'Total Amount',
                            value: Formatters.currency(totalAmount),
                            isTotal: true,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'A convenience fee may apply depending on payment method.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textGray,
                                ),
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
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _isLoading = true;
                          });
                          Future.delayed(const Duration(seconds: 1), () {
                            if (!mounted) return;
                            setState(() {
                              _isLoading = false;
                            });
                          });
                          if (!mounted) return;
                          GoRouter.of(context).go(
                            '/subscriber/payment-processing',
                            extra: {
                              'method': _selectedMethod,
                              'invoice': invoice,
                            },
                          );
                        },
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.white,
                            ),
                          ),
                        )
                      : Text(
                          'Proceed to Payment  ${Formatters.currency(totalAmount)}',
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool selected;
  final Color accentColor;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        selected ? AppColors.primaryBlue : AppColors.borderColor;
    final backgroundColor =
        selected ? AppColors.lightBlue : AppColors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: selected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: accentColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: AppColors.textGray,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (selected)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryBlue,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: const Icon(
                    Icons.check,
                    size: 16,
                    color: AppColors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow({
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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

