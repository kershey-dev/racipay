class BillModel {
  final String id;
  final String subscriberId;
  final double amount;
  final DateTime dueDate;
  final String status; // 'paid' | 'pending' | 'overdue'
  final String period;
  final double planFee;
  final double tax;
  final double total;

  const BillModel({
    required this.id,
    required this.subscriberId,
    required this.amount,
    required this.dueDate,
    required this.status,
    required this.period,
    required this.planFee,
    required this.tax,
    required this.total,
  });

  BillModel copyWith({
    String? id,
    String? subscriberId,
    double? amount,
    DateTime? dueDate,
    String? status,
    String? period,
    double? planFee,
    double? tax,
    double? total,
  }) {
    return BillModel(
      id: id ?? this.id,
      subscriberId: subscriberId ?? this.subscriberId,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      period: period ?? this.period,
      planFee: planFee ?? this.planFee,
      tax: tax ?? this.tax,
      total: total ?? this.total,
    );
  }

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json['id'] as String,
      subscriberId: json['subscriberId'] as String,
      amount: (json['amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      status: json['status'] as String,
      period: json['period'] as String,
      planFee: (json['planFee'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subscriberId': subscriberId,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'period': period,
      'planFee': planFee,
      'tax': tax,
      'total': total,
    };
  }
}

