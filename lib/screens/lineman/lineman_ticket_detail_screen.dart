import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/ticket_model.dart';
import '../../core/utils/formatters.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/info_row.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/status_badge.dart';
import 'add_note_bottom_sheet.dart';

class LinemanTicketDetailScreen extends StatefulWidget {
  final TicketModel ticket;

  const LinemanTicketDetailScreen({
    super.key,
    required this.ticket,
  });

  @override
  State<LinemanTicketDetailScreen> createState() =>
      _LinemanTicketDetailScreenState();
}

class _LinemanTicketDetailScreenState extends State<LinemanTicketDetailScreen> {
  late TicketModel _ticket;

  @override
  void initState() {
    super.initState();
    _ticket = widget.ticket;
  }

  void _handleNoteSaved(String note) {
    setState(() {
      _ticket = _ticket.copyWith(technicianNote: note);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_ticket.ticketNumber),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGradientHeader(),
                    const SizedBox(height: 24),
                    _buildCustomerInformationSection(),
                    const SizedBox(height: 16),
                    _buildServiceDetailsSection(),
                    const SizedBox(height: 16),
                    _buildServiceLocationSection(),
                    const SizedBox(height: 16),
                    _buildTechnicianNotesSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildBottomActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryBlue,
            Color(0xFF1E40AF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _ticket.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white70),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.category_outlined,
                      color: Colors.white70,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _ticket.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: StatusBadge(status: _ticket.status),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Submitted ${Formatters.dateTime(_ticket.createdAt)}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInformationSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Customer Information'),
          InfoRow(
            icon: Icons.person,
            label: 'Name',
            value: _ticket.subscriberName,
          ),
          InfoRow(
            icon: Icons.phone,
            label: 'Contact',
            value: _ticket.subscriberContact,
          ),
          InfoRow(
            icon: Icons.home,
            label: 'Address',
            value: _ticket.subscriberAddress,
          ),
          InfoRow(
            icon: Icons.badge,
            label: 'Account',
            value: _ticket.subscriberId,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDetailsSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Service Details'),
          InfoRow(
            icon: Icons.category,
            label: 'Category',
            value: _ticket.category,
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.description,
                size: 20,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description',
                      style: TextStyle(
                        color: AppColors.textGray,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _ticket.description,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          InfoRow(
            icon: Icons.calendar_today,
            label: 'Submitted',
            value: Formatters.date(_ticket.createdAt),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceLocationSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Service Location'),
          const SizedBox(height: 8),
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryBlue),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.map_outlined,
                    color: AppColors.primaryBlue,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Service Location',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _ticket.subscriberAddress,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textGray,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Map integration coming soon',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicianNotesSection() {
    final note = _ticket.technicianNote?.trim() ?? '';

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Technician Notes'),
          const SizedBox(height: 8),
          if (note.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.note_outlined,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Note added:',
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          note,
                          style: const TextStyle(
                            color: AppColors.textGray,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              children: const [
                Icon(
                  Icons.note_add_outlined,
                  color: AppColors.textLight,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'No notes added yet.',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add / Update Note'),
              onPressed: () {
                showAddNoteBottomSheet(
                  context: context,
                  ticket: _ticket,
                  onNoteSaved: _handleNoteSaved,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.borderColor),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Proof'),
              onPressed: () {
                context.push(
                  '/lineman/upload-proof',
                  extra: _ticket,
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.update),
              label: const Text('Update Status'),
              onPressed: () {
                context.push(
                  '/lineman/update-status',
                  extra: _ticket,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

