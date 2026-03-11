import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/payment_model.dart';
import '../../core/utils/formatters.dart';
import 'app_card.dart';
import 'status_badge.dart';

/// Card representation of a single payment entry.
class PaymentCard extends StatelessWidget {
  final PaymentModel payment;
  final VoidCallback onTap;

  const PaymentCard({
    super.key,
    required this.payment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = payment.method == 'gcash'
        ? Icons.account_balance_wallet
        : Icons.credit_card;

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.lightBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.referenceNumber,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  Formatters.date(payment.paidAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textGray,
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
                Formatters.currency(payment.amount),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryBlue,
                    ),
              ),
              const SizedBox(height: 4),
              StatusBadge(status: payment.status),
            ],
          ),
        ],
      ),
    );
  }
}

