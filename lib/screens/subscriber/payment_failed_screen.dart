import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/invoice_model.dart';
import '../../shared/widgets/app_card.dart';

class PaymentFailedScreen extends StatefulWidget {
  const PaymentFailedScreen({
    super.key,
    required this.method,
    required this.invoice,
  });

  final String method;
  final InvoiceModel invoice;

  @override
  State<PaymentFailedScreen> createState() => _PaymentFailedScreenState();
}

class _PaymentFailedScreenState extends State<PaymentFailedScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.error,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.white,
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Payment Failed',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'We could not process your payment.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textGray,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 24),

                AppCard(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.error,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'What happened?',
                              style: TextStyle(
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Your payment could not be completed. This may be due to:',
                          style: TextStyle(
                            color: AppColors.textGray,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const _BulletItem(
                          text:
                              'Insufficient GCash balance or card limit',
                        ),
                        const _BulletItem(
                          text: 'Card declined or expired',
                        ),
                        const _BulletItem(
                          text: 'Network timeout during processing',
                        ),
                        const _BulletItem(
                          text: 'Payment session expired',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'What can you do?',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      _BulletItem(
                        text:
                            'Check your GCash balance or card details',
                      ),
                      _BulletItem(
                        text: 'Try a different payment method',
                      ),
                      _BulletItem(
                        text:
                            'Contact your bank if issue persists',
                      ),
                      _BulletItem(
                        text:
                            'Submit a support ticket for assistance',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go(
                      '/subscriber/payment',
                      extra: widget.invoice,
                    ),
                    child: const Text('Try Again'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () =>
                        context.go('/subscriber/create-ticket'),
                    child: const Text('Submit Support Ticket'),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.go('/subscriber/dashboard'),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;

  const _BulletItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              color: AppColors.textGray,
              fontSize: 13,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textGray,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

