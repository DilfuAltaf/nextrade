class PortfolioModel {
  final String id;
  final String userId;
  final String marketId;
  final String symbol;
  final String name;
  final double amount;
  final double avgBuyPrice;

  PortfolioModel({
    required this.id,
    required this.userId,
    required this.marketId,
    required this.symbol,
    required this.name,
    this.amount = 0,
    this.avgBuyPrice = 0,
  });

  double get currentValue => amount * 0;
  double get profitLoss => 0;
  double get profitLossPercent => 0;

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'marketId': marketId,
    'symbol': symbol,
    'name': name,
    'amount': amount,
    'avgBuyPrice': avgBuyPrice,
  };

  factory PortfolioModel.fromMap(Map<String, dynamic> map) => PortfolioModel(
    id: map['id'] as String,
    userId: map['userId'] as String,
    marketId: map['marketId'] as String,
    symbol: map['symbol'] as String,
    name: map['name'] as String,
    amount: (map['amount'] as num).toDouble(),
    avgBuyPrice: (map['avgBuyPrice'] as num).toDouble(),
  );

  PortfolioModel copyWith({
    String? id,
    String? userId,
    String? marketId,
    String? symbol,
    String? name,
    double? amount,
    double? avgBuyPrice,
  }) => PortfolioModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    marketId: marketId ?? this.marketId,
    symbol: symbol ?? this.symbol,
    name: name ?? this.name,
    amount: amount ?? this.amount,
    avgBuyPrice: avgBuyPrice ?? this.avgBuyPrice,
  );
}
