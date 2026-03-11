import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../mock/mock_data.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/shimmer_loader.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
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
    final announcements = MockData.announcements;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.announcementsTitle),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stay updated with the latest news from Racitelcom',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textGray,
                    ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const ShimmerLoader(itemCount: 4)
                    : announcements.isEmpty
                        ? const EmptyState(
                            icon: Icons.campaign,
                            title: 'No announcements',
                            subtitle:
                                'Racitelcom announcements will appear here.',
                          )
                        : ListView.builder(
                            itemCount: announcements.length,
                            itemBuilder: (context, index) {
                              final item = announcements[index];
                              return AnnouncementCard(
                                title: item.title,
                                body: item.body,
                                category: item.category,
                                date: item.date,
                                isRead: item.isRead,
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String body;
  final String category;
  final DateTime date;
  final bool isRead;

  const AnnouncementCard({
    super.key,
    required this.title,
    required this.body,
    required this.category,
    required this.date,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMMM d, yyyy');
    final preview =
        body.length > 140 ? '${body.substring(0, 140)}...' : body;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6, right: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textGray,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(
                label: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: AppColors.lightBlue,
              ),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          16,
                          16,
                          24,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(),
                                  icon: const Icon(Icons.close),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              dateFormatter.format(date),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textLight,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              body,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textDark,
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Text('Read More'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

