import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/ticket_model.dart';
import '../../core/utils/formatters.dart';
import 'app_card.dart';
import 'status_badge.dart';

class TicketCard extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback onTap;

  const TicketCard({
    super.key,
    required this.ticket,
    required this.onTap,
  });

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'No Connection':
        return Icons.wifi_off;
      case 'Slow Speed':
        return Icons.speed;
      case 'Billing Issue':
        return Icons.receipt;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: number + status.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ticket.ticketNumber,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlue,
                ),
              ),
              StatusBadge(status: ticket.status),
            ],
          ),
          const SizedBox(height: 8),
          // Title and category.
          Text(
            ticket.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                _categoryIcon(ticket.category),
                size: 16,
                color: AppColors.textGray,
              ),
              const SizedBox(width: 4),
              Text(
                ticket.category,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Bottom row: created date + technician note marker.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    Formatters.date(ticket.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
              if ((ticket.technicianNote ?? '').trim().isNotEmpty)
                Row(
                  children: const [
                    Icon(
                      Icons.note,
                      size: 14,
                      color: AppColors.primaryBlue,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Has technician note',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

