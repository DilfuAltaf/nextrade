import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String? photoUrl;
  final double virtualBalance;
  final double totalProfit;
  final int totalTrades;
  final double winRate;
  final bool isEmailVerified;
  final bool isTwoFactorEnabled;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    this.photoUrl,
    this.virtualBalance = 10000.00,
    this.totalProfit = 0,
    this.totalTrades = 0,
    this.winRate = 0,
    this.isEmailVerified = false,
    this.isTwoFactorEnabled = false,
    required this.createdAt,
    this.lastLoginAt,
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'fullName': fullName,
    'photoUrl': photoUrl,
    'virtualBalance': virtualBalance,
    'totalProfit': totalProfit,
    'totalTrades': totalTrades,
    'winRate': winRate,
    'isEmailVerified': isEmailVerified,
    'isTwoFactorEnabled': isTwoFactorEnabled,
    'createdAt': TimestampConverter.toTimestamp(createdAt),
    'lastLoginAt': lastLoginAt != null ? TimestampConverter.toTimestamp(lastLoginAt!) : null,
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    uid: map['uid'] as String,
    email: map['email'] as String,
    fullName: map['fullName'] as String,
    photoUrl: map['photoUrl'] as String?,
    virtualBalance: (map['virtualBalance'] as num).toDouble(),
    totalProfit: (map['totalProfit'] as num).toDouble(),
    totalTrades: (map['totalTrades'] as int),
    winRate: (map['winRate'] as num).toDouble(),
    isEmailVerified: map['isEmailVerified'] as bool,
    isTwoFactorEnabled: map['isTwoFactorEnabled'] as bool,
    createdAt: TimestampConverter.fromTimestamp(map['createdAt']),
    lastLoginAt: map['lastLoginAt'] != null ? TimestampConverter.fromTimestamp(map['lastLoginAt']) : null,
  );

  UserModel copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? photoUrl,
    double? virtualBalance,
    double? totalProfit,
    int? totalTrades,
    double? winRate,
    bool? isEmailVerified,
    bool? isTwoFactorEnabled,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) => UserModel(
    uid: uid ?? this.uid,
    email: email ?? this.email,
    fullName: fullName ?? this.fullName,
    photoUrl: photoUrl ?? this.photoUrl,
    virtualBalance: virtualBalance ?? this.virtualBalance,
    totalProfit: totalProfit ?? this.totalProfit,
    totalTrades: totalTrades ?? this.totalTrades,
    winRate: winRate ?? this.winRate,
    isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    isTwoFactorEnabled: isTwoFactorEnabled ?? this.isTwoFactorEnabled,
    createdAt: createdAt ?? this.createdAt,
    lastLoginAt: lastLoginAt ?? this.lastLoginAt,
  );
}

class TimestampConverter {
  static DateTime fromTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    if (timestamp is DateTime) return timestamp;
    if (timestamp is Timestamp) return timestamp.toDate();
    return DateTime.now();
  }

  static dynamic toTimestamp(DateTime dateTime) {
    return dateTime;
  }
}
