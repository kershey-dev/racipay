import 'package:intl/intl.dart';

import '../core/models/announcement_model.dart';
import '../core/models/bill_model.dart';
import '../core/models/invoice_model.dart';
import '../core/models/payment_model.dart';
import '../core/models/ticket_model.dart';
import '../core/models/user_model.dart';

/// Centralized mock data for the RACIPAY application.
class MockData {
  static UserModel subscriberUser = const UserModel(
    id: '1',
    name: 'Juan dela Cruz',
    email: 'subscriber@racitelcom.com',
    phone: '09171234567',
    address: '123 Rizal St, Barangay Uno, Quezon City',
    role: 'subscriber',
    accountNumber: 'RTC-2024-0001',
    planName: 'Fiber Plus 50',
    planSpeed: '50 Mbps',
    planFee: 1299.00,
  );

  static UserModel linemanUser = const UserModel(
    id: '2',
    name: 'Pedro Santos',
    email: 'lineman@racitelcom.com',
    phone: '09181234567',
    address: '456 Mabini Ave, Quezon City',
    role: 'lineman',
    accountNumber: 'EMP-2024-0042',
    planName: 'N/A',
    planSpeed: 'N/A',
    planFee: 0,
  );

  /// Current pending bill for the subscriber.
  static BillModel currentBill = BillModel(
    id: 'bill_001',
    subscriberId: subscriberUser.id,
    amount: 1299.00,
    dueDate: DateTime.now().add(const Duration(days: 7)),
    status: 'pending',
    period: _formatPeriod(DateTime.now()),
    planFee: 1299.00,
    tax: 0,
    total: 1299.00,
  );

  /// Mock invoices (1 paid, 1 pending, 1 overdue).
  static List<InvoiceModel> invoices = [
    InvoiceModel(
      id: 'inv_001',
      billId: 'bill_001',
      subscriberId: subscriberUser.id,
      invoiceNumber: 'RTC-INV-2024-0001',
      amount: 1299.00,
      status: 'pending',
      issueDate: DateTime.now().subtract(const Duration(days: 3)),
      dueDate: DateTime.now().add(const Duration(days: 7)),
      period: _formatPeriod(DateTime.now()),
    ),
    InvoiceModel(
      id: 'inv_002',
      billId: 'bill_000',
      subscriberId: subscriberUser.id,
      invoiceNumber: 'RTC-INV-2024-0000',
      amount: 1299.00,
      status: 'paid',
      issueDate: DateTime.now().subtract(const Duration(days: 35)),
      dueDate: DateTime.now().subtract(const Duration(days: 5)),
      period: _formatPeriod(
        DateTime.now().subtract(const Duration(days: 30)),
      ),
    ),
    InvoiceModel(
      id: 'inv_003',
      billId: 'bill_002',
      subscriberId: subscriberUser.id,
      invoiceNumber: 'RTC-INV-2024-0002',
      amount: 1299.00,
      status: 'overdue',
      issueDate: DateTime.now().subtract(const Duration(days: 65)),
      dueDate: DateTime.now().subtract(const Duration(days: 35)),
      period: _formatPeriod(
        DateTime.now().subtract(const Duration(days: 60)),
      ),
    ),
  ];

  /// Mock payments: two completed, one failed, linked to invoices above.
  static List<PaymentModel> payments = [
    PaymentModel(
      id: 'p1',
      invoiceId: 'inv_001',
      subscriberId: subscriberUser.id,
      referenceNumber: 'RTC-20240112',
      amount: 1342.88,
      method: 'gcash',
      status: 'completed',
      paidAt: DateTime(2024, 1, 12, 10, 30),
    ),
    PaymentModel(
      id: 'p2',
      invoiceId: 'inv_002',
      subscriberId: subscriberUser.id,
      referenceNumber: 'RTC-20240215',
      amount: 1342.88,
      method: 'card',
      status: 'completed',
      paidAt: DateTime(2024, 2, 15, 14, 45),
    ),
    PaymentModel(
      id: 'p3',
      invoiceId: 'inv_003',
      subscriberId: subscriberUser.id,
      referenceNumber: 'RTC-20240310',
      amount: 1342.88,
      method: 'gcash',
      status: 'failed',
      paidAt: DateTime(2024, 3, 10, 9, 15),
    ),
  ];

  /// Mock tickets (1 pending, 1 in_progress, 1 resolved).
  static List<TicketModel> tickets = [
    TicketModel(
      id: 'ticket_001',
      ticketNumber: 'RTC-TCK-2024-0001',
      subscriberId: subscriberUser.id,
      subscriberName: subscriberUser.name,
      subscriberAddress: subscriberUser.address,
      subscriberContact: subscriberUser.phone,
      title: 'No internet connection',
      description:
          'Our household has no internet connection since this morning. '
          'The LOS light on the modem is blinking red.',
      category: 'No Connection',
      status: 'pending',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      assignedTo: null,
      technicianNote: null,
      resolvedAt: null,
    ),
    TicketModel(
      id: 'ticket_002',
      ticketNumber: 'RTC-TCK-2024-0002',
      subscriberId: subscriberUser.id,
      subscriberName: subscriberUser.name,
      subscriberAddress: subscriberUser.address,
      subscriberContact: subscriberUser.phone,
      title: 'Slow internet during peak hours',
      description:
          'Connection slows down every night around 8-10 PM. '
          'Streaming becomes difficult even at low quality.',
      category: 'Slow Speed',
      status: 'in_progress',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      assignedTo: linemanUser.name,
      technicianNote: 'Checked ONU levels remotely, will visit on-site today.',
      resolvedAt: null,
    ),
    TicketModel(
      id: 'ticket_003',
      ticketNumber: 'RTC-TCK-2024-0003',
      subscriberId: subscriberUser.id,
      subscriberName: subscriberUser.name,
      subscriberAddress: subscriberUser.address,
      subscriberContact: subscriberUser.phone,
      title: 'Clarification on billing charges',
      description:
          'There is an additional charge on my latest bill that I do not recognize.',
      category: 'Billing Issue',
      status: 'resolved',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      assignedTo: linemanUser.name,
      technicianNote:
          'Explained prorated charges due to plan upgrade. Customer acknowledged.',
      resolvedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  /// Mock announcements with realistic Racitelcom-style content.
  static List<AnnouncementModel> announcements = [
    AnnouncementModel(
      id: 'ann_001',
      title: 'Scheduled maintenance in Quezon City',
      body:
          'Racitelcom will conduct network maintenance affecting select areas in '
          'Quezon City on March 15, 1:00 AM to 4:00 AM. Temporary service '
          'interruptions may occur during this window.',
      date: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
      category: 'Maintenance',
    ),
    AnnouncementModel(
      id: 'ann_002',
      title: 'New Fiber Plus 100 plan now available',
      body:
          'Enjoy faster speeds with our new Fiber Plus 100 Mbps plan. '
          'Upgrade through our customer care channels or visit our website for more details.',
      date: DateTime.now().subtract(const Duration(days: 5)),
      isRead: true,
      category: 'Product',
    ),
    AnnouncementModel(
      id: 'ann_003',
      title: 'Advisory on fraudulent messages',
      body:
          'Racitelcom will never ask for your password or one-time PIN via SMS, '
          'chat, or email. Do not share your account details with anyone. '
          'Report suspicious messages to our official support channels.',
      date: DateTime.now().subtract(const Duration(days: 10)),
      isRead: false,
      category: 'Security',
    ),
  ];

  static String _formatPeriod(DateTime date) {
    final formatter = DateFormat('MMMM yyyy');
    return formatter.format(date);
  }
}

