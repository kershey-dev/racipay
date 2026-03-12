import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/gradient_header_card.dart';
import '../../shared/widgets/section_header.dart';

class LinemanHelpScreen extends StatelessWidget {
  const LinemanHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & About'),
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
                  children: const [
                    Icon(
                      Icons.engineering,
                      color: Colors.white,
                      size: 40,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'RACIPAY for Linemen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Field Technician Companion App',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
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
                  ],
                ),
              ),
              const SizedBox(height: 24),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SectionHeader(title: 'Lineman FAQs'),
                    _FaqTile(
                      question: 'How do I update a job status?',
                      answer:
                          'Open the job from My Jobs, tap Update Status, select the new status (Pending, In Progress, or Resolved), optionally add a note, and confirm the update.',
                    ),
                    _FaqTile(
                      question: 'How do I add technician notes?',
                      answer:
                          'Open ticket detail, tap the Add / Update Note button under Technician Notes, type your note, and tap Save Note.',
                    ),
                    _FaqTile(
                      question: 'How do I upload proof photos?',
                      answer:
                          'Open ticket detail, tap Upload Proof at the bottom, select a photo from camera or gallery, then tap Upload Proof Photo.',
                    ),
                    _FaqTile(
                      question:
                          'Who do I contact for app technical issues?',
                      answer:
                          'Contact Racitelcom IT support at support@racitelcom.com for any technical issues or bugs you encounter in the app.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SectionHeader(title: 'App Version'),
                    SizedBox(height: 8),
                    Text(
                      'RACIPAY Lineman App\nVersion 1.0.0',
                      style: TextStyle(
                        color: AppColors.textGray,
                        fontSize: 13,
                        height: 1.5,
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
                    SectionHeader(title: 'About Racitelcom'),
                    SizedBox(height: 8),
                    Text(
                      'Racitelcom Internet Services provides reliable fiber internet connectivity to homes and businesses. '
                      'The RACIPAY Lineman module is designed to help field technicians manage assigned jobs, update statuses, '
                      'add notes, and upload proof of completed work while on-site.',
                      style: TextStyle(
                        color: AppColors.textGray,
                        fontSize: 13,
                        height: 1.6,
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

