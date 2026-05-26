import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextrade/app/theme/app_theme.dart';
import 'package:nextrade/providers/ai_controller.dart';

class AiCandleAnalysisPage extends StatelessWidget {
  const AiCandleAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ai = Get.find<AiController>();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(title: Text('Analisis Candle', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
      body: Obx(() {
        if (ai.isLoading.value) return const Center(child: CircularProgressIndicator());
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.auto_awesome, color: AppTheme.primaryPurple, size: 20),
                  const SizedBox(width: 8),
                  Text('Analisis Candle Otomatis', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                ]),
                const SizedBox(height: 12),
                Text('Pilih timeframe dan pair untuk melihat analisis pola candle oleh AI.', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
              ]),
            ),
            const SizedBox(height: 20),
            Text('Pilih Pair', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(height: 8),
            Row(children: [
              _buildPairChip('BTC/USDT', true), const SizedBox(width: 8),
              _buildPairChip('ETH/USDT', false), const SizedBox(width: 8),
              _buildPairChip('SOL/USDT', false),
            ]),
            const SizedBox(height: 20),
            Text('Timeframe', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(height: 8),
            Row(children: [
              _buildTimeChip('15m', false), const SizedBox(width: 8),
              _buildTimeChip('1H', true), const SizedBox(width: 8),
              _buildTimeChip('4H', false), const SizedBox(width: 8),
              _buildTimeChip('1D', false), const SizedBox(width: 8),
              _buildTimeChip('1W', false),
            ]),
            const SizedBox(height: 20),
            Container(
              width: double.infinity, height: 220,
              decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(16)),
              child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.show_chart, size: 56, color: AppTheme.primaryPurple.withValues(alpha: 0.4)),
                const SizedBox(height: 8),
                Text('Candlestick Chart', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
                Text('(Chart akan ditampilkan di sini)', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary.withValues(alpha: 0.7))),
              ])),
            ),
            const SizedBox(height: 20),
            Text('Hasil Analisis AI', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            ...ai.candlePatterns.map((p) => _buildPatternCard(
              p['pattern'] as String,
              p['description'] as String,
              p['type'] == 'bullish' ? AppTheme.accentGreen : AppTheme.warningOrange,
            )),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => ai.generateRecommendations(), icon: const Icon(Icons.refresh), label: const Text('Analisis Ulang'))),
          ]),
        );
      }),
    );
  }

  Widget _buildPairChip(String label, bool isSelected) {
    return Expanded(child: ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 12)), selected: isSelected, onSelected: (_) {},
      selectedColor: AppTheme.primaryPurple.withValues(alpha: 0.3), backgroundColor: AppTheme.glassBg,
      labelStyle: TextStyle(color: isSelected ? AppTheme.primaryPurple : AppTheme.textSecondary),
    ));
  }

  Widget _buildTimeChip(String label, bool isSelected) {
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 12)), selected: isSelected, onSelected: (_) {},
      selectedColor: AppTheme.primaryPurple.withValues(alpha: 0.3), backgroundColor: AppTheme.glassBg,
      labelStyle: TextStyle(color: isSelected ? AppTheme.primaryPurple : AppTheme.textSecondary),
    );
  }

  Widget _buildPatternCard(String title, String description, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: 0.2)),
          child: Icon(Icons.trending_up, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 4),
          Text(description, style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary, height: 1.4)),
        ])),
      ]),
    );
  }
}
