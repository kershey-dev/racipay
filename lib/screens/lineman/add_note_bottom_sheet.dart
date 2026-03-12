import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/ticket_model.dart';

void showAddNoteBottomSheet({
  required BuildContext context,
  required TicketModel ticket,
  required Function(String note) onNoteSaved,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => AddNoteBottomSheetContent(
      ticket: ticket,
      onNoteSaved: onNoteSaved,
    ),
  );
}

class AddNoteBottomSheetContent extends StatefulWidget {
  final TicketModel ticket;
  final Function(String note) onNoteSaved;

  const AddNoteBottomSheetContent({
    super.key,
    required this.ticket,
    required this.onNoteSaved,
  });

  @override
  State<AddNoteBottomSheetContent> createState() =>
      _AddNoteBottomSheetContentState();
}

class _AddNoteBottomSheetContentState extends State<AddNoteBottomSheetContent> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.ticket.technicianNote ?? '';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _saveNote() {
    final note = _controller.text.trim();
    if (note.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a note'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _timer = Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      Navigator.pop(context);
      widget.onNoteSaved(note);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note saved successfully'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 16 + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Add Technician Note',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ticket: ${widget.ticket.ticketNumber}',
            style: const TextStyle(
              color: AppColors.textGray,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _controller,
            maxLines: 5,
            maxLength: 300,
            autofocus: true,
            decoration: InputDecoration(
              hintText:
                  'Describe the work done, findings, or remarks...',
              alignLabelWithHint: true,
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryBlue),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed:
                      _isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveNote,
                  child: _isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text('Save Note'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

