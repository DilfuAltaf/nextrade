class TransactionModel {
  final String id;
  final String userId;
  final String marketId;
  final String symbol;
  final String name;
  final String type;
  final double amount;
  final double price;
  final double total;
  final String status;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.marketId,
    required this.symbol,
    required this.name,
    required this.type,
    required this.amount,
    required this.price,
    required this.total,
    this.status = 'completed',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'marketId': marketId,
    'symbol': symbol,
    'name': name,
    'type': type,
    'amount': amount,
    'price': price,
    'total': total,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
  };

  factory TransactionModel.fromMap(Map<String, dynamic> map) => TransactionModel(
    id: map['id'] as String,
    userId: map['userId'] as String,
    marketId: map['marketId'] as String,
    symbol: map['symbol'] as String,
    name: map['name'] as String,
    type: map['type'] as String,
    amount: (map['amount'] as num).toDouble(),
    price: (map['price'] as num).toDouble(),
    total: (map['total'] as num).toDouble(),
    status: map['status'] as String? ?? 'completed',
    createdAt: DateTime.parse(map['createdAt'] as String),
  );
}
