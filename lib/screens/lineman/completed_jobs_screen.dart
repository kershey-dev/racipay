import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/ticket_model.dart';
import '../../core/utils/formatters.dart';
import '../../mock/mock_data.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/shimmer_loader.dart';
import '../../shared/widgets/status_badge.dart';

class CompletedJobsScreen extends StatefulWidget {
  final bool isTab;

  const CompletedJobsScreen({
    super.key,
    required this.isTab,
  });

  @override
  State<CompletedJobsScreen> createState() => _CompletedJobsScreenState();
}

class _CompletedJobsScreenState extends State<CompletedJobsScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  Timer? _timer;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _simulateLoad();
  }

  void _simulateLoad() {
    _hasError = false;
    _isLoading = true;
    _timer?.cancel();
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

  List<TicketModel> get _completedTickets {
    try {
      final source =
          MockData.tickets.where((t) => t.status == 'resolved').toList();
      final query = _searchQuery.toLowerCase().trim();

      var result = source.where((ticket) {
        if (query.isEmpty) return true;
        final number = ticket.ticketNumber.toLowerCase();
        final name = ticket.subscriberName.toLowerCase();
        return number.contains(query) || name.contains(query);
      }).toList();

      result.sort((a, b) {
        final aDate = ticketResolvedDate(a);
        final bDate = ticketResolvedDate(b);
        return bDate.compareTo(aDate);
      });

      return result;
    } catch (_) {
      _hasError = true;
      return [];
    }
  }

  DateTime ticketResolvedDate(TicketModel ticket) {
    return ticket.resolvedAt ?? ticket.createdAt;
  }

  @override
  Widget build(BuildContext context) {
    final content = _buildBody(context);

    if (widget.isTab) {
      return SafeArea(child: content);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Jobs'),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(child: content),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 24.0),
        child: ShimmerLoader(itemCount: 6),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: 12),
            const Text(
              'Unable to load completed jobs',
              style: TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Please check your connection and try again.',
              style: TextStyle(
                color: AppColors.textGray,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _simulateLoad();
                });
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final tickets = _completedTickets;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isTab)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Completed Jobs',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildSummaryCard(tickets.length),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildSearchField(),
          ),
          const SizedBox(height: 8),
          if (tickets.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
              child: EmptyState(
                icon: Icons.check_circle_outline,
                title: 'No Completed Jobs',
                subtitle: 'Resolved jobs will appear here.',
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return _CompletedJobCard(
                  ticket: ticket,
                  onTap: () => context.push(
                    '/lineman/ticket-detail',
                    extra: ticket,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(int count) {
    final name = MockData.linemanUser.name;

    return AppCard(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.success,
              Color(0xFF15803D),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Completed',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Great work, $name!',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search completed jobs...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.primaryBlue),
        ),
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
    );
  }
}

class _CompletedJobCard extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback onTap;

  const _CompletedJobCard({
    required this.ticket,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final note = ticket.technicianNote?.trim();
    final date = ticket.resolvedAt ?? ticket.createdAt;

    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket.ticketNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  ticket.subscriberName,
                  style: const TextStyle(
                    color: AppColors.textGray,
                    fontSize: 12,
                  ),
                ),
                if (note != null && note.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    note,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textGray,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 2),
                Text(
                  Formatters.date(date),
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const StatusBadge(status: 'resolved'),
        ],
      ),
    );
  }
}

