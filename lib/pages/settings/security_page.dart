import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextrade/app/theme/app_theme.dart';
import 'package:nextrade/providers/auth_controller.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(title: Text('Keamanan', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
      body: Obx(() {
        final user = auth.user.value;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Verifikasi 2 Langkah (2FA)', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text('Tingkatkan keamanan akun kamu dengan mengaktifkan verifikasi 2 langkah.', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Aktifkan 2FA', style: GoogleFonts.inter(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                  Obx(() => Switch(
                    value: auth.user.value?.isTwoFactorEnabled ?? false,
                    onChanged: (v) {
                      if (user != null) {
                        auth.user.value = user.copyWith(isTwoFactorEnabled: v);
                      }
                    },
                    activeColor: AppTheme.primaryPurple,
                  )),
                ]),
              ]),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Verifikasi Email', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Email terverifikasi', style: GoogleFonts.inter(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                    Text(user?.email ?? '', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
                  ]),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppTheme.accentGreen.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                    child: Row(children: [
                      const Icon(Icons.check_circle, size: 14, color: AppTheme.accentGreen),
                      const SizedBox(width: 4),
                      Text('Terverifikasi', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.accentGreen, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ]),
              ]),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Anti-fraud', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Deteksi Aktivitas Mencurigakan', style: GoogleFonts.inter(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                  Switch(value: true, onChanged: (_) {}, activeColor: AppTheme.primaryPurple),
                ]),
              ]),
            ),
          ]),
        );
      }),
    );
  }
}
