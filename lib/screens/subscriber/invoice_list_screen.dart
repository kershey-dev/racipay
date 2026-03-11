import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../mock/mock_data.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/invoice_card.dart';
import '../../shared/widgets/shimmer_loader.dart';

class InvoiceListScreen extends StatefulWidget {
  final bool isTab;

  const InvoiceListScreen({
    super.key,
    this.isTab = false,
  });

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _hasError = false;
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
    _searchController.dispose();
    super.dispose();
  }

  void _setFilter(String filter) {
    setState(() {
      _filter = filter;
    });
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
    final invoices = MockData.invoices;
    final searchQuery = _searchController.text.toLowerCase();

    final filtered = invoices.where((invoice) {
      if (_filter != 'All' && invoice.status.toLowerCase() != _filter.toLowerCase()) {
        return false;
      }
      if (searchQuery.isEmpty) return true;
      return invoice.invoiceNumber.toLowerCase().contains(searchQuery) ||
          invoice.period.toLowerCase().contains(searchQuery);
    }).toList();

    final listView = _isLoading
        ? const ShimmerLoader(itemCount: 5)
        : _hasError
            ? ErrorState(
                message:
                    'We were unable to load your invoices. Please try again.',
                onRetry: _retry,
              )
            : filtered.isEmpty
                ? const EmptyState(
                    icon: Icons.receipt_long,
                    title: 'No Invoices Found',
                    subtitle:
                        'No invoices match your search or filter.',
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final invoice = filtered[index];
                      return InvoiceCard(
                        invoice: invoice,
                        onTap: () => context.push(
                          '/subscriber/invoice-detail',
                          extra: invoice,
                        ),
                      );
                    },
                  );

    final content = Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search invoices',
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
            onChanged: (_) => setState(() {}),
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
                onSelected: () => _setFilter('All'),
              ),
              _FilterChip(
                label: 'Paid',
                selected: _filter == 'paid',
                onSelected: () => _setFilter('paid'),
              ),
              _FilterChip(
                label: 'Pending',
                selected: _filter == 'pending',
                onSelected: () => _setFilter('pending'),
              ),
              _FilterChip(
                label: 'Overdue',
                selected: _filter == 'overdue',
                onSelected: () => _setFilter('overdue'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(child: listView),
      ],
    );

    if (widget.isTab) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: content),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Invoices'),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(child: content),
    );
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
        labelStyle: TextStyle(
          color: selected ? AppColors.white : AppColors.textDark,
        ),
        backgroundColor: AppColors.lightBlue,
      ),
    );
  }
}

