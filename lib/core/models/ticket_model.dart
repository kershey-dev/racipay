class TicketModel {
  final String id;
  final String ticketNumber;
  final String subscriberId;
  final String subscriberName;
  final String subscriberAddress;
  final String subscriberContact;
  final String title;
  final String description;
  final String category; // 'No Connection' | 'Slow Speed' | 'Billing Issue' | 'Other'
  final String status; // 'pending' | 'in_progress' | 'resolved'
  final DateTime createdAt;
  final String? assignedTo;
  final String? technicianNote;
  final DateTime? resolvedAt;

  const TicketModel({
    required this.id,
    required this.ticketNumber,
    required this.subscriberId,
    required this.subscriberName,
    required this.subscriberAddress,
    required this.subscriberContact,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.createdAt,
    this.assignedTo,
    this.technicianNote,
    this.resolvedAt,
  });

  TicketModel copyWith({
    String? id,
    String? ticketNumber,
    String? subscriberId,
    String? subscriberName,
    String? subscriberAddress,
    String? subscriberContact,
    String? title,
    String? description,
    String? category,
    String? status,
    DateTime? createdAt,
    String? assignedTo,
    String? technicianNote,
    DateTime? resolvedAt,
  }) {
    return TicketModel(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      subscriberId: subscriberId ?? this.subscriberId,
      subscriberName: subscriberName ?? this.subscriberName,
      subscriberAddress: subscriberAddress ?? this.subscriberAddress,
      subscriberContact: subscriberContact ?? this.subscriberContact,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      assignedTo: assignedTo ?? this.assignedTo,
      technicianNote: technicianNote ?? this.technicianNote,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'] as String,
      ticketNumber: json['ticketNumber'] as String,
      subscriberId: json['subscriberId'] as String,
      subscriberName: json['subscriberName'] as String,
      subscriberAddress: json['subscriberAddress'] as String,
      subscriberContact: json['subscriberContact'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      assignedTo: json['assignedTo'] as String?,
      technicianNote: json['technicianNote'] as String?,
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticketNumber': ticketNumber,
      'subscriberId': subscriberId,
      'subscriberName': subscriberName,
      'subscriberAddress': subscriberAddress,
      'subscriberContact': subscriberContact,
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'assignedTo': assignedTo,
      'technicianNote': technicianNote,
      'resolvedAt': resolvedAt?.toIso8601String(),
    };
  }
}

