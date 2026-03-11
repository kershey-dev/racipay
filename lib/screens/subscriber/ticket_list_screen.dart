import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/ticket_model.dart';
import '../../mock/mock_data.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/shimmer_loader.dart';
import '../../shared/widgets/ticket_card.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key, this.isTab = false});

  final bool isTab;

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  String _searchQuery = '';
  String _filter = 'All';

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

  void _retry() {
    setState(() {
      _hasError = false;
      _isLoading = true;
    });
    _timer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<TicketModel> tickets = MockData.tickets;

    if (_filter != 'All') {
      final status = _filter == 'Open'
          ? 'pending'
          : _filter == 'In Progress'
              ? 'in_progress'
              : 'resolved';
      tickets = tickets.where((t) => t.status == status).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      tickets = tickets.where((t) {
        return t.ticketNumber.toLowerCase().contains(q) ||
            t.title.toLowerCase().contains(q);
      }).toList();
    }

    Widget body;

    if (_isLoading) {
      body = const ShimmerLoader(itemCount: 5);
    } else if (_hasError) {
      body = ErrorState(
        message:
            'We were unable to load your support tickets. Please try again.',
        onRetry: _retry,
      );
    } else if (tickets.isEmpty) {
      body = const EmptyState(
        icon: Icons.confirmation_number_outlined,
        title: 'No Tickets Found',
        subtitle: 'You have not submitted any support tickets yet.',
      );
    } else {
      body = ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return TicketCard(
            ticket: ticket,
            onTap: () => context.push(
              '/subscriber/ticket-detail',
              extra: ticket,
            ),
          );
        },
      );
    }

    final content = Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search tickets...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: AppColors.borderColor),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            children: [
              _FilterChip(
                label: 'All',
                selected: _filter == 'All',
                onSelected: () {
                  setState(() {
                    _filter = 'All';
                  });
                },
              ),
              _FilterChip(
                label: 'Open',
                selected: _filter == 'Open',
                onSelected: () {
                  setState(() {
                    _filter = 'Open';
                  });
                },
              ),
              _FilterChip(
                label: 'In Progress',
                selected: _filter == 'In Progress',
                onSelected: () {
                  setState(() {
                    _filter = 'In Progress';
                  });
                },
              ),
              _FilterChip(
                label: 'Resolved',
                selected: _filter == 'Resolved',
                onSelected: () {
                  setState(() {
                    _filter = 'Resolved';
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(child: body),
      ],
    );

    final scaffold = Scaffold(
      backgroundColor: AppColors.background,
      appBar: widget.isTab
          ? null
          : AppBar(
              title: const Text('My Support Tickets'),
            ),
      body: SafeArea(child: content),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create Ticket',
        backgroundColor: AppColors.primaryBlue,
        onPressed: () => context.push('/subscriber/create-ticket'),
        child: const Icon(Icons.add),
      ),
    );

    return scaffold;
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
        selectedColor: AppColors.primaryBlue,
        backgroundColor: AppColors.lightBlue,
        labelStyle: TextStyle(
          color: selected ? AppColors.white : AppColors.textDark,
        ),
      ),
    );
  }
}

