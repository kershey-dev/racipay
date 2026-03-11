class PaymentModel {
  final String id;
  final String invoiceId;
  final String subscriberId;
  final String referenceNumber;
  final double amount;
  final String method; // 'gcash' | 'card'
  final String status; // 'completed' | 'pending' | 'failed'
  final DateTime paidAt;

  const PaymentModel({
    required this.id,
    required this.invoiceId,
    required this.subscriberId,
    required this.referenceNumber,
    required this.amount,
    required this.method,
    required this.status,
    required this.paidAt,
  });

  PaymentModel copyWith({
    String? id,
    String? invoiceId,
    String? subscriberId,
    String? referenceNumber,
    double? amount,
    String? method,
    String? status,
    DateTime? paidAt,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      subscriberId: subscriberId ?? this.subscriberId,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      status: status ?? this.status,
      paidAt: paidAt ?? this.paidAt,
    );
  }

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      invoiceId: json['invoiceId'] as String,
      subscriberId: json['subscriberId'] as String,
      referenceNumber: json['referenceNumber'] as String,
      amount: (json['amount'] as num).toDouble(),
      method: json['method'] as String,
      status: json['status'] as String,
      paidAt: DateTime.parse(json['paidAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceId': invoiceId,
      'subscriberId': subscriberId,
      'referenceNumber': referenceNumber,
      'amount': amount,
      'method': method,
      'status': status,
      'paidAt': paidAt.toIso8601String(),
    };
  }
}

