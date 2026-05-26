import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextrade/app/routes/route_names.dart';
import 'package:nextrade/app/theme/app_theme.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  String _selectedCategory = 'Semua';
  String _selectedSort = 'Vol';
  final _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allMarkets = [
    {'name': 'Bitcoin', 'symbol': 'BTC', 'price': 67452.00, 'change': 2.45, 'vol': '28.5B', 'high': 68200.00, 'low': 66100.00, 'category': 'Crypto'},
    {'name': 'Ethereum', 'symbol': 'ETH', 'price': 3451.00, 'change': -0.89, 'vol': '15.2B', 'high': 3520.00, 'low': 3400.00, 'category': 'Crypto'},
    {'name': 'Solana', 'symbol': 'SOL', 'price': 145.32, 'change': 5.67, 'vol': '4.8B', 'high': 148.00, 'low': 138.00, 'category': 'Crypto'},
    {'name': 'Binance Coin', 'symbol': 'BNB', 'price': 578.90, 'change': 1.34, 'vol': '2.3B', 'high': 585.00, 'low': 570.00, 'category': 'Crypto'},
    {'name': 'Cardano', 'symbol': 'ADA', 'price': 0.45, 'change': -2.10, 'vol': '1.5B', 'high': 0.47, 'low': 0.44, 'category': 'Crypto'},
    {'name': 'Dogecoin', 'symbol': 'DOGE', 'price': 0.12, 'change': 8.45, 'vol': '3.2B', 'high': 0.13, 'low': 0.11, 'category': 'Crypto'},
    {'name': 'Polkadot', 'symbol': 'DOT', 'price': 7.89, 'change': -1.56, 'vol': '0.8B', 'high': 8.10, 'low': 7.70, 'category': 'Crypto'},
    {'name': 'Euro', 'symbol': 'EUR/USD', 'price': 1.08, 'change': 0.05, 'vol': '45.2B', 'high': 1.09, 'low': 1.07, 'category': 'Forex'},
    {'name': 'GBP/USD', 'symbol': 'GBP/USD', 'price': 1.26, 'change': -0.12, 'vol': '32.1B', 'high': 1.27, 'low': 1.25, 'category': 'Forex'},
    {'name': 'USD/JPY', 'symbol': 'USD/JPY', 'price': 149.50, 'change': 0.23, 'vol': '28.7B', 'high': 150.00, 'low': 148.80, 'category': 'Forex'},
    {'name': 'Apple', 'symbol': 'AAPL', 'price': 178.50, 'change': 0.78, 'vol': '8.5B', 'high': 180.00, 'low': 177.00, 'category': 'Saham'},
    {'name': 'Tesla', 'symbol': 'TSLA', 'price': 245.00, 'change': -1.23, 'vol': '6.2B', 'high': 250.00, 'low': 242.00, 'category': 'Saham'},
    {'name': 'Google', 'symbol': 'GOOGL', 'price': 142.30, 'change': 0.45, 'vol': '4.1B', 'high': 143.50, 'low': 141.00, 'category': 'Saham'},
    {'name': 'Gold', 'symbol': 'XAU', 'price': 2345.00, 'change': 0.12, 'vol': '12.1B', 'high': 2360.00, 'low': 2330.00, 'category': 'Gold'},
    {'name': 'Silver', 'symbol': 'XAG', 'price': 28.50, 'change': -0.34, 'vol': '3.5B', 'high': 29.00, 'low': 28.20, 'category': 'Gold'},
    {'name': 'Oil Futures', 'symbol': 'OIL', 'price': 78.40, 'change': 1.20, 'vol': '5.6B', 'high': 79.00, 'low': 77.50, 'category': 'Futures'},
    {'name': 'S&P 500', 'symbol': 'SPX', 'price': 5120.00, 'change': 0.30, 'vol': '10.2B', 'high': 5140.00, 'low': 5100.00, 'category': 'Futures'},
  ];

  List<Map<String, dynamic>> get _filteredMarkets {
    var result = _allMarkets;
    if (_selectedCategory != 'Semua') {
      result = result.where((m) => m['category'] == _selectedCategory).toList();
    }
    if (_searchController.text.isNotEmpty) {
      final q = _searchController.text.toLowerCase();
      result = result.where((m) =>
          (m['name'] as String).toLowerCase().contains(q) ||
          (m['symbol'] as String).toLowerCase().contains(q)).toList();
    }
    if (_selectedSort == 'Gainer') {
      result.sort((a, b) => (b['change'] as double).compareTo(a['change'] as double));
    } else if (_selectedSort == 'Loser') {
      result.sort((a, b) => (a['change'] as double).compareTo(b['change'] as double));
    } else {
      result.sort((a, b) {
        final volA = double.tryParse((a['vol'] as String).replaceAll('B', '').replaceAll('M', '')) ?? 0;
        final volB = double.tryParse((b['vol'] as String).replaceAll('B', '').replaceAll('M', '')) ?? 0;
        return volB.compareTo(volA);
      });
    }
    return result;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markets = _filteredMarkets;
    final categories = [
      {'label': 'Semua', 'icon': Icons.dashboard},
      {'label': 'Crypto', 'icon': Icons.currency_bitcoin},
      {'label': 'Forex', 'icon': Icons.monetization_on},
      {'label': 'Saham', 'icon': Icons.business},
      {'label': 'Gold', 'icon': Icons.circle},
      {'label': 'Futures', 'icon': Icons.trending_up},
    ];
    final sortOptions = ['Vol', 'Gainer', 'Loser'];

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        title: Text('Market', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(RouteNames.watchlist),
            icon: const Icon(Icons.star_border),
          ),
          IconButton(
            onPressed: () => Get.toNamed(RouteNames.notifications),
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: GoogleFonts.inter(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Cari market...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppTheme.darkCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
            ),
          ),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = _selectedCategory == cat['label'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat['label'] as String),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [AppTheme.primaryPurple, Color(0xFF6D28D9)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isSelected ? null : AppTheme.darkCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryPurple
                            : AppTheme.glassBorder,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          cat['icon'] as IconData,
                          size: 16,
                          color: isSelected ? Colors.white : AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          cat['label'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  '${markets.length} Market',
                  style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
                ),
                const Spacer(),
                ...sortOptions.map((sort) => Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedSort = sort),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _selectedSort == sort
                            ? AppTheme.primaryPurple.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _selectedSort == sort
                              ? AppTheme.primaryPurple.withValues(alpha: 0.5)
                              : AppTheme.glassBorder,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_selectedSort == sort)
                            Icon(
                              sort == 'Gainer'
                                  ? Icons.arrow_upward
                                  : sort == 'Loser'
                                      ? Icons.arrow_downward
                                      : Icons.bar_chart,
                              size: 12,
                              color: AppTheme.primaryPurple,
                            ),
                          if (_selectedSort == sort) const SizedBox(width: 4),
                          Text(
                            sort,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: _selectedSort == sort ? FontWeight.w600 : FontWeight.normal,
                              color: _selectedSort == sort ? AppTheme.primaryPurple : AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: markets.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 48, color: AppTheme.textSecondary.withValues(alpha: 0.5)),
                        const SizedBox(height: 12),
                        Text(
                          'Market tidak ditemukan',
                          style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: markets.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) => _buildMarketItem(markets[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketItem(Map<String, dynamic> item) {
    final isUp = (item['change'] as double) >= 0;
    final symbol = item['symbol'] as String;

    return GestureDetector(
      onTap: () => Get.toNamed(RouteNames.chart, arguments: item),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.glassBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getAssetColor(symbol).withValues(alpha: 0.3),
                    _getAssetColor(symbol).withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  symbol.length > 4 ? symbol.substring(0, 3) : symbol.substring(0, symbol.contains('/') ? symbol.indexOf('/') : symbol.length > 3 ? 3 : symbol.length),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _getAssetColor(symbol),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item['name'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(item['category'] as String).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item['category'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            color: _getCategoryColor(item['category'] as String),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        symbol,
                        style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 1,
                        height: 10,
                        color: AppTheme.textSecondary.withValues(alpha: 0.3),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 6,
                            color: isUp ? AppTheme.accentGreen : AppTheme.errorRed,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'H ${(item['high'] as num).toStringAsFixed(2)}',
                            style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'L ${(item['low'] as num).toStringAsFixed(2)}',
                            style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 60,
              height: 36,
              decoration: BoxDecoration(
                color: isUp
                    ? AppTheme.accentGreen.withValues(alpha: 0.08)
                    : AppTheme.errorRed.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${isUp ? '+' : ''}${(item['change'] as double).toStringAsFixed(2)}%',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isUp ? AppTheme.accentGreen : AppTheme.errorRed,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${(item['price'] as num).toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Vol ${item['vol']}',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppTheme.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getAssetColor(String symbol) {
    final colors = {
      'BTC': const Color(0xFFF7931A),
      'ETH': const Color(0xFF627EEA),
      'SOL': const Color(0xFF00FFA3),
      'BNB': const Color(0xFFF0B90B),
      'ADA': const Color(0xFF0033AD),
      'DOGE': const Color(0xFFC2A633),
      'DOT': const Color(0xFFE6007A),
      'EUR/USD': const Color(0xFF005B9F),
      'GBP/USD': const Color(0xFF005BBB),
      'USD/JPY': const Color(0xFFE31837),
      'AAPL': const Color(0xFFA2AAAD),
      'TSLA': const Color(0xFFE82127),
      'GOOGL': const Color(0xFF34A853),
      'XAU': const Color(0xFFFFD700),
      'XAG': const Color(0xFFC0C0C0),
      'OIL': const Color(0xFF1A1A1A),
      'SPX': const Color(0xFF005B9F),
    };
    return colors[symbol] ?? AppTheme.primaryPurple;
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Crypto':
        return const Color(0xFFF7931A);
      case 'Forex':
        return const Color(0xFF005B9F);
      case 'Saham':
        return const Color(0xFF34A853);
      case 'Gold':
        return const Color(0xFFFFD700);
      case 'Futures':
        return const Color(0xFFE82127);
      default:
        return AppTheme.primaryPurple;
    }
  }
}
