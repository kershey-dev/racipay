class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String role; // 'subscriber' or 'lineman'
  final String accountNumber;
  final String planName;
  final String planSpeed;
  final double planFee;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.role,
    required this.accountNumber,
    required this.planName,
    required this.planSpeed,
    required this.planFee,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? role,
    String? accountNumber,
    String? planName,
    String? planSpeed,
    double? planFee,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role ?? this.role,
      accountNumber: accountNumber ?? this.accountNumber,
      planName: planName ?? this.planName,
      planSpeed: planSpeed ?? this.planSpeed,
      planFee: planFee ?? this.planFee,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      role: json['role'] as String,
      accountNumber: json['accountNumber'] as String,
      planName: json['planName'] as String,
      planSpeed: json['planSpeed'] as String,
      planFee: (json['planFee'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'role': role,
      'accountNumber': accountNumber,
      'planName': planName,
      'planSpeed': planSpeed,
      'planFee': planFee,
    };
  }

  bool get isSubscriber => role == 'subscriber';

  bool get isLineman => role == 'lineman';
}

