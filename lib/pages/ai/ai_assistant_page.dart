import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextrade/app/routes/route_names.dart';
import 'package:nextrade/app/theme/app_theme.dart';
import 'package:nextrade/providers/ai_controller.dart';

class AiAssistantPage extends StatelessWidget {
  const AiAssistantPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ai = Get.find<AiController>();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(title: Text('AI Assistant', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)), actions: [
        IconButton(icon: const Icon(Icons.history), onPressed: () {}),
      ]),
      body: Obx(() {
        if (ai.isLoading.value) return const Center(child: CircularProgressIndicator());
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppTheme.primaryPurple.withValues(alpha: 0.3), AppTheme.accentGreen.withValues(alpha: 0.1)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryPurple.withValues(alpha: 0.3)),
              ),
              child: Column(children: [
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [AppTheme.primaryPurple, AppTheme.accentGreen])),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 12),
                Text('AI Trading Assistant', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text('Saya siap membantu analisa trading kamu!', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary), textAlign: TextAlign.center),
              ]),
            ),
            const SizedBox(height: 24),
            Text('Fitur AI', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            _buildAiFeature(Icons.chat, 'AI Chatbot Mentor', 'Tanya apa pun tentang trading', () => Get.toNamed(RouteNames.aiChatbot)),
            const SizedBox(height: 8),
            _buildAiFeature(Icons.analytics, 'Analisis Market', 'Prediksi dan analisis market AI', () => Get.toNamed(RouteNames.aiAnalysis)),
            const SizedBox(height: 8),
            _buildAiFeature(Icons.show_chart, 'Analisis Candle', 'AI membaca pola candle chart', () => Get.toNamed(RouteNames.aiCandleAnalysis)),
            const SizedBox(height: 8),
            _buildAiFeature(Icons.tips_and_updates, 'Rekomendasi Trading', 'Saran trading berdasarkan data', () => Get.toNamed(RouteNames.aiRecommendation)),
            const SizedBox(height: 24),
            Text('Rekomendasi Hari Ini', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            ...ai.recommendations.take(2).toList().map((r) {
              final color = r['type'] == 'Beli' ? AppTheme.accentGreen : r['type'] == 'Jual' ? AppTheme.errorRed : AppTheme.warningOrange;
              return Container(
                margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.3))),
                child: Row(children: [
                  Container(width: 4, height: 48, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(r['title'] as String, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    Text('${r['type']} ${(r['asset'] as dynamic).symbol} di harga ${r['entry']}', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
                  ])),
                ]),
              );
            }),
          ]),
        );
      }),
    );
  }

  Widget _buildAiFeature(IconData icon, String title, String description, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.primaryPurple.withValues(alpha: 0.2)),
            child: Icon(icon, color: AppTheme.primaryPurple, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            Text(description, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
          ])),
          const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
        ]),
      ),
    );
  }
}
