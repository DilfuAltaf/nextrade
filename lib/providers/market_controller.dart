import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:nextrade/models/market_model.dart';
import 'package:nextrade/providers/portfolio_controller.dart';
import 'package:nextrade/providers/auth_controller.dart';
import 'package:nextrade/models/watchlist_model.dart';
import 'package:nextrade/services/firestore_service.dart';
import 'package:nextrade/services/binance_service.dart';
class MarketController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();

  final markets = <MarketModel>[].obs;
  final filteredMarkets = <MarketModel>[].obs;
  final isLoading = false.obs;
  final selectedCategory = 'Semua'.obs;
  final selectedSort = 'Vol'.obs;
  final searchQuery = ''.obs;
  final isRefreshing = false.obs;
  final watchlistMarketIds = <String>{}.obs;
  Timer? _realtimeTimer;
  final BinanceService _binanceService = BinanceService();
  StreamSubscription? _wsSubscription;

  @override
  void onInit() {
    super.onInit();
    loadMarkets();
    _loadWatchlist();
  }

  Future<void> _loadWatchlist() async {
    if (!Get.isRegistered<AuthController>()) return;
    final userId = Get.find<AuthController>().user.value?.id;
    if (userId != null) {
      final wList = await _firestoreService.getWatchlist(userId);
      watchlistMarketIds.value = wList.map((w) => w.marketId).toSet();
      applyFilters();
    }
  }

  Future<void> toggleWatchlist(MarketModel market) async {
    if (!Get.isRegistered<AuthController>()) {
      Get.snackbar('Error', 'Silakan login terlebih dahulu');
      return;
    }
    final userId = Get.find<AuthController>().user.value?.id;
    if (userId == null) {
      Get.snackbar('Error', 'Silakan login terlebih dahulu');
      return;
    }

    if (watchlistMarketIds.contains(market.id)) {
      watchlistMarketIds.remove(market.id);
      await _firestoreService.removeFromWatchlist('${userId}_${market.id}');
    } else {
      watchlistMarketIds.add(market.id);
      final item = WatchlistModel(
        id: '${userId}_${market.id}',
        userId: userId,
        marketId: market.id,
        symbol: market.symbol,
        name: market.name,
        addedAt: DateTime.now(),
      );
      await _firestoreService.addToWatchlist(item);
    }
    // trigger obx
    final updated = Set<String>.from(watchlistMarketIds);
    watchlistMarketIds.value = updated;
    applyFilters();
  }

  @override
  void onClose() {
    _realtimeTimer?.cancel();
    _wsSubscription?.cancel();
    _binanceService.disconnect();
    super.onClose();
  }

  Future<void> loadMarkets() async {
    try {
      isLoading.value = true;
      await _firestoreService.seedMarkets();
      final dbMarkets = await _firestoreService.getMarkets();
      
      // Try to load initial cryptos from REST API (may fail on Web due to CORS)
      final cryptoMarkets = await _binanceService.getInitialCryptos();
      
      markets.value = [...dbMarkets, ...cryptoMarkets];
      applyFilters();
      
      _startRealtimeSimulation();
      _startBinanceWebSocket();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data market');
    } finally {
      isLoading.value = false;
    }
  }

  void _startBinanceWebSocket() {
    _wsSubscription?.cancel();
    _wsSubscription = _binanceService.connectWebSocket().listen((updates) {
      if (updates.isEmpty) return;
      
      bool changed = false;
      final currentMarkets = markets.toList();
      final existingSymbols = currentMarkets.map((m) => m.symbol).toSet();

      for (final entry in updates.entries) {
        final symbol = entry.key;
        final data = entry.value;

        if (existingSymbols.contains(symbol)) {
          // Update existing
          final index = currentMarkets.indexWhere((m) => m.symbol == symbol);
          if (index != -1) {
            currentMarkets[index] = currentMarkets[index].copyWith(
              price: data['price'],
              high24h: data['high24h'],
              low24h: data['low24h'],
              volume: data['volume'],
              change: data['change'],
            );
            changed = true;
          }
        } else {
          // Dynamically add new crypto if it has decent volume (filtering spam)
          // This also bypasses CORS issues on Web since WebSocket usually works
          if ((data['volume'] as double) > 1000000) {
            currentMarkets.add(MarketModel(
              id: symbol.toLowerCase(),
              name: symbol.replaceAll('USDT', ''),
              symbol: symbol,
              price: data['price'],
              change: data['change'],
              high24h: data['high24h'],
              low24h: data['low24h'],
              volume: data['volume'],
              category: 'Crypto',
            ));
            existingSymbols.add(symbol);
            changed = true;
          }
        }
      }

      if (changed) {
        markets.value = currentMarkets;
        applyFilters();
        if (Get.isRegistered<PortfolioController>()) {
          Get.find<PortfolioController>().calculatePortfolioValue();
        }
      }
    }, onError: (e) {
      print('WebSocket Error: $e');
    });
  }

  void _startRealtimeSimulation() {
    _realtimeTimer?.cancel();
    _realtimeTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (markets.isEmpty) return;
      
      final random = Random();
      bool changed = false;
      final updatedMarkets = markets.map((m) {
        if (m.category == 'Crypto') return m;
        
        changed = true;
        final double currentPrice = m.price;
        // Simulate a small change between -0.2% and 0.2%
        final changePercent = (random.nextDouble() - 0.5) * 0.004;
        final newPrice = currentPrice + (currentPrice * changePercent);
        
        // Calculate new 24h change
        final newChange = m.change + (changePercent * 100);

        return m.copyWith(
          price: newPrice,
          change: newChange,
        );
      }).toList();

      if (changed) {
        markets.value = updatedMarkets;
        applyFilters();

        // Notify portfolio to recalculate real-time
        if (Get.isRegistered<PortfolioController>()) {
          Get.find<PortfolioController>().calculatePortfolioValue();
        }
      }
    });
  }

  @override
  Future<void> refresh() async {
    isRefreshing.value = true;
    await loadMarkets();
    isRefreshing.value = false;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    applyFilters();
  }

  void setSort(String sort) {
    selectedSort.value = sort;
    applyFilters();
  }

  void setSearch(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void applyFilters() {
    var result = markets.toList();

    if (selectedCategory.value == 'Favorites') {
      result = result.where((m) => watchlistMarketIds.contains(m.id)).toList();
    } else if (selectedCategory.value == 'Gainers') {
      result.sort((a, b) => b.change.compareTo(a.change));
      result = result.take(50).toList();
    } else if (selectedCategory.value == 'Losers') {
      result.sort((a, b) => a.change.compareTo(b.change));
      result = result.take(50).toList();
    } else if (selectedCategory.value == 'Trending') {
      result.sort((a, b) => b.volume.compareTo(a.volume));
      result = result.take(50).toList();
    } else if (selectedCategory.value != 'Semua') {
      result = result.where((m) => m.category == selectedCategory.value).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      result = result.where((m) =>
          m.name.toLowerCase().contains(q) ||
          m.symbol.toLowerCase().contains(q)).toList();
    }

    if (!['Gainers', 'Losers', 'Trending'].contains(selectedCategory.value)) {
      if (selectedSort.value == 'Gainer') {
        result.sort((a, b) => b.change.compareTo(a.change));
      } else if (selectedSort.value == 'Loser') {
        result.sort((a, b) => a.change.compareTo(b.change));
      } else {
        result.sort((a, b) => b.volume.compareTo(a.volume));
      }
    }

    filteredMarkets.value = result;
  }

  MarketModel? getMarketById(String id) {
    return markets.firstWhereOrNull((m) => m.id == id);
  }

  MarketModel? getMarketBySymbol(String symbol) {
    return markets.firstWhereOrNull((m) => m.symbol == symbol);
  }
}
