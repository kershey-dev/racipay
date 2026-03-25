import '../utils/auth_role.dart';

class UserModel {
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
    // Optional fields from extended backend response.
    this.firstName,
    this.lastName,
    this.customerId,
    this.emailVerified,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;

  /// 'subscriber' | 'lineman'
  final String role;

  final String accountNumber;
  final String planName;
  final String planSpeed;
  final double planFee;

  // ── Optional / extended fields ─────────────────────────────────────────────
  final String? firstName;
  final String? lastName;
  final String? customerId;
  final bool? emailVerified;

  // ── Convenience getters ────────────────────────────────────────────────────
  bool get isSubscriber => role == 'subscriber';
  bool get isLineman => role == 'lineman';

  // ── fromJson ───────────────────────────────────────────────────────────────
  // Accepts both camelCase (Flutter convention) and snake_case (Laravel default).
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Prefer camelCase key; fall back to snake_case if absent.
    T? pick<T>(String camel, String snake) =>
        (json[camel] ?? json[snake]) as T?;

    return UserModel(
      // id may arrive as int from Laravel; always stringify.
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      phone: (json['phone'] ?? '') as String,
      address: (json['address'] ?? '') as String,
      // No default: missing/unknown role must not impersonate subscriber.
      role: normalizeRole(json['role'] as String?),

      accountNumber:
          pick<String>('accountNumber', 'account_number') ?? '',
      planName: pick<String>('planName', 'plan_name') ?? '',
      planSpeed: pick<String>('planSpeed', 'plan_speed') ?? '',
      planFee:
          ((pick<num>('planFee', 'plan_fee') ?? 0)).toDouble(),

      firstName: pick<String>('firstName', 'first_name'),
      lastName: pick<String>('lastName', 'last_name'),
      customerId: pick<Object>('customerId', 'customer_id')?.toString(),
      emailVerified: pick<bool>('emailVerified', 'email_verified'),
    );
  }

  // ── toJson ─────────────────────────────────────────────────────────────────
  Map<String, dynamic> toJson() => {
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
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
        if (customerId != null) 'customerId': customerId,
        if (emailVerified != null) 'emailVerified': emailVerified,
      };

  // ── copyWith ───────────────────────────────────────────────────────────────
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
    String? firstName,
    String? lastName,
    String? customerId,
    bool? emailVerified,
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
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      customerId: customerId ?? this.customerId,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }
}
