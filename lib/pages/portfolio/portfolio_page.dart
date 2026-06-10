import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nextrade/app/routes/route_names.dart';
import 'package:nextrade/app/theme/app_theme.dart';
import 'package:nextrade/providers/auth_controller.dart';
import 'package:nextrade/providers/portfolio_controller.dart';
import 'package:nextrade/providers/market_controller.dart';
import 'package:nextrade/models/portfolio_model.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final portfolio = Get.find<PortfolioController>();
    final marketController = Get.find<MarketController>();
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(title: Text('Portofolio', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
      body: Obx(() {
        if (portfolio.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity, padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppTheme.primaryPurple, Color(0xFF4C1D95)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Total Portofolio', style: GoogleFonts.inter(fontSize: 13, color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text('\$${portfolio.portfolioValue.value.toStringAsFixed(2)}', style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: (portfolio.totalProfit.value >= 0 ? AppTheme.accentGreen : AppTheme.errorRed).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                      child: Text('${portfolio.totalProfit.value >= 0 ? '+' : ''}${portfolio.totalProfit.value.toStringAsFixed(2)}', style: GoogleFonts.inter(fontSize: 13, color: portfolio.totalProfit.value >= 0 ? AppTheme.accentGreen : AppTheme.errorRed, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 12),
                    Text('Saldo: \$${(auth.user.value?.virtualBalance ?? 0).toStringAsFixed(2)}', style: GoogleFonts.inter(fontSize: 13, color: Colors.white70)),
                  ]),
                ]),
              ),
              const SizedBox(height: 24),
              if (portfolio.portfolioAssets.isNotEmpty && portfolio.portfolioValue.value > 0)
                Container(
                  width: double.infinity,
                  height: 200,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                            sections: portfolio.portfolioAssets.asMap().entries.map((entry) {
                              final index = entry.key;
                              final asset = entry.value;
                              final percentage = portfolio.getAssetPercentage(asset);
                              final color = _getAssetColor(index);
                              return PieChartSectionData(
                                color: color,
                                value: percentage,
                                title: percentage > 5 ? '${percentage.toStringAsFixed(1)}%' : '',
                                radius: 25,
                                titleStyle: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: portfolio.portfolioAssets.take(5).toList().asMap().entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: _getAssetColor(entry.key),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  entry.value.symbol,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                )
              else
                Container(
                  width: double.infinity, height: 120, padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(16)),
                  child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.pie_chart_outline, size: 40, color: AppTheme.primaryPurple.withValues(alpha: 0.5)),
                    const SizedBox(height: 8),
                    Text('Belum ada distribusi aset', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
                  ])),
                ),
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Aset Saya', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Total: ${portfolio.portfolioAssets.length} Aset', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
              ]),
              const SizedBox(height: 12),
              if (portfolio.portfolioAssets.isEmpty)
                Container(
                  width: double.infinity, padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Column(children: [
                    Icon(Icons.account_balance_wallet_outlined, size: 48, color: AppTheme.textSecondary.withValues(alpha: 0.5)),
                    const SizedBox(height: 12),
                    Text('Belum ada aset', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
                    const SizedBox(height: 4),
                    Text('Mulai trading untuk memiliki aset', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary.withValues(alpha: 0.7))),
                  ])),
                )
              else
                ...portfolio.portfolioAssets.map((asset) {
                  final market = marketController.getMarketBySymbol(asset.symbol);
                  final price = market?.price ?? 0;
                  final change = market?.change ?? 0;
                  final profit = portfolio.getAssetProfit(asset);
                  final profitPercent = portfolio.getAssetProfitPercent(asset);
                  final percentage = portfolio.getAssetPercentage(asset);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () {
                        if (market != null) {
                          Get.toNamed(RouteNames.chart, arguments: {
                            'id': market.id,
                            'name': market.name,
                            'symbol': market.symbol,
                            'price': market.price,
                            'change': market.change,
                          });
                        }
                      },
                      child: _buildAssetItem(asset, price, change, profit, profitPercent, percentage),
                    ),
                  );
                }),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAssetItem(PortfolioModel asset, double price, double change, double profit, double profitPercent, double percentage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.primaryPurple.withValues(alpha: 0.2)),
            child: Center(child: Text(asset.symbol, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryPurple))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(asset.name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            Text('${asset.amount} ${asset.symbol}', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('\$${(asset.amount * price).toStringAsFixed(2)}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            Text('${profitPercent >= 0 ? '+' : ''}${profitPercent.toStringAsFixed(2)}%', style: GoogleFonts.inter(fontSize: 12, color: profitPercent >= 0 ? AppTheme.accentGreen : AppTheme.errorRed, fontWeight: FontWeight.w600)),
          ]),
        ]),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: percentage / 100, backgroundColor: AppTheme.glassBg, valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple), minHeight: 4),
        ),
        const SizedBox(height: 4),
        Align(alignment: Alignment.centerRight, child: Text('${percentage.toStringAsFixed(1)}% dari portofolio', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary))),
      ]),
    );
  }

  Color _getAssetColor(int index) {
    final colors = [
      AppTheme.primaryPurple,
      AppTheme.accentGreen,
      Colors.blue,
      Colors.orange,
      AppTheme.errorRed,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];
    return colors[index % colors.length];
  }
}
