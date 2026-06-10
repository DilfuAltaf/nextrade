class MarketModel {
  final String id;
  final String name;
  final String symbol;
  final double price;
  final double change;
  final double high24h;
  final double low24h;
  final double volume;
  final String category;

  MarketModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.change,
    required this.high24h,
    required this.low24h,
    required this.volume,
    required this.category,
  });

  bool get isUp => change >= 0;

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'symbol': symbol,
    'price': price,
    'change': change,
    'high24h': high24h,
    'low24h': low24h,
    'volume': volume,
    'category': category,
  };

  factory MarketModel.fromMap(Map<String, dynamic> map) {
    double parseVolume(dynamic vol) {
      if (vol is num) return vol.toDouble();
      if (vol is String) {
        String parsed = vol.toUpperCase().replaceAll('B', '').replaceAll('M', '').replaceAll('K', '');
        double val = double.tryParse(parsed) ?? 0.0;
        if (vol.toUpperCase().contains('B')) val *= 1000000000;
        else if (vol.toUpperCase().contains('M')) val *= 1000000;
        else if (vol.toUpperCase().contains('K')) val *= 1000;
        return val;
      }
      return 0.0;
    }

    return MarketModel(
      id: map['id'] as String,
      name: map['name'] as String,
      symbol: map['symbol'] as String,
      price: (map['price'] as num).toDouble(),
      change: (map['change'] as num).toDouble(),
      high24h: (map['high24h'] as num).toDouble(),
      low24h: (map['low24h'] as num).toDouble(),
      volume: parseVolume(map['volume']),
      category: map['category'] as String,
    );
  }

  MarketModel copyWith({
    String? id,
    String? name,
    String? symbol,
    double? price,
    double? change,
    double? high24h,
    double? low24h,
    double? volume,
    String? category,
  }) => MarketModel(
    id: id ?? this.id,
    name: name ?? this.name,
    symbol: symbol ?? this.symbol,
    price: price ?? this.price,
    change: change ?? this.change,
    high24h: high24h ?? this.high24h,
    low24h: low24h ?? this.low24h,
    volume: volume ?? this.volume,
    category: category ?? this.category,
  );
}
