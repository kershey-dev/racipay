import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Small pill-style badge used to indicate status across the app.
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();

    Color background;
    Color textColor;
    String label;

    switch (normalized) {
      case 'paid':
        background = AppColors.successLight;
        textColor = AppColors.success;
        label = 'Paid';
        break;
      case 'pending':
        background = AppColors.warningLight;
        textColor = AppColors.pending;
        label = 'Pending';
        break;
      case 'overdue':
        background = AppColors.errorLight;
        textColor = AppColors.overdue;
        label = 'Overdue';
        break;
      case 'in_progress':
        background = AppColors.lightBlue;
        textColor = AppColors.inProgress;
        label = 'In Progress';
        break;
      case 'resolved':
        background = AppColors.successLight;
        textColor = AppColors.resolved;
        label = 'Resolved';
        break;
      case 'open':
        background = AppColors.warningLight;
        textColor = AppColors.warning;
        label = 'Open';
        break;
      case 'completed':
        background = AppColors.successLight;
        textColor = AppColors.success;
        label = 'Completed';
        break;
      case 'failed':
        background = AppColors.errorLight;
        textColor = AppColors.error;
        label = 'Failed';
        break;
      default:
        background = AppColors.borderColor;
        textColor = AppColors.textGray;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: textColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

