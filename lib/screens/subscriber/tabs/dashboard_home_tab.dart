import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../mock/mock_data.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/gradient_header_card.dart';
import '../../../shared/widgets/invoice_card.dart';
import '../../../shared/widgets/quick_action_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/shimmer_loader.dart';
import '../../../shared/widgets/status_badge.dart';

/// Home tab content for the subscriber dashboard.
class DashboardHomeTab extends StatefulWidget {
  final ValueChanged<int> onTabSelected;

  const DashboardHomeTab({
    super.key,
    required this.onTabSelected,
  });

  @override
  State<DashboardHomeTab> createState() => _DashboardHomeTabState();
}

class _DashboardHomeTabState extends State<DashboardHomeTab> {
  bool _isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = MockData.subscriberUser;
    final bill = MockData.currentBill;
    final invoices = MockData.invoices;
    final announcements = MockData.announcements;

    final currencyFormatter = NumberFormat('#,##0.00', 'en_PH');
    final dateFormatter = DateFormat('MMMM d, yyyy');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _isLoading
            ? const Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: ShimmerLoader(itemCount: 6),
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom top bar with greeting and notifications.
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good morning,',
                                style:
                                    Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.textGray,
                                        ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textDark,
                                    ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () =>
                                context.push('/subscriber/notifications'),
                            icon: const Icon(Icons.notifications_outlined),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (bill.status == 'overdue')
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: GestureDetector(
                          onTap: () => context.push('/subscriber/bill'),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.warningLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: AppColors.warning,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'You have an overdue bill. Tap to view.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.warning,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Billing summary main card.
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GradientHeaderCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Current Balance',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  user.accountNumber,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '₱${currencyFormatter.format(bill.amount)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Due Date',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      dateFormatter.format(bill.dueDate),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
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
                                  child: StatusBadge(status: bill.status),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.primaryBlue,
                                  side: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () =>
                                    context.push('/subscriber/bill'),
                                child: const Text(
                                  'Pay Now',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Quick actions.
                    const SectionHeader(title: 'Quick Actions'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 4,
                        childAspectRatio: 0.8,
                        children: [
                          QuickActionCard(
                            icon: Icons.payment,
                            label: 'Pay Bill',
                            onTap: () => context.push('/subscriber/bill'),
                          ),
                          QuickActionCard(
                            icon: Icons.support_agent,
                            label: 'My Tickets',
                            onTap: () => widget.onTabSelected(2),
                          ),
                          QuickActionCard(
                            icon: Icons.campaign,
                            label: 'Announcements',
                            onTap: () =>
                                context.push('/subscriber/announcements'),
                          ),
                          QuickActionCard(
                            icon: Icons.wifi,
                            label: 'My Subscription',
                            onTap: () =>
                                context.push('/subscriber/subscription'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Recent invoices.
                    SectionHeader(
                      title: 'Recent Invoices',
                      onSeeAll: () => widget.onTabSelected(1),
                    ),
                    if (invoices.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: EmptyState(
                          icon: Icons.receipt_long,
                          title: 'No invoices yet',
                          subtitle:
                              'Your invoices will appear here once generated.',
                        ),
                      )
                    else
                      Column(
                        children: invoices
                            .take(2)
                            .map(
                              (invoice) => InvoiceCard(
                                invoice: invoice,
                                onTap: () => context.push(
                                  '/subscriber/invoice-detail',
                                  extra: invoice,
                                ),
                              ),
                            )
                            .toList(),
                      ),

                    const SizedBox(height: 24),

                    // Recent announcements.
                    SectionHeader(
                      title: 'Announcements',
                      onSeeAll: () =>
                          context.push('/subscriber/announcements'),
                    ),
                    if (announcements.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: EmptyState(
                          icon: Icons.campaign,
                          title: 'No announcements',
                          subtitle:
                              'Racitelcom announcements will appear here.',
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: AppCard(
                          margin: EdgeInsets.zero,
                          child: _AnnouncementPreview(
                            title: announcements.first.title,
                            body: announcements.first.body,
                            date: announcements.first.date,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }
}

class _AnnouncementPreview extends StatelessWidget {
  final String title;
  final String body;
  final DateTime date;

  const _AnnouncementPreview({
    required this.title,
    required this.body,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMMM d, yyyy');
    final preview =
        body.length > 80 ? '${body.substring(0, 80)}...' : body;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              dateFormatter.format(date),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textLight,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          preview,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textGray,
              ),
        ),
      ],
    );
  }
}

