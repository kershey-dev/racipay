import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/gradient_header_card.dart';
import '../../shared/widgets/info_row.dart';
import '../../shared/widgets/section_header.dart';

class HelpAboutScreen extends StatelessWidget {
  const HelpAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.helpAboutTitle),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.wifi,
                      color: Colors.white,
                      size: 40,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'RACIPAY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Racitelcom Internet Services',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SectionHeader(title: 'About RACIPAY'),
                    SizedBox(height: 8),
                    Text(
                      'RACIPAY is the official mobile application of Racitelcom Internet Services. '
                      'It allows subscribers to conveniently manage their billing, pay their internet '
                      'bills, and track service requests — all from their mobile device.',
                      style: TextStyle(
                        color: AppColors.textGray,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SectionHeader(title: 'Contact Support'),
                    InfoRow(
                      icon: Icons.phone,
                      label: 'Phone',
                      value: '1800-RACITEL (dummy)',
                    ),
                    InfoRow(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: 'support@racitelcom.com',
                    ),
                    InfoRow(
                      icon: Icons.language,
                      label: 'Website',
                      value: 'www.racitelcom.com',
                    ),
                    InfoRow(
                      icon: Icons.location_on_outlined,
                      label: 'Address',
                      value:
                          'Racitelcom Head Office, Quezon City',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SectionHeader(title: 'Frequently Asked Questions'),
                    _FaqTile(
                      question: 'How do I pay my bill?',
                      answer:
                          'Go to Dashboard, tap Pay Now on your billing card, select your payment method (GCash or card), and follow the checkout process.',
                    ),
                    _FaqTile(
                      question:
                          'When will my payment be reflected?',
                      answer:
                          'Payments are usually reflected within 15-30 minutes after successful transaction.',
                    ),
                    _FaqTile(
                      question:
                          'How do I submit a support ticket?',
                      answer:
                          'Go to My Tickets tab and tap the + button, or use the Tickets quick action on your dashboard.',
                    ),
                    _FaqTile(
                      question:
                          'What should I do if my internet is not working?',
                      answer:
                          'Submit a support ticket with category "No Connection". Our technicians will be assigned to assist you.',
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

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqTile({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 8),
      title: Text(
        question,
        style: const TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        Text(
          answer,
          style: const TextStyle(
            color: AppColors.textGray,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

