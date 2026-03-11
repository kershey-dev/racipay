import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'invoice_list_screen.dart';
import 'profile_screen.dart';
import 'tabs/dashboard_home_tab.dart';
import 'ticket_list_screen.dart';

/// Main dashboard shell for subscriber users with bottom navigation.
class SubscriberDashboardScreen extends StatefulWidget {
  const SubscriberDashboardScreen({super.key});

  @override
  State<SubscriberDashboardScreen> createState() =>
      _SubscriberDashboardScreenState();
}

class _SubscriberDashboardScreenState extends State<SubscriberDashboardScreen> {
  int _currentIndex = 0;

  /// Updates the current tab index from bottom navigation or child tabs.
  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardHomeTab(
        onTabSelected: _onTabSelected,
      ),
      const InvoiceListScreen(isTab: true),
      const TicketListScreen(isTab: true),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(
            top: BorderSide(color: AppColors.borderColor, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabSelected,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          elevation: 0,
          selectedItemColor: AppColors.primaryBlue,
          unselectedItemColor: AppColors.textGray,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              label: 'Invoices',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number_outlined),
              label: 'Tickets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

