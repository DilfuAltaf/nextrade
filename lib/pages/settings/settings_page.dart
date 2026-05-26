import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextrade/app/routes/route_names.dart';
import 'package:nextrade/app/theme/app_theme.dart';
import 'package:nextrade/providers/auth_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(title: Text('Pengaturan', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Container(
            width: double.infinity, padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Tampilan', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              _buildSwitchTile(Icons.dark_mode, 'Mode Gelap', true),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.language, color: AppTheme.textSecondary, size: 22),
                title: Text('Bahasa', style: GoogleFonts.inter(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('Indonesia', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 20),
                ]),
                onTap: () {},
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity, padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Notifikasi', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              _buildSwitchTile(Icons.notifications_active, 'Push Notification', true),
              _buildSwitchTile(Icons.trending_up, 'Price Alert', true),
              _buildSwitchTile(Icons.campaign, 'Trading Signal', false),
              _buildSwitchTile(Icons.newspaper, 'Market News', true),
            ]),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity, padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Keamanan', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              _buildTile(Icons.shield_outlined, 'Verifikasi 2 Langkah', 'Nonaktif', () => Get.toNamed(RouteNames.security)),
              _buildTile(Icons.lock_outlined, 'Ganti Password', '', () {}),
            ]),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity, padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Data & Storage', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              _buildTile(Icons.cached, 'Hapus Cache', '12.5 MB', () {}),
              _buildTile(Icons.download_outlined, 'Ekspor Data', '', () {}),
            ]),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => auth.logout(),
              icon: const Icon(Icons.logout, color: AppTheme.errorRed),
              label: Text('Keluar', style: GoogleFonts.inter(color: AppTheme.errorRed, fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.errorRed)),
            ),
          ),
          const SizedBox(height: 16),
          Center(child: Text('NexTrade v1.0.0', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary))),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, bool value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppTheme.textSecondary, size: 22),
      title: Text(title, style: GoogleFonts.inter(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
      trailing: Switch(value: value, onChanged: (_) {}, activeColor: AppTheme.primaryPurple),
    );
  }

  Widget _buildTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppTheme.textSecondary, size: 22),
      title: Text(title, style: GoogleFonts.inter(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        if (subtitle.isNotEmpty) Text(subtitle, style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
        const SizedBox(width: 4),
        const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 20),
      ]),
      onTap: onTap,
    );
  }
}
