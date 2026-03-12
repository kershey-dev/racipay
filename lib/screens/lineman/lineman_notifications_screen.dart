import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/empty_state.dart';

class LinemanNotificationsScreen extends StatefulWidget {
  const LinemanNotificationsScreen({super.key});

  @override
  State<LinemanNotificationsScreen> createState() =>
      _LinemanNotificationsScreenState();
}

class _LinemanNotificationsScreenState
    extends State<LinemanNotificationsScreen> {
  final List<_LinemanNotification> _notifications = [
    _LinemanNotification(
      message: 'New job assigned: TCK-2024-003',
      isRead: false,
    ),
    _LinemanNotification(
      message: 'Job TCK-2024-001 has been updated',
      isRead: false,
    ),
    _LinemanNotification(
      message: 'Reminder: Complete your job report',
      isRead: true,
    ),
    _LinemanNotification(
      message: 'System maintenance tonight 10PM-12AM',
      isRead: true,
    ),
  ];

  void _markAllRead() {
    setState(() {
      for (var n in _notifications) {
        n.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final allRead = _notifications.every((n) => n.isRead);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (!allRead)
            TextButton(
              onPressed: _markAllRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: allRead
            ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: EmptyState(
                  icon: Icons.notifications_none,
                  title: 'You\'re all caught up',
                  subtitle: 'No new notifications for now.',
                ),
              )
            : ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return AppCard(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: notification.isRead
                            ? Colors.white
                            : AppColors.lightBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            notification.isRead
                                ? Icons.notifications_none
                                : Icons.notifications_active_outlined,
                            color: notification.isRead
                                ? AppColors.textLight
                                : AppColors.primaryBlue,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              notification.message,
                              style: TextStyle(
                                color: notification.isRead
                                    ? AppColors.textGray
                                    : AppColors.textDark,
                                fontWeight: notification.isRead
                                    ? FontWeight.w400
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _LinemanNotification {
  final String message;
  bool isRead;

  _LinemanNotification({
    required this.message,
    required this.isRead,
  });
}

