import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextrade/app/theme/app_theme.dart';
import 'package:nextrade/providers/ai_controller.dart';

class AiAnalysisPage extends StatelessWidget {
  const AiAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ai = Get.find<AiController>();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(title: Text('AI Market Analysis', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
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
                  Text('Analisis Market Saat Ini', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                ]),
                const SizedBox(height: 16),
                _buildAnalysisRow('Sentimen Pasar', ai.marketSentiment.value, ai.marketSentiment.value == 'Bullish' ? AppTheme.accentGreen : AppTheme.warningOrange),
                const SizedBox(height: 12),
                _buildAnalysisRow('Volatilitas', 'Tinggi', AppTheme.warningOrange),
                const SizedBox(height: 12),
                _buildAnalysisRow('Tren', 'Menaik', AppTheme.accentGreen),
                const SizedBox(height: 12),
                _buildAnalysisRow('Rekomendasi', 'Hold', AppTheme.primaryPurple),
              ]),
            ),
            const SizedBox(height: 24),
            Text('Prediksi Harga (24 Jam)', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity, height: 200, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(16)),
              child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.trending_up, size: 48, color: AppTheme.accentGreen.withValues(alpha: 0.5)),
                const SizedBox(height: 8),
                Text('Grafik Prediksi AI', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
                Text('(Data prediksi akan ditampilkan di sini)', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary.withValues(alpha: 0.7))),
              ])),
            ),
            const SizedBox(height: 24),
            Text('Analisis Detail', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            _buildAnalysisCard('Analisis Teknikal', ai.marketAnalysis),
            const SizedBox(height: 8),
            _buildAnalysisCard('Analisis Fundamental', ai.fundamentalAnalysis),
            const SizedBox(height: 8),
            _buildAnalysisCard('Analisis Sentimen', ai.sentimentAnalysis),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => ai.generateRecommendations(), icon: const Icon(Icons.refresh), label: const Text('Perbarui Analisis'))),
          ]),
        );
      }),
    );
  }

  Widget _buildAnalysisRow(String label, String value, Color color) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
        child: Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
      ),
    ]);
  }

  Widget _buildAnalysisCard(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.circle, size: 8, color: AppTheme.primaryPurple),
          const SizedBox(width: 8),
          Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
        ]),
        const SizedBox(height: 8),
        Text(description, style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary, height: 1.5)),
      ]),
    );
  }
}
