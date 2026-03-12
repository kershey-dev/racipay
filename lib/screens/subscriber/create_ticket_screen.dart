import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final random = Random();
    final ticketNo = 'TCK-${random.nextInt(9000) + 1000}';

    setState(() {
      _isSubmitting = false;
    });

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 40,
              ),
              const SizedBox(height: 12),
              const Text('Ticket Submitted!'),
            ],
          ),
          content: Text(
            'Your support ticket has been submitted. Our team will review it '
            'and assign a technician shortly.\n\nTicket No: $ticketNo',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/subscriber/tickets');
              },
              child: const Text('View My Tickets'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Support Ticket'),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Concern Category *',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'No Connection',
                      child: Row(
                        children: [
                          Icon(Icons.wifi_off),
                          SizedBox(width: 8),
                          Text('No Connection'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Slow Speed',
                      child: Row(
                        children: [
                          Icon(Icons.speed),
                          SizedBox(width: 8),
                          Text('Slow Speed'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Billing Issue',
                      child: Row(
                        children: [
                          Icon(Icons.receipt),
                          SizedBox(width: 8),
                          Text('Billing Issue'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Other',
                      child: Row(
                        children: [
                          Icon(Icons.help_outline),
                          SizedBox(width: 8),
                          Text('Other'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a category.' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Subject *',
                    hintText: 'e.g. No internet connection since morning',
                  ),
                  maxLength: 100,
                  validator: (value) {
                    final text = (value ?? '').trim();
                    if (text.isEmpty) {
                      return 'Please enter a subject.';
                    }
                    if (text.length < 10) {
                      return 'Subject must be at least 10 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description *',
                    hintText: 'Please describe your concern in detail...',
                  ),
                  maxLines: 5,
                  maxLength: 500,
                  validator: (value) {
                    final text = (value ?? '').trim();
                    if (text.isEmpty) {
                      return 'Please enter a description.';
                    }
                    if (text.length < 20) {
                      return 'Description must be at least 20 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Icon(
                      Icons.attach_file,
                      size: 18,
                      color: AppColors.textGray,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Attach Photo (Optional)',
                      style: TextStyle(
                        color: AppColors.textGray,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Photo attachment will be available in a future update.',
                        ),
                      ),
                    );
                  },
                  child: DottedBorderContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 40,
                          color: AppColors.textLight,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap to attach a photo',
                          style: TextStyle(
                            color: AppColors.textGray,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'JPG, PNG up to 5MB',
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.white,
                              ),
                            ),
                          )
                        : const Text('Submit Ticket'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Simple dashed-like border container using a regular border for now.
class DottedBorderContainer extends StatelessWidget {
  final Widget child;

  const DottedBorderContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderColor,
          style: BorderStyle.solid,
          width: 1,
        ),
      ),
      child: Center(child: child),
    );
  }
}

