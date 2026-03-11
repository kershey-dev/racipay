import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../mock/mock_data.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/gradient_header_card.dart';
import '../../shared/widgets/info_row.dart';
import '../../shared/widgets/section_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0].isNotEmpty ? parts[0][0] : '').toUpperCase() +
          (parts[1].isNotEmpty ? parts[1][0] : '').toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '';
  }

  @override
  Widget build(BuildContext context) {
    final user = MockData.subscriberUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientHeaderCard(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.primaryBlue,
                        child: Text(
                          _initials(user.name),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Account: ${user.accountNumber}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        minimumSize: const Size(0, 36),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Profile editing will be available in a future update.',
                            ),
                          ),
                        );
                      },
                      child: const Text('Edit Profile'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Account Information'),
                    InfoRow(
                      icon: Icons.phone,
                      label: 'Mobile Number',
                      value: user.phone,
                    ),
                    InfoRow(
                      icon: Icons.home,
                      label: 'Address',
                      value: user.address,
                    ),
                    InfoRow(
                      icon: Icons.wifi,
                      label: 'Plan',
                      value: '${user.planName} • ${user.planSpeed}',
                    ),
                    const InfoRow(
                      icon: Icons.calendar_today,
                      label: 'Member since',
                      value: 'Jan 2023',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              AppCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: const Text('Subscription Details'),
                      onTap: () =>
                          context.push('/subscriber/subscription'),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading: const Icon(Icons.payment_outlined),
                      title: const Text('Payment History'),
                      onTap: () =>
                          context.push('/subscriber/payment-history'),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading: const Icon(Icons.notifications_outlined),
                      title: const Text('Notifications'),
                      onTap: () =>
                          context.push('/subscriber/notifications'),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading: const Icon(Icons.help_outline),
                      title: const Text('Help & About'),
                      onTap: () => context.push('/subscriber/help'),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      title: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Sign Out'),
                              content: const Text(
                                'Are you sure you want to sign out of your RACIPAY account?',
                              ),
                              actions: [
                                OutlinedButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text(
                                    'Sign Out',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        if (result == true && context.mounted) {
                          context.go('/login');
                        }
                      },
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

