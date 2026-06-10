import 'package:get/get.dart';
import 'package:nextrade/models/portfolio_model.dart';
import 'package:nextrade/providers/auth_controller.dart';
import 'package:nextrade/providers/market_controller.dart';
import 'package:nextrade/services/firestore_service.dart';

class PortfolioController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthController _authController = Get.find();
  final MarketController _marketController = Get.find();

  final portfolioAssets = <PortfolioModel>[].obs;
  final portfolioValue = 0.0.obs;
  final totalProfit = 0.0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    ever(_authController.user, (user) {
      if (user != null) {
        loadPortfolio();
      } else {
        portfolioAssets.clear();
        portfolioValue.value = 0;
        totalProfit.value = 0;
      }
    });
    loadPortfolio();
  }

  Future<void> loadPortfolio() async {
    try {
      isLoading.value = true;
      final userId = _authController.user.value?.uid;
      if (userId == null) return;
      final data = await _firestoreService.getPortfolio(userId);
      portfolioAssets.value = data.where((a) => a.amount > 0.000001).toList();
      calculatePortfolioValue();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat portofolio');
    } finally {
      isLoading.value = false;
    }
  }

  void calculatePortfolioValue() {
    double total = 0;
    double profit = 0;

    for (final asset in portfolioAssets) {
      final market = _marketController.getMarketBySymbol(asset.symbol);
      if (market != null) {
        total += asset.amount * market.price;
        profit += (market.price - asset.avgBuyPrice) * asset.amount;
      }
    }

    portfolioValue.value = total;
    totalProfit.value = profit;
  }

  double getAssetValue(PortfolioModel asset) {
    final market = _marketController.getMarketBySymbol(asset.symbol);
    if (market == null) return 0;
    return asset.amount * market.price;
  }

  double getAssetProfit(PortfolioModel asset) {
    final market = _marketController.getMarketBySymbol(asset.symbol);
    if (market == null) return 0;
    return (market.price - asset.avgBuyPrice) * asset.amount;
  }

  double getAssetProfitPercent(PortfolioModel asset) {
    if (asset.avgBuyPrice == 0) return 0;
    final market = _marketController.getMarketBySymbol(asset.symbol);
    if (market == null) return 0;
    return ((market.price - asset.avgBuyPrice) / asset.avgBuyPrice) * 100;
  }

  double getAssetPercentage(PortfolioModel asset) {
    if (portfolioValue.value == 0) return 0;
    return (getAssetValue(asset) / portfolioValue.value) * 100;
  }
}
