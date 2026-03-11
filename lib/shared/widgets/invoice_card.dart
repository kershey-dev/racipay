import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/invoice_model.dart';
import 'app_card.dart';
import 'status_badge.dart';

/// Reusable card showing high-level invoice information.
class InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;
  final VoidCallback onTap;

  const InvoiceCard({
    super.key,
    required this.invoice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final amountFormatter = NumberFormat('#,##0.00', 'en_PH');
    final dateFormatter = DateFormat('MMMM d, yyyy');

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice.invoiceNumber,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  invoice.period,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textGray,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormatter.format(invoice.issueDate),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textLight,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₱${amountFormatter.format(invoice.amount)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
              ),
              const SizedBox(height: 4),
              StatusBadge(status: invoice.status),
              const SizedBox(height: 4),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textLight,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

