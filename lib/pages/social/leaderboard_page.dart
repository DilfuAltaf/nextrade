import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextrade/app/routes/route_names.dart';
import 'package:nextrade/app/theme/app_theme.dart';
import 'package:nextrade/providers/social_controller.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final social = Get.find<SocialController>();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(title: Text('Leaderboard', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)), actions: [
        IconButton(icon: const Icon(Icons.info_outline), onPressed: () {}),
      ]),
      body: Obx(() {
        if (social.isLoading.value) return const Center(child: CircularProgressIndicator());
        return Column(children: [
          Container(
            margin: const EdgeInsets.all(20), padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppTheme.warningOrange, AppTheme.primaryPurple], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(children: [
              const Icon(Icons.emoji_events, color: Colors.white, size: 48),
              const SizedBox(height: 8),
              Text('Peringkat Trader', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 4),
              Text('Kompetisi trading virtual setiap bulan!', style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
            ]),
          ),
          Expanded(
            child: social.leaderboard.isEmpty
                ? Center(child: Text('Belum ada data', style: GoogleFonts.inter(color: AppTheme.textSecondary)))
                : RefreshIndicator(
                    onRefresh: () => social.loadLeaderboard(),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: social.leaderboard.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = social.leaderboard[index];
                        return GestureDetector(
                          onTap: () => Get.toNamed(RouteNames.traderProfile),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(12)),
                            child: Row(children: [
                              SizedBox(
                                width: 32,
                                child: index < 3
                                    ? Icon(Icons.emoji_events, color: index == 0 ? const Color(0xFFFFD700) : index == 1 ? const Color(0xFFC0C0C0) : const Color(0xFFCD7F32), size: 20)
                                    : Text('${index + 1}', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.primaryPurple.withValues(alpha: 0.2)),
                                child: Center(child: Text(item.username.substring(0, 2).toUpperCase(), style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryPurple))),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(item.username, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                                Text('${item.followers} pengikut', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary)),
                              ])),
                              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                Text('\$${item.profit.toStringAsFixed(0)}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.accentGreen)),
                                Text('profit', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary)),
                              ]),
                            ]),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ]);
      }),
    );
  }
}
