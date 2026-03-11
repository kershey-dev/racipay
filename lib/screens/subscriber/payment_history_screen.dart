import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/models/payment_model.dart';
import '../../core/utils/formatters.dart';
import '../../mock/mock_data.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/gradient_header_card.dart';
import '../../shared/widgets/payment_card.dart';
import '../../shared/widgets/status_badge.dart';
import '../../shared/widgets/shimmer_loader.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
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
    final allPayments = MockData.payments;
    final completed = allPayments
        .where((p) => p.status == 'completed')
        .toList();
    final totalPaid = completed.fold<double>(
      0,
      (sum, p) => sum + p.amount,
    );

    List<PaymentModel> filtered = allPayments;

    if (_filter != 'All') {
      filtered = filtered
          .where((p) => p.status.toLowerCase() == _filter.toLowerCase())
          .toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered.where((p) {
        return p.referenceNumber.toLowerCase().contains(q) ||
            Formatters.currency(p.amount).toLowerCase().contains(q);
      }).toList();
    }

    Widget content;

    if (_isLoading) {
      content = const ShimmerLoader(itemCount: 5);
    } else if (_hasError) {
      content = ErrorState(
        message:
            'We were unable to load your payment history. Please try again.',
        onRetry: _retry,
      );
    } else if (filtered.isEmpty) {
      content = const EmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'No Payment Records',
        subtitle: 'Your payment history will appear here.',
      );
    } else {
      content = ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final payment = filtered[index];
          return PaymentCard(
            payment: payment,
            onTap: () => _showPaymentDetail(context, payment),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.paymentHistoryTitle),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: GradientHeaderCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Paid This Year',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Formatters.currency(totalPaid),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${completed.length} payments completed',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by reference or amount...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide:
                        const BorderSide(color: AppColors.borderColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
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
                    label: 'Completed',
                    selected: _filter == 'completed',
                    onSelected: () {
                      setState(() {
                        _filter = 'completed';
                      });
                    },
                  ),
                  _FilterChip(
                    label: 'Pending',
                    selected: _filter == 'pending',
                    onSelected: () {
                      setState(() {
                        _filter = 'pending';
                      });
                    },
                  ),
                  _FilterChip(
                    label: 'Failed',
                    selected: _filter == 'failed',
                    onSelected: () {
                      setState(() {
                        _filter = 'failed';
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }

  void _showPaymentDetail(BuildContext context, PaymentModel payment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Transaction Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              _DetailRow(
                label: 'Reference No.',
                value: payment.referenceNumber,
              ),
              _DetailRow(
                label: 'Amount',
                value: Formatters.currency(payment.amount),
              ),
              _DetailRow(
                label: 'Method',
                value: payment.method == 'gcash'
                    ? 'GCash'
                    : 'Credit/Debit Card',
              ),
              _DetailRow(
                label: 'Status',
                value: payment.status,
                isStatus: true,
              ),
              _DetailRow(
                label: 'Date',
                value: Formatters.dateTime(payment.paidAt),
              ),
              _DetailRow(
                label: 'Invoice ID',
                value: payment.invoiceId,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
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
        backgroundColor: AppColors.lightBlue,
        labelStyle: TextStyle(
          color: selected ? AppColors.white : AppColors.textDark,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isStatus;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget trailing;
    if (isStatus) {
      trailing = StatusBadge(status: value);
    } else {
      trailing = Text(
        value,
        style: const TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textGray,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: trailing,
            ),
          ),
        ],
      ),
    );
  }
}

