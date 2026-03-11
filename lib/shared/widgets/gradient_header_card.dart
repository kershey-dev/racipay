import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Shared gradient header container used for billing, invoices, and plan cards.
class GradientHeaderCard extends StatelessWidget {
  final Widget child;

  const GradientHeaderCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryBlue,
            Color(0xFF1E40AF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

