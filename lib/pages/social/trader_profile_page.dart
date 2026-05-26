import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextrade/app/theme/app_theme.dart';
import 'package:nextrade/providers/portfolio_controller.dart';

class TraderProfilePage extends StatelessWidget {
  const TraderProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final portfolio = Get.find<PortfolioController>();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(title: Text('Profil Trader', style: GoogleFonts.inter(fontWeight: FontWeight.w600)), actions: [
        IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
      ]),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            width: double.infinity, padding: const EdgeInsets.all(20),
            child: Column(children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [AppTheme.primaryPurple, AppTheme.accentGreen], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                child: Center(child: Text('TP', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white))),
              ),
              const SizedBox(height: 16),
              Text('TraderPro', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 4),
              Text('@traderpro', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
              const SizedBox(height: 16),
              SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.person_add), label: const Text('Ikuti'))),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                _buildStatColumn('1,234', 'Pengikut'),
                _buildStatColumn('567', 'Mengikuti'),
                _buildStatColumn('\$45.2K', 'Profit'),
                _buildStatColumn('89%', 'Win Rate'),
              ]),
            ]),
          ),
          Container(
            width: double.infinity, padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppTheme.darkCard),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Tentang', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
              const SizedBox(height: 8),
              Text(
                'Trader crypto profesional dengan pengalaman 3 tahun. Fokus pada analisis teknikal dan risk management.',
                style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 12),
              Row(children: [
                const Icon(Icons.verified, size: 16, color: AppTheme.accentGreen),
                const SizedBox(width: 6),
                Text('Verified Trader', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.accentGreen, fontWeight: FontWeight.w500)),
              ]),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Portofolio', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                TextButton(onPressed: () {}, child: Text('Salin Trading', style: GoogleFonts.inter(color: AppTheme.primaryPurple, fontSize: 13))),
              ]),
              const SizedBox(height: 12),
              Obx(() {
                if (portfolio.portfolioAssets.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(12)),
                    child: Center(child: Text('Belum ada data', style: GoogleFonts.inter(color: AppTheme.textSecondary))),
                  );
                }
                return Column(children: portfolio.portfolioAssets.map((a) {
                  final value = portfolio.getAssetValue(a);
                  final totalValue = portfolio.portfolioValue.value;
                  final percentage = totalValue > 0 ? (value / totalValue) * 100 : 0;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(12)),
                    child: Row(children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.primaryPurple.withValues(alpha: 0.2)),
                        child: Center(child: Text(a.symbol, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryPurple))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${a.name} (${a.symbol})', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                        Text('${a.amount} ${a.symbol}', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
                      ])),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text('${percentage.toStringAsFixed(1)}%', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.accentGreen)),
                        Text('portofolio', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary)),
                      ]),
                    ]),
                  );
                }).toList());
              }),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(children: [
      Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
    ]);
  }
}
