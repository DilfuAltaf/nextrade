import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextrade/app/routes/route_names.dart';
import 'package:nextrade/app/theme/app_theme.dart';
import 'package:nextrade/providers/auth_controller.dart';
import 'package:nextrade/providers/market_controller.dart';
import 'package:nextrade/services/firestore_service.dart';
import 'package:nextrade/models/watchlist_model.dart';
import 'package:nextrade/models/market_model.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  final _firestoreService = FirestoreService();
  final _auth = Get.find<AuthController>();
  final _marketController = Get.find<MarketController>();
  List<WatchlistModel> _watchlist = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWatchlist();
  }

  Future<void> loadWatchlist() async {
    final userId = _auth.user.value?.uid;
    if (userId == null) return;
    final data = await _firestoreService.getWatchlist(userId);
    setState(() { _watchlist = data; isLoading = false; });
  }

  Future<void> removeItem(String id) async {
    await _firestoreService.removeFromWatchlist(id);
    await loadWatchlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        title: Text('Watchlist', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _watchlist.isEmpty
              ? Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.star_border, size: 64, color: AppTheme.textSecondary.withValues(alpha: 0.5)),
                    const SizedBox(height: 16),
                    Text('Watchlist kosong', style: GoogleFonts.inter(fontSize: 16, color: AppTheme.textSecondary)),
                    const SizedBox(height: 8),
                    Text('Tambahkan market ke watchlist', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary.withValues(alpha: 0.7))),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => Get.toNamed(RouteNames.market),
                      icon: const Icon(Icons.add),
                      label: const Text('Cari Market'),
                    ),
                  ]),
                )
              : RefreshIndicator(
                  onRefresh: loadWatchlist,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: _watchlist.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = _watchlist[index];
                      final market = _marketController.getMarketBySymbol(item.symbol);
                      return _buildWatchlistItem(item, market);
                    },
                  ),
                ),
    );
  }

  Widget _buildWatchlistItem(WatchlistModel item, MarketModel? market) {
    final isUp = market?.isUp ?? true;
    final price = market?.price ?? 0;
    final change = market?.change ?? 0;

    return GestureDetector(
      onTap: () => Get.toNamed(RouteNames.chart, arguments: market?.toMap() ?? {'symbol': item.symbol, 'name': item.name, 'price': 0, 'change': 0}),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.primaryPurple.withValues(alpha: 0.2)),
            child: Center(child: Text(item.symbol.length > 3 ? item.symbol.substring(0, 2) : item.symbol, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryPurple))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            Text(item.symbol, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('\$${price.toStringAsFixed(2)}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: (isUp ? AppTheme.accentGreen : AppTheme.errorRed).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
              child: Text('${isUp ? '+' : ''}${change.toStringAsFixed(2)}%', style: GoogleFonts.inter(fontSize: 12, color: isUp ? AppTheme.accentGreen : AppTheme.errorRed, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => removeItem(item.id),
            child: const Icon(Icons.star, color: AppTheme.warningOrange, size: 20),
          ),
        ]),
      ),
    );
  }
}
