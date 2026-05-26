import 'package:get/get.dart';
import 'package:nextrade/models/market_model.dart';
import 'package:nextrade/services/firestore_service.dart';

class MarketController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();

  final markets = <MarketModel>[].obs;
  final filteredMarkets = <MarketModel>[].obs;
  final isLoading = false.obs;
  final selectedCategory = 'Semua'.obs;
  final selectedSort = 'Vol'.obs;
  final searchQuery = ''.obs;
  final isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMarkets();
  }

  Future<void> loadMarkets() async {
    try {
      isLoading.value = true;
      await _firestoreService.seedMarkets();
      final data = await _firestoreService.getMarkets();
      markets.value = data;
      applyFilters();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data market');
    } finally {
      isLoading.value = false;
    }
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

    if (selectedCategory.value != 'Semua') {
      result = result.where((m) => m.category == selectedCategory.value).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      result = result.where((m) =>
          m.name.toLowerCase().contains(q) ||
          m.symbol.toLowerCase().contains(q)).toList();
    }

    if (selectedSort.value == 'Gainer') {
      result.sort((a, b) => b.change.compareTo(a.change));
    } else if (selectedSort.value == 'Loser') {
      result.sort((a, b) => a.change.compareTo(b.change));
    } else {
      result.sort((a, b) {
        final volA = double.tryParse(a.volume.replaceAll('B', '').replaceAll('M', '')) ?? 0;
        final volB = double.tryParse(b.volume.replaceAll('B', '').replaceAll('M', '')) ?? 0;
        return volB.compareTo(volA);
      });
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
