import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/ticket_model.dart';
import '../../core/utils/formatters.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/gradient_header_card.dart';
import '../../shared/widgets/info_row.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/status_badge.dart';

class TicketDetailScreen extends StatelessWidget {
  const TicketDetailScreen({super.key, required this.ticket});

  final TicketModel ticket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ticket.ticketNumber),
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
                      ticket.title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _categoryIcon(ticket.category),
                          color: Colors.white70,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          ticket.category,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Submitted ${Formatters.dateTime(ticket.createdAt)}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
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
                          child: StatusBadge(status: ticket.status),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Status timeline
              const SectionHeader(title: 'Status Timeline'),
              const SizedBox(height: 8),
              _StatusTimeline(status: ticket.status),

              const SizedBox(height: 24),

              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Ticket Information'),
                    InfoRow(
                      icon: Icons.confirmation_number_outlined,
                      label: 'Ticket No.',
                      value: ticket.ticketNumber,
                    ),
                    InfoRow(
                      icon: Icons.category_outlined,
                      label: 'Category',
                      value: ticket.category,
                    ),
                    InfoRow(
                      icon: Icons.access_time,
                      label: 'Submitted',
                      value: Formatters.dateTime(ticket.createdAt),
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
                        StatusBadge(status: ticket.status),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Your Concern'),
                    const SizedBox(height: 4),
                    Text(
                      ticket.description,
                      style: const TextStyle(
                        color: AppColors.textGray,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              if ((ticket.technicianNote ?? '').trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(title: 'Technician Notes'),
                        Row(
                          children: const [
                            Icon(
                              Icons.engineering,
                              color: AppColors.primaryBlue,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Assigned Technician',
                              style: TextStyle(
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ticket.technicianNote!,
                          style: const TextStyle(
                            color: AppColors.textGray,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        if ((ticket.assignedTo ?? '').trim().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: InfoRow(
                              icon: Icons.person_outline,
                              label: 'Technician',
                              value: ticket.assignedTo!,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

              if (ticket.status == 'resolved')
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: AppCard(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Issue Resolved\nThis ticket has been marked as resolved.',
                              style: TextStyle(
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              if (ticket.status != 'resolved')
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: AppCard(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Still having issues?',
                            style: TextStyle(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'If your issue persists, you can create a new ticket or contact Racitelcom support.',
                            style: TextStyle(
                              color: AppColors.textGray,
                              fontSize: 13,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () =>
                                  context.push('/subscriber/create-ticket'),
                              child: const Text('Create New Ticket'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

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
}

class _StatusTimeline extends StatelessWidget {
  final String status;

  const _StatusTimeline({required this.status});

  int get _currentStep {
    switch (status) {
      case 'pending':
        return 1;
      case 'in_progress':
        return 2;
      case 'resolved':
        return 3;
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      _TimelineStep(label: 'Submitted', index: 1, currentStep: _currentStep),
      _TimelineStep(label: 'In Progress', index: 2, currentStep: _currentStep),
      _TimelineStep(label: 'Resolved', index: 3, currentStep: _currentStep),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          if (i != 0)
            Expanded(
              child: Container(
                height: 2,
                color: steps[i].index <= _currentStep
                    ? AppColors.primaryBlue
                    : AppColors.borderColor,
              ),
            ),
          steps[i],
        ],
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String label;
  final int index;
  final int currentStep;

  const _TimelineStep({
    required this.label,
    required this.index,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = index < currentStep;
    final isActive = index == currentStep;

    Color circleColor;
    Color labelColor;

    if (isCompleted || isActive) {
      circleColor = AppColors.primaryBlue;
      labelColor = AppColors.primaryBlue;
    } else {
      circleColor = AppColors.borderColor;
      labelColor = AppColors.textLight;
    }

    return Column(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor,
          ),
          child: const Icon(
            Icons.check,
            size: 14,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: labelColor,
          ),
        ),
      ],
    );
  }
}

