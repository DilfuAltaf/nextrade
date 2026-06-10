import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nextrade/models/community_post_model.dart';
import 'package:nextrade/models/leaderboard_model.dart';
import 'package:nextrade/models/limit_order_model.dart';
import 'package:nextrade/models/market_model.dart';
import 'package:nextrade/models/notification_model.dart';
import 'package:nextrade/models/portfolio_model.dart';
import 'package:nextrade/models/transaction_model.dart';
import 'package:nextrade/models/watchlist_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Users
  Future<void> updateUserData(Map<String, dynamic> data, String uid) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  // Markets
  Future<List<MarketModel>> getMarkets() async {
    final snapshot = await _firestore.collection('markets').get();
    return snapshot.docs.map((doc) => MarketModel.fromMap(doc.data())).toList();
  }

  Future<MarketModel?> getMarket(String id) async {
    final doc = await _firestore.collection('markets').doc(id).get();
    if (!doc.exists) return null;
    return MarketModel.fromMap(doc.data()!);
  }

  Future<void> seedMarkets() async {
    final existing = await _firestore.collection('markets').get();
    if (existing.docs.isNotEmpty) return;
    final markets = [
      {'id': 'eurusd', 'name': 'Euro', 'symbol': 'EUR/USD', 'price': 1.08, 'change': 0.05, 'high24h': 1.09, 'low24h': 1.07, 'volume': 45200000000.0, 'category': 'Forex'},
      {'id': 'gbpusd', 'name': 'GBP/USD', 'symbol': 'GBP/USD', 'price': 1.26, 'change': -0.12, 'high24h': 1.27, 'low24h': 1.25, 'volume': 32100000000.0, 'category': 'Forex'},
      {'id': 'usdjpy', 'name': 'USD/JPY', 'symbol': 'USD/JPY', 'price': 149.50, 'change': 0.23, 'high24h': 150.00, 'low24h': 148.80, 'volume': 28700000000.0, 'category': 'Forex'},
      {'id': 'aapl', 'name': 'Apple', 'symbol': 'AAPL', 'price': 178.50, 'change': 0.78, 'high24h': 180.00, 'low24h': 177.00, 'volume': 8500000000.0, 'category': 'Saham'},
      {'id': 'tsla', 'name': 'Tesla', 'symbol': 'TSLA', 'price': 245.00, 'change': -1.23, 'high24h': 250.00, 'low24h': 242.00, 'volume': 6200000000.0, 'category': 'Saham'},
      {'id': 'googl', 'name': 'Google', 'symbol': 'GOOGL', 'price': 142.30, 'change': 0.45, 'high24h': 143.50, 'low24h': 141.00, 'volume': 4100000000.0, 'category': 'Saham'},
      {'id': 'xau', 'name': 'Gold', 'symbol': 'XAU', 'price': 2345.00, 'change': 0.12, 'high24h': 2360.00, 'low24h': 2330.00, 'volume': 12100000000.0, 'category': 'Gold'},
      {'id': 'xag', 'name': 'Silver', 'symbol': 'XAG', 'price': 28.50, 'change': -0.34, 'high24h': 29.00, 'low24h': 28.20, 'volume': 3500000000.0, 'category': 'Gold'},
      {'id': 'oil', 'name': 'Oil Futures', 'symbol': 'OIL', 'price': 78.40, 'change': 1.20, 'high24h': 79.00, 'low24h': 77.50, 'volume': 5600000000.0, 'category': 'Futures'},
      {'id': 'spx', 'name': 'S&P 500', 'symbol': 'SPX', 'price': 5120.00, 'change': 0.30, 'high24h': 5140.00, 'low24h': 5100.00, 'volume': 10200000000.0, 'category': 'Futures'},
    ];
    for (final market in markets) {
      await _firestore.collection('markets').doc(market['id'] as String).set(market);
    }
  }

  // Portfolio
  Future<List<PortfolioModel>> getPortfolio(String userId) async {
    final snapshot = await _firestore
        .collection('portfolios')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => PortfolioModel.fromMap(doc.data())).toList();
  }

  Future<void> updatePortfolio(PortfolioModel portfolio) async {
    await _firestore.collection('portfolios').doc(portfolio.id).set(portfolio.toMap());
  }

  Future<void> addPortfolio(PortfolioModel portfolio) async {
    await _firestore.collection('portfolios').doc(portfolio.id).set(portfolio.toMap());
  }

  Future<void> deletePortfolio(String id) async {
    await _firestore.collection('portfolios').doc(id).delete();
  }

  // Transactions
  Future<List<TransactionModel>> getTransactions(String userId) async {
    final snapshot = await _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => TransactionModel.fromMap(doc.data())).toList();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _firestore.collection('transactions').doc(transaction.id).set(transaction.toMap());
  }

  // Watchlist
  Future<List<WatchlistModel>> getWatchlist(String userId) async {
    final snapshot = await _firestore
        .collection('watchlists')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => WatchlistModel.fromMap(doc.data())).toList();
  }

  Future<void> addToWatchlist(WatchlistModel item) async {
    await _firestore.collection('watchlists').doc(item.id).set(item.toMap());
  }

  Future<void> removeFromWatchlist(String id) async {
    await _firestore.collection('watchlists').doc(id).delete();
  }

  Future<bool> isInWatchlist(String userId, String marketId) async {
    final snapshot = await _firestore
        .collection('watchlists')
        .where('userId', isEqualTo: userId)
        .where('marketId', isEqualTo: marketId)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  // Limit Orders
  Future<List<LimitOrderModel>> getLimitOrders(String userId) async {
    final snapshot = await _firestore
        .collection('limitOrders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => LimitOrderModel.fromMap(doc.data())).toList();
  }

  Future<void> addLimitOrder(LimitOrderModel order) async {
    await _firestore.collection('limitOrders').doc(order.id).set(order.toMap());
  }

  Future<void> updateLimitOrder(LimitOrderModel order) async {
    await _firestore.collection('limitOrders').doc(order.id).update(order.toMap());
  }

  // Notifications
  Future<List<NotificationItemModel>> getNotifications(String userId) async {
    final snapshot = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => NotificationItemModel.fromMap(doc.data())).toList();
  }

  Future<void> addNotification(NotificationItemModel notification) async {
    await _firestore.collection('notifications').doc(notification.id).set(notification.toMap());
  }

  Future<void> markNotificationRead(String id) async {
    await _firestore.collection('notifications').doc(id).update({'isRead': true});
  }

  Future<void> markAllNotificationsRead(String userId) async {
    final snapshot = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();
    for (final doc in snapshot.docs) {
      await doc.reference.update({'isRead': true});
    }
  }

  // Community
  Future<List<CommunityPostModel>> getCommunityPosts() async {
    final snapshot = await _firestore
        .collection('communityPosts')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => CommunityPostModel.fromMap(doc.data())).toList();
  }

  Future<void> addCommunityPost(CommunityPostModel post) async {
    await _firestore.collection('communityPosts').doc(post.id).set(post.toMap());
  }

  Future<void> likePost(String postId, String userId) async {
    final doc = await _firestore.collection('communityPosts').doc(postId).get();
    if (!doc.exists) return;
    final data = doc.data()!;
    final likedBy = List<String>.from(data['likedBy'] as List? ?? []);
    if (likedBy.contains(userId)) {
      likedBy.remove(userId);
      await doc.reference.update({'likes': FieldValue.increment(-1), 'likedBy': likedBy});
    } else {
      likedBy.add(userId);
      await doc.reference.update({'likes': FieldValue.increment(1), 'likedBy': likedBy});
    }
  }

  // Leaderboard
  Future<List<LeaderboardModel>> getLeaderboard() async {
    final snapshot = await _firestore
        .collection('leaderboard')
        .orderBy('profit', descending: true)
        .limit(50)
        .get();
    return snapshot.docs.map((doc) => LeaderboardModel.fromMap(doc.data())).toList();
  }

  Future<void> updateLeaderboard(LeaderboardModel entry) async {
    await _firestore.collection('leaderboard').doc(entry.id).set(entry.toMap());
  }
}
