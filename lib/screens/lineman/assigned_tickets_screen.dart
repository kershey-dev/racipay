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

class AssignedTicketsScreen extends StatefulWidget {
  final bool isTab;

  const AssignedTicketsScreen({
    super.key,
    required this.isTab,
  });

  @override
  State<AssignedTicketsScreen> createState() => _AssignedTicketsScreenState();
}

class _AssignedTicketsScreenState extends State<AssignedTicketsScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  Timer? _timer;

  String _searchQuery = '';
  String _statusFilter = 'all'; // all | pending | in_progress

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

  List<TicketModel> get _filteredTickets {
    try {
      final source =
          MockData.tickets.where((t) => t.status != 'resolved').toList();

      final query = _searchQuery.toLowerCase().trim();

      var result = source.where((ticket) {
        if (query.isEmpty) {
          return true;
        }
        final number = ticket.ticketNumber.toLowerCase();
        final name = ticket.subscriberName.toLowerCase();
        return number.contains(query) || name.contains(query);
      }).toList();

      if (_statusFilter != 'all') {
        result = result.where((t) => t.status == _statusFilter).toList();
      }

      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return result;
    } catch (_) {
      _hasError = true;
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = _buildBody(context);

    if (widget.isTab) {
      return SafeArea(
        child: content,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Assigned Jobs'),
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
              'Something went wrong',
              style: TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Unable to load assigned jobs. Please try again.',
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

    final tickets = _filteredTickets;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isTab)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'My Assigned Jobs',
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
            child: _buildSearchField(),
          ),
          const SizedBox(height: 8),
          _buildFilterChips(),
          const SizedBox(height: 8),
          if (tickets.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
              child: EmptyState(
                icon: Icons.assignment_outlined,
                title: 'No Assigned Jobs',
                subtitle: 'You have no pending or in-progress jobs.',
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return _AssignedJobCard(
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

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search by ticket number or customer...',
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

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _StatusFilterChip(
            label: 'All',
            value: 'all',
            groupValue: _statusFilter,
            onSelected: (value) {
              setState(() {
                _statusFilter = value;
              });
            },
          ),
          _StatusFilterChip(
            label: 'Pending',
            value: 'pending',
            groupValue: _statusFilter,
            onSelected: (value) {
              setState(() {
                _statusFilter = value;
              });
            },
          ),
          _StatusFilterChip(
            label: 'In Progress',
            value: 'in_progress',
            groupValue: _statusFilter,
            onSelected: (value) {
              setState(() {
                _statusFilter = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _StatusFilterChip extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onSelected;

  const _StatusFilterChip({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelected(value),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textDark,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
        selectedColor: AppColors.primaryBlue,
        backgroundColor: Colors.white,
        side: const BorderSide(color: AppColors.borderColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class _AssignedJobCard extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback onTap;

  const _AssignedJobCard({
    required this.ticket,
    required this.onTap,
  });

  Color _indicatorColor() {
    switch (ticket.status) {
      case 'in_progress':
        return AppColors.primaryBlue;
      case 'pending':
      default:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 84,
            decoration: BoxDecoration(
              color: _indicatorColor(),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        ticket.ticketNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(status: ticket.status),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 14,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        ticket.subscriberName,
                        style: const TextStyle(
                          color: AppColors.textGray,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        ticket.subscriberAddress,
                        style: const TextStyle(
                          color: AppColors.textGray,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.category_outlined,
                        size: 14,
                        color: AppColors.primaryBlue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        ticket.category,
                        style: const TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Submitted: ${Formatters.date(ticket.createdAt)}',
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

