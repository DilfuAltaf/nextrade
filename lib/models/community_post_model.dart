class CommunityPostModel {
  final String id;
  final String userId;
  final String username;
  final String content;
  final int likes;
  final int comments;
  final int shares;
  final List<String> likedBy;
  final DateTime createdAt;

  CommunityPostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.content,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.likedBy = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'username': username,
    'content': content,
    'likes': likes,
    'comments': comments,
    'shares': shares,
    'likedBy': likedBy,
    'createdAt': createdAt.toIso8601String(),
  };

  factory CommunityPostModel.fromMap(Map<String, dynamic> map) => CommunityPostModel(
    id: map['id'] as String,
    userId: map['userId'] as String,
    username: map['username'] as String,
    content: map['content'] as String,
    likes: map['likes'] as int? ?? 0,
    comments: map['comments'] as int? ?? 0,
    shares: map['shares'] as int? ?? 0,
    likedBy: List<String>.from(map['likedBy'] as List? ?? []),
    createdAt: DateTime.parse(map['createdAt'] as String),
  );
}
