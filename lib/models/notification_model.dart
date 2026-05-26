class NotificationItemModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String type;
  final bool isRead;
  final DateTime createdAt;

  NotificationItemModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.type,
    this.isRead = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'title': title,
    'description': description,
    'type': type,
    'isRead': isRead,
    'createdAt': createdAt.toIso8601String(),
  };

  factory NotificationItemModel.fromMap(Map<String, dynamic> map) => NotificationItemModel(
    id: map['id'] as String,
    userId: map['userId'] as String,
    title: map['title'] as String,
    description: map['description'] as String,
    type: map['type'] as String,
    isRead: map['isRead'] as bool? ?? false,
    createdAt: DateTime.parse(map['createdAt'] as String),
  );

  NotificationItemModel copyWith({bool? isRead}) => NotificationItemModel(
    id: id,
    userId: userId,
    title: title,
    description: description,
    type: type,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt,
  );
}
