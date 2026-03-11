import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<_NotificationItem> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      _NotificationItem(
        type: 'payment',
        title: 'Payment Confirmed',
        body: 'Your payment of ₱1,342.88 has been confirmed.',
        time: '2 hours ago',
        isRead: false,
      ),
      _NotificationItem(
        type: 'bill',
        title: 'New Bill Generated',
        body: 'Your bill for March 2024 is now available.',
        time: '1 day ago',
        isRead: false,
      ),
      _NotificationItem(
        type: 'ticket',
        title: 'Ticket Update',
        body: 'Your ticket TCK-0012 is now In Progress.',
        time: '2 days ago',
        isRead: true,
      ),
      _NotificationItem(
        type: 'announcement',
        title: 'Scheduled Maintenance',
        body: 'Network maintenance on March 20, 2-4 AM.',
        time: '3 days ago',
        isRead: true,
      ),
      _NotificationItem(
        type: 'payment',
        title: 'Payment Reminder',
        body:
            'Your bill is due in 3 days. Pay now to avoid late fees.',
        time: '5 days ago',
        isRead: true,
      ),
    ];
  }

  void _markAllRead() {
    setState(() {
      _items = _items
          .map((e) => e.copyWith(isRead: true))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: const Text('Mark all read'),
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: ListView.separated(
        itemCount: _items.length,
        separatorBuilder: (context, index) => const Divider(
          height: 0,
        ),
        itemBuilder: (context, index) {
          final item = _items[index];
          return _NotificationTile(item: item);
        },
      ),
    );
  }
}

class _NotificationItem {
  final String type;
  final String title;
  final String body;
  final String time;
  final bool isRead;

  _NotificationItem({
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
  });

  _NotificationItem copyWith({bool? isRead}) {
    return _NotificationItem(
      type: type,
      title: title,
      body: body,
      time: time,
      isRead: isRead ?? this.isRead,
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final _NotificationItem item;

  const _NotificationTile({required this.item});

  IconData _iconForType(String type) {
    switch (type) {
      case 'payment':
        return Icons.payment;
      case 'bill':
        return Icons.receipt;
      case 'ticket':
        return Icons.confirmation_number;
      case 'announcement':
        return Icons.campaign;
      default:
        return Icons.notifications;
    }
  }

  Color _iconColor(String type) {
    switch (type) {
      case 'payment':
        return AppColors.primaryBlue;
      case 'bill':
        return const Color(0xFFF97316); // orange
      case 'ticket':
        return const Color(0xFF7C3AED); // purple
      case 'announcement':
        return const Color(0xFF16A34A); // green
      default:
        return AppColors.primaryBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: item.isRead ? AppColors.white : AppColors.lightBlue,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _iconColor(item.type).withValues(alpha: 0.1),
          child: Icon(
            _iconForType(item.type),
            color: _iconColor(item.type),
          ),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            fontWeight:
                item.isRead ? FontWeight.w500 : FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        subtitle: Text(
          item.body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textGray,
          ),
        ),
        trailing: Text(
          item.time,
          style: const TextStyle(
            color: AppColors.textLight,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

