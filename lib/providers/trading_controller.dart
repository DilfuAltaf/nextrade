import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:nextrade/models/limit_order_model.dart';
import 'package:nextrade/models/portfolio_model.dart';
import 'package:nextrade/models/transaction_model.dart';
import 'package:nextrade/providers/auth_controller.dart';
import 'package:nextrade/providers/portfolio_controller.dart';
import 'package:nextrade/services/firestore_service.dart';

class TradingController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthController _authController = Get.find();
  final PortfolioController _portfolioController = Get.find();
  final _uuid = const Uuid();

  final transactions = <TransactionModel>[].obs;
  final limitOrders = <LimitOrderModel>[].obs;
  final isLoading = false.obs;
  final isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final userId = _authController.user.value?.uid;
      if (userId == null) return;
      final txData = await _firestoreService.getTransactions(userId);
      transactions.value = txData;
      final orderData = await _firestoreService.getLimitOrders(userId);
      limitOrders.value = orderData;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data transaksi');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> executeBuy({
    required String marketId,
    required String symbol,
    required String name,
    required double amount,
    required double price,
  }) async {
    try {
      isProcessing.value = true;
      final userModel = _authController.user.value;
      if (userModel == null) return {'success': false, 'message': 'Silakan login terlebih dahulu'};

      final totalCost = amount * price;
      if (userModel.virtualBalance < totalCost) {
        return {'success': false, 'message': 'Saldo tidak mencukupi. Dibutuhkan \$${totalCost.toStringAsFixed(2)}'};
      }

      final userId = userModel.uid;
      final txId = _uuid.v4();

      final tx = TransactionModel(
        id: txId,
        userId: userId,
        marketId: marketId,
        symbol: symbol,
        name: name,
        type: 'buy',
        amount: amount,
        price: price,
        total: totalCost,
        createdAt: DateTime.now(),
      );
      await _firestoreService.addTransaction(tx);
      transactions.insert(0, tx);

      final newBalance = userModel.virtualBalance - totalCost;
      _authController.user.value = userModel.copyWith(
        virtualBalance: newBalance,
        totalTrades: userModel.totalTrades + 1,
      );
      await _firestoreService.updateUserData(_authController.user.value!.toMap(), userId);

      final existingPortfolio = _portfolioController.portfolioAssets
          .firstWhereOrNull((p) => p.marketId == marketId);
      if (existingPortfolio != null) {
        final newAmount = existingPortfolio.amount + amount;
        final newAvgPrice = ((existingPortfolio.avgBuyPrice * existingPortfolio.amount) + (price * amount)) / newAmount;
        await _firestoreService.updatePortfolio(
          existingPortfolio.copyWith(amount: newAmount, avgBuyPrice: newAvgPrice),
        );
      } else {
        await _firestoreService.addPortfolio(PortfolioModel(
          id: _uuid.v4(),
          userId: userId,
          marketId: marketId,
          symbol: symbol,
          name: name,
          amount: amount,
          avgBuyPrice: price,
        ));
      }
      await _portfolioController.loadPortfolio();

      return {'success': true, 'message': 'Berhasil membeli $amount $symbol'};
    } catch (e) {
      return {'success': false, 'message': 'Gagal melakukan transaksi: $e'};
    } finally {
      isProcessing.value = false;
    }
  }

  Future<Map<String, dynamic>> executeSell({
    required String marketId,
    required String symbol,
    required String name,
    required double amount,
    required double price,
  }) async {
    try {
      isProcessing.value = true;
      final userModel = _authController.user.value;
      if (userModel == null) return {'success': false, 'message': 'Silakan login terlebih dahulu'};

      final existingPortfolio = _portfolioController.portfolioAssets
          .firstWhereOrNull((p) => p.marketId == marketId);
      // Tambahkan toleransi kecil untuk floating point (0.0001)
      if (existingPortfolio == null || (existingPortfolio.amount - amount) < -0.0001) {
        return {'success': false, 'message': 'Jumlah aset tidak mencukupi'};
      }

      final userId = userModel.uid;
      final txId = _uuid.v4();
      final totalValue = amount * price;

      final tx = TransactionModel(
        id: txId,
        userId: userId,
        marketId: marketId,
        symbol: symbol,
        name: name,
        type: 'sell',
        amount: amount,
        price: price,
        total: totalValue,
        createdAt: DateTime.now(),
      );
      await _firestoreService.addTransaction(tx);
      transactions.insert(0, tx);

      final newBalance = userModel.virtualBalance + totalValue;
      _authController.user.value = userModel.copyWith(
        virtualBalance: newBalance,
        totalTrades: userModel.totalTrades + 1,
      );
      await _firestoreService.updateUserData(_authController.user.value!.toMap(), userId);

      final remaining = existingPortfolio.amount - amount;
      if (remaining <= 0.0001) {
        await _firestoreService.deletePortfolio(existingPortfolio.id);
      } else {
        await _firestoreService.updatePortfolio(
          existingPortfolio.copyWith(amount: remaining),
        );
      }
      await _portfolioController.loadPortfolio();

      return {'success': true, 'message': 'Berhasil menjual $amount $symbol'};
    } catch (e) {
      return {'success': false, 'message': 'Gagal melakukan transaksi: $e'};
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> createLimitOrder({
    required String marketId,
    required String symbol,
    required String name,
    required String type,
    required String orderType,
    required double amount,
    required double price,
    double? triggerPrice,
  }) async {
    try {
      final userId = _authController.user.value?.uid;
      if (userId == null) return;

      final order = LimitOrderModel(
        id: _uuid.v4(),
        userId: userId,
        marketId: marketId,
        symbol: symbol,
        name: name,
        type: type,
        orderType: orderType,
        amount: amount,
        price: price,
        triggerPrice: triggerPrice ?? price,
        createdAt: DateTime.now(),
      );
      await _firestoreService.addLimitOrder(order);
      limitOrders.insert(0, order);
      Get.snackbar('Berhasil', 'Order ${orderType == 'limit' ? 'limit' : 'stop loss'} berhasil dibuat');
    } catch (e) {
      Get.snackbar('Error', 'Gagal membuat order');
    }
  }
}
