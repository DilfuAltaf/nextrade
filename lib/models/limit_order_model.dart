class LimitOrderModel {
  final String id;
  final String userId;
  final String marketId;
  final String symbol;
  final String name;
  final String type;
  final String orderType;
  final double amount;
  final double price;
  final double triggerPrice;
  final String status;
  final DateTime createdAt;
  final DateTime? executedAt;

  LimitOrderModel({
    required this.id,
    required this.userId,
    required this.marketId,
    required this.symbol,
    required this.name,
    required this.type,
    required this.orderType,
    required this.amount,
    required this.price,
    required this.triggerPrice,
    this.status = 'pending',
    required this.createdAt,
    this.executedAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'marketId': marketId,
    'symbol': symbol,
    'name': name,
    'type': type,
    'orderType': orderType,
    'amount': amount,
    'price': price,
    'triggerPrice': triggerPrice,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'executedAt': executedAt?.toIso8601String(),
  };

  factory LimitOrderModel.fromMap(Map<String, dynamic> map) => LimitOrderModel(
    id: map['id'] as String,
    userId: map['userId'] as String,
    marketId: map['marketId'] as String,
    symbol: map['symbol'] as String,
    name: map['name'] as String,
    type: map['type'] as String,
    orderType: map['orderType'] as String,
    amount: (map['amount'] as num).toDouble(),
    price: (map['price'] as num).toDouble(),
    triggerPrice: (map['triggerPrice'] as num).toDouble(),
    status: map['status'] as String? ?? 'pending',
    createdAt: DateTime.parse(map['createdAt'] as String),
    executedAt: map['executedAt'] != null ? DateTime.parse(map['executedAt'] as String) : null,
  );
}
