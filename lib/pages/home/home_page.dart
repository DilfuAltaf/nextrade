import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextrade/app/routes/route_names.dart';
import 'package:nextrade/app/theme/app_theme.dart';
import 'package:nextrade/providers/auth_controller.dart';
import 'package:nextrade/providers/market_controller.dart';
import 'package:nextrade/providers/portfolio_controller.dart';
import 'package:nextrade/providers/notification_controller.dart';
import 'package:nextrade/models/market_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final marketController = Get.find<MarketController>();
    final portfolio = Get.find<PortfolioController>();
    final notif = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Halo, ${auth.user.value?.fullName.split(' ').first ?? 'Trader'}!', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
                      Text('Selamat Datang', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() => Stack(
                        children: [
                          IconButton(onPressed: () => Get.toNamed(RouteNames.notifications), icon: const Icon(Icons.notifications_outlined, color: Colors.white)),
                          if (notif.unreadCount > 0)
                            Positioned(
                              right: 8, top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.errorRed),
                                child: Text('${notif.unreadCount}', style: const TextStyle(fontSize: 8, color: Colors.white)),
                              ),
                            ),
                        ],
                      )),
                      GestureDetector(
                        onTap: () => Get.toNamed(RouteNames.profile),
                        child: Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppTheme.primaryPurple, width: 2)),
                          child: auth.user.value?.photoUrl != null
                              ? ClipOval(child: Image.network(auth.user.value!.photoUrl!, fit: BoxFit.cover))
                              : const Icon(Icons.person, color: AppTheme.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
              const SizedBox(height: 24),
              Obx(() => Container(
                width: double.infinity, padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppTheme.primaryPurple, Color(0xFF4C1D95)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: AppTheme.primaryPurple.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Saldo Virtual', style: GoogleFonts.inter(fontSize: 13, color: Colors.white70)),
                    const SizedBox(height: 8),
                    Text('\$${(auth.user.value?.virtualBalance ?? 10000).toStringAsFixed(2)}', style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildStatItem('Profit Hari Ini', '${portfolio.totalProfit.value >= 0 ? '+' : ''}\$${portfolio.totalProfit.value.toStringAsFixed(2)}', portfolio.totalProfit.value >= 0 ? AppTheme.accentGreen : AppTheme.errorRed),
                        const SizedBox(width: 24),
                        _buildStatItem('Total Trading', '${auth.user.value?.totalTrades ?? 0}', Colors.white),
                      ],
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Market', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  TextButton(onPressed: () => Get.toNamed(RouteNames.market), child: Text('Lihat Semua', style: GoogleFonts.inter(color: AppTheme.primaryPurple, fontSize: 13))),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() => Column(
                children: marketController.markets.take(4).toList().map((m) => _buildMarketItem(m)).toList(),
              )),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Portofolio', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  TextButton(onPressed: () => Get.toNamed(RouteNames.portfolio), child: Text('Lihat Semua', style: GoogleFonts.inter(color: AppTheme.primaryPurple, fontSize: 13))),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (portfolio.portfolioAssets.isEmpty) {
                  return Container(
                    width: double.infinity, padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(16)),
                    child: Center(child: Text('Belum ada aset', style: GoogleFonts.inter(color: AppTheme.textSecondary))),
                  );
                }
                return Container(
                  width: double.infinity, padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: portfolio.portfolioAssets.map((a) {
                      final market = marketController.getMarketBySymbol(a.symbol);
                      final price = market?.price ?? 0;
                      final change = market?.change ?? 0;
                      return Column(
                        children: [
                          _buildPortfolioItem(a.name, a.symbol, a.amount, price, a.amount * price, change),
                          if (a != portfolio.portfolioAssets.last) const Divider(),
                        ],
                      );
                    }).toList(),
                  ),
                );
              }),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('AI Rekomendasi', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  TextButton(onPressed: () => Get.toNamed(RouteNames.aiAssistant), child: Text('Lihat Semua', style: GoogleFonts.inter(color: AppTheme.primaryPurple, fontSize: 13))),
                ],
              ),
              _buildAiRecommendation(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
      const SizedBox(height: 4),
      Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
    ]);
  }

  Widget _buildMarketItem(MarketModel m) {
    return GestureDetector(
      onTap: () => Get.toNamed(RouteNames.chart, arguments: m.toMap()),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.primaryPurple.withValues(alpha: 0.2)),
              child: Center(child: Text(m.symbol.length > 3 ? m.symbol.substring(0, 2) : m.symbol, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryPurple))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(m.name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
              Text(m.symbol, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('\$${m.price.toStringAsFixed(2)}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: (m.isUp ? AppTheme.accentGreen : AppTheme.errorRed).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                child: Text('${m.isUp ? '+' : ''}${m.change}%', style: GoogleFonts.inter(fontSize: 12, color: m.isUp ? AppTheme.accentGreen : AppTheme.errorRed, fontWeight: FontWeight.w600)),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioItem(String name, String symbol, double amount, double price, double value, double change) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('$name ($symbol)', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            Text('$amount $symbol', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('\$${value.toStringAsFixed(2)}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            Text('${change >= 0 ? '+' : ''}$change%', style: GoogleFonts.inter(fontSize: 12, color: change >= 0 ? AppTheme.accentGreen : AppTheme.errorRed, fontWeight: FontWeight.w600)),
          ]),
        ],
      ),
    );
  }

  Widget _buildAiRecommendation() {
    return Container(
      margin: const EdgeInsets.only(top: 12), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.primaryPurple.withValues(alpha: 0.15), AppTheme.accentGreen.withValues(alpha: 0.15)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryPurple.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.primaryPurple.withValues(alpha: 0.3)),
            child: const Icon(Icons.auto_awesome, color: AppTheme.primaryPurple, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('AI merekomendasikan', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
            const SizedBox(height: 2),
            Text('Beli BTC di harga \$65,000', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
          ])),
          const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
        ],
      ),
    );
  }
}
