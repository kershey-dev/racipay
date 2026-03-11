import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../mock/mock_data.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/gradient_header_card.dart';
import '../../shared/widgets/info_row.dart';

class SubscriptionDetailScreen extends StatelessWidget {
  const SubscriptionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockData.subscriberUser;
    final currencyFormatter = NumberFormat('#,##0.00', 'en_PH');

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.subscriptionDetailTitle),
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
                      user.planName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.planSpeed,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Active',
                        style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '₱${currencyFormatter.format(user.planFee)} / month',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Plan Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              AppCard(
                child: Column(
                  children: const [
                    InfoRow(
                      icon: Icons.speed,
                      label: 'Speed',
                      value: '50 Mbps',
                    ),
                    InfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Start Date',
                      value: 'January 1, 2024',
                    ),
                    InfoRow(
                      icon: Icons.update,
                      label: 'Renewal Date',
                      value: 'July 1, 2024',
                    ),
                    InfoRow(
                      icon: Icons.confirmation_number_outlined,
                      label: 'Account Number',
                      value: 'RTC-2024-0001',
                    ),
                    InfoRow(
                      icon: Icons.person_outline,
                      label: 'Subscriber Name',
                      value: 'Juan dela Cruz',
                    ),
                    InfoRow(
                      icon: Icons.location_on_outlined,
                      label: 'Service Address',
                      value:
                          '123 Rizal St, Barangay Uno, Quezon City',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Need to change your plan?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You can submit a support ticket and our team will assist you with plan upgrades or downgrades.',
                      style: TextStyle(
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () =>
                            context.push('/subscriber/create-ticket'),
                        child: const Text('Contact Support'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

