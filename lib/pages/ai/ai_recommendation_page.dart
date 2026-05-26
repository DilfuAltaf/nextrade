import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextrade/app/theme/app_theme.dart';
import 'package:nextrade/providers/ai_controller.dart';

class AiRecommendationPage extends StatelessWidget {
  const AiRecommendationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ai = Get.find<AiController>();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(title: Text('Rekomendasi Trading', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
      body: Obx(() {
        if (ai.isLoading.value) return const Center(child: CircularProgressIndicator());
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppTheme.primaryPurple.withValues(alpha: 0.3), AppTheme.accentGreen.withValues(alpha: 0.1)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryPurple.withValues(alpha: 0.3)),
              ),
              child: Column(children: [
                const Icon(Icons.tips_and_updates, color: AppTheme.primaryPurple, size: 40),
                const SizedBox(height: 8),
                Text('Rekomendasi Berbasis AI', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text('Rekomendasi diperbarui setiap 1 jam berdasarkan analisis data market real-time.', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary), textAlign: TextAlign.center),
              ]),
            ),
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Rekomendasi Aktif', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              Text('Update: 5 menit lalu', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary)),
            ]),
            const SizedBox(height: 12),
            ...ai.recommendations.map((r) {
              final color = r['type'] == 'Beli' ? AppTheme.accentGreen : r['type'] == 'Jual' ? AppTheme.errorRed : AppTheme.warningOrange;
              return Container(
                margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(12), border: Border(left: BorderSide(color: color, width: 4))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(r['title'] as String, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                      child: Text(r['potential'] as String, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Text(r['pair'] as String, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
                  const Divider(height: 20),
                  _buildDetailRow('Entry', r['entry'] as String),
                  const SizedBox(height: 6),
                  _buildDetailRow('Target 1', r['target1'] as String),
                  const SizedBox(height: 6),
                  _buildDetailRow('Target 2', r['target2'] as String),
                  const SizedBox(height: 6),
                  _buildDetailRow('Stop Loss', r['stopLoss'] as String),
                  const SizedBox(height: 12),
                  SizedBox(width: double.infinity, child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.symmetric(vertical: 10)),
                    child: Text(r['type'] == 'Beli' ? 'Beli Sekarang' : r['type'] == 'Jual' ? 'Jual Sekarang' : 'Lihat Detail'),
                  )),
                ]),
              );
            }),
          ]),
        );
      }),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
      Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white)),
    ]);
  }
}
