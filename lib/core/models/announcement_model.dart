class AnnouncementModel {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final bool isRead;
  final String category;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.isRead,
    required this.category,
  });

  AnnouncementModel copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? date,
    bool? isRead,
    String? category,
  }) {
    return AnnouncementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      date: date ?? this.date,
      isRead: isRead ?? this.isRead,
      category: category ?? this.category,
    );
  }

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      date: DateTime.parse(json['date'] as String),
      isRead: json['isRead'] as bool,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'date': date.toIso8601String(),
      'isRead': isRead,
      'category': category,
    };
  }
}

