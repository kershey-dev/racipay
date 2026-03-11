class InvoiceModel {
  final String id;
  final String billId;
  final String subscriberId;
  final String invoiceNumber;
  final double amount;
  final String status; // 'paid' | 'pending' | 'overdue'
  final DateTime issueDate;
  final DateTime dueDate;
  final String period;

  const InvoiceModel({
    required this.id,
    required this.billId,
    required this.subscriberId,
    required this.invoiceNumber,
    required this.amount,
    required this.status,
    required this.issueDate,
    required this.dueDate,
    required this.period,
  });

  InvoiceModel copyWith({
    String? id,
    String? billId,
    String? subscriberId,
    String? invoiceNumber,
    double? amount,
    String? status,
    DateTime? issueDate,
    DateTime? dueDate,
    String? period,
  }) {
    return InvoiceModel(
      id: id ?? this.id,
      billId: billId ?? this.billId,
      subscriberId: subscriberId ?? this.subscriberId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      period: period ?? this.period,
    );
  }

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] as String,
      billId: json['billId'] as String,
      subscriberId: json['subscriberId'] as String,
      invoiceNumber: json['invoiceNumber'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      issueDate: DateTime.parse(json['issueDate'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      period: json['period'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'billId': billId,
      'subscriberId': subscriberId,
      'invoiceNumber': invoiceNumber,
      'amount': amount,
      'status': status,
      'issueDate': issueDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'period': period,
    };
  }
}

