class LeaderboardModel {
  final String id;
  final String userId;
  final String username;
  final double profit;
  final int followers;
  final int rank;

  LeaderboardModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.profit,
    this.followers = 0,
    this.rank = 0,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'username': username,
    'profit': profit,
    'followers': followers,
    'rank': rank,
  };

  factory LeaderboardModel.fromMap(Map<String, dynamic> map) => LeaderboardModel(
    id: map['id'] as String,
    userId: map['userId'] as String,
    username: map['username'] as String,
    profit: (map['profit'] as num).toDouble(),
    followers: map['followers'] as int? ?? 0,
    rank: map['rank'] as int? ?? 0,
  );
}
