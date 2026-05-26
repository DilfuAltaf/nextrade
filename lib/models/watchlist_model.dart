class WatchlistModel {
  final String id;
  final String userId;
  final String marketId;
  final String symbol;
  final String name;
  final DateTime addedAt;

  WatchlistModel({
    required this.id,
    required this.userId,
    required this.marketId,
    required this.symbol,
    required this.name,
    required this.addedAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'marketId': marketId,
    'symbol': symbol,
    'name': name,
    'addedAt': addedAt.toIso8601String(),
  };

  factory WatchlistModel.fromMap(Map<String, dynamic> map) => WatchlistModel(
    id: map['id'] as String,
    userId: map['userId'] as String,
    marketId: map['marketId'] as String,
    symbol: map['symbol'] as String,
    name: map['name'] as String,
    addedAt: DateTime.parse(map['addedAt'] as String),
  );
}
