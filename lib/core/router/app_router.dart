import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/splash_screen.dart';
import '../../screens/lineman/lineman_dashboard_screen.dart';
import '../../screens/subscriber/announcements_screen.dart';
import '../../screens/subscriber/current_bill_screen.dart';
import '../../screens/subscriber/invoice_detail_screen.dart';
import '../../screens/subscriber/invoice_list_screen.dart';
import '../../screens/subscriber/help_about_screen.dart';
import '../../screens/subscriber/notifications_screen.dart';
import '../../screens/subscriber/payment_failed_screen.dart';
import '../../screens/subscriber/payment_history_screen.dart';
import '../../screens/subscriber/payment_processing_screen.dart';
import '../../screens/subscriber/payment_screen.dart';
import '../../screens/subscriber/payment_success_screen.dart';
import '../../screens/subscriber/profile_screen.dart';
import '../../screens/subscriber/subscriber_dashboard_screen.dart';
import '../../screens/subscriber/subscription_detail_screen.dart';
import '../../screens/subscriber/create_ticket_screen.dart';
import '../../screens/subscriber/ticket_detail_screen.dart';
import '../../screens/subscriber/ticket_list_screen.dart';
import '../../core/constants/app_strings.dart';

class _SimpleScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const _SimpleScaffold({
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: body,
      ),
    );
  }
}

/// Global GoRouter configuration for RACIPAY.
final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    // Subscriber routes
    GoRoute(
      path: '/subscriber/dashboard',
      name: 'subscriber-dashboard',
      builder: (context, state) => const SubscriberDashboardScreen(),
    ),
    GoRoute(
      path: '/subscriber/bill',
      name: 'subscriber-bill',
      builder: (context, state) => const CurrentBillScreen(),
    ),
    GoRoute(
      path: '/subscriber/invoices',
      name: 'subscriber-invoices',
      builder: (context, state) => const InvoiceListScreen(isTab: false),
    ),
    GoRoute(
      path: '/subscriber/invoice-detail',
      name: 'subscriber-invoice-detail',
      builder: (context, state) => InvoiceDetailScreen(
        invoice: state.extra! as dynamic,
      ),
    ),
    GoRoute(
      path: '/subscriber/payment',
      name: 'subscriber-payment',
      builder: (context, state) => PaymentScreen(
        invoice: state.extra != null ? state.extra! as dynamic : null,
      ),
    ),
    GoRoute(
      path: '/subscriber/payment-processing',
      name: 'subscriber-payment-processing',
      builder: (context, state) {
        final map = state.extra! as Map<dynamic, dynamic>;
        return PaymentProcessingScreen(
          method: map['method'] as String,
          invoice: map['invoice'] as dynamic,
        );
      },
    ),
    GoRoute(
      path: '/subscriber/payment-success',
      name: 'subscriber-payment-success',
      builder: (context, state) {
        final map = state.extra! as Map<dynamic, dynamic>;
        return PaymentSuccessScreen(
          method: map['method'] as String,
          invoice: map['invoice'] as dynamic,
        );
      },
    ),
    GoRoute(
      path: '/subscriber/payment-failed',
      name: 'subscriber-payment-failed',
      builder: (context, state) {
        final map = state.extra! as Map<dynamic, dynamic>;
        return PaymentFailedScreen(
          method: map['method'] as String,
          invoice: map['invoice'] as dynamic,
        );
      },
    ),
    GoRoute(
      path: '/subscriber/payment-history',
      name: 'subscriber-payment-history',
      builder: (context, state) => const PaymentHistoryScreen(),
    ),
    GoRoute(
      path: '/subscriber/tickets',
      name: 'subscriber-tickets',
      builder: (context, state) => const TicketListScreen(isTab: false),
    ),
    GoRoute(
      path: '/subscriber/create-ticket',
      name: 'subscriber-create-ticket',
      builder: (context, state) => const CreateTicketScreen(),
    ),
    GoRoute(
      path: '/subscriber/ticket-detail',
      name: 'subscriber-ticket-detail',
      builder: (context, state) => TicketDetailScreen(
        ticket: state.extra! as dynamic,
      ),
    ),
    GoRoute(
      path: '/subscriber/announcements',
      name: 'subscriber-announcements',
      builder: (context, state) => const AnnouncementsScreen(),
    ),
    GoRoute(
      path: '/subscriber/subscription',
      name: 'subscriber-subscription',
      builder: (context, state) => const SubscriptionDetailScreen(),
    ),
    GoRoute(
      path: '/subscriber/profile',
      name: 'subscriber-profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/subscriber/notifications',
      name: 'subscriber-notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/subscriber/help',
      name: 'subscriber-help',
      builder: (context, state) => const HelpAboutScreen(),
    ),
    // Lineman routes
    GoRoute(
      path: '/lineman/dashboard',
      name: 'lineman-dashboard',
      builder: (context, state) => const LinemanDashboardScreen(),
    ),
    GoRoute(
      path: '/lineman/tickets',
      name: 'lineman-tickets',
      builder: (context, state) => const _SimpleScaffold(
        title: AppStrings.assignedTicketsTitle,
        body: Text('Tickets currently assigned to you.'),
      ),
    ),
    GoRoute(
      path: '/lineman/ticket-detail',
      name: 'lineman-ticket-detail',
      builder: (context, state) => const _SimpleScaffold(
        title: AppStrings.linemanTicketDetailTitle,
        body: Text('Ticket details for field work.'),
      ),
    ),
    GoRoute(
      path: '/lineman/update-status',
      name: 'lineman-update-status',
      builder: (context, state) => const _SimpleScaffold(
        title: AppStrings.updateStatusTitle,
        body: Text('Update service ticket status.'),
      ),
    ),
    GoRoute(
      path: '/lineman/upload-proof',
      name: 'lineman-upload-proof',
      builder: (context, state) => const _SimpleScaffold(
        title: AppStrings.uploadProofTitle,
        body: Text('Upload proof of completed work.'),
      ),
    ),
    GoRoute(
      path: '/lineman/completed-jobs',
      name: 'lineman-completed-jobs',
      builder: (context, state) => const _SimpleScaffold(
        title: AppStrings.completedJobsTitle,
        body: Text('History of completed jobs.'),
      ),
    ),
    GoRoute(
      path: '/lineman/profile',
      name: 'lineman-profile',
      builder: (context, state) => const _SimpleScaffold(
        title: AppStrings.linemanProfileTitle,
        body: Text('Manage your lineman profile.'),
      ),
    ),
    GoRoute(
      path: '/lineman/notifications',
      name: 'lineman-notifications',
      builder: (context, state) => const _SimpleScaffold(
        title: AppStrings.linemanNotificationsTitle,
        body: Text('Lineman-specific notifications.'),
      ),
    ),
  ],
);

