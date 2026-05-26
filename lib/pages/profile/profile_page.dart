import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextrade/app/routes/route_names.dart';
import 'package:nextrade/app/theme/app_theme.dart';
import 'package:nextrade/providers/auth_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(title: Text('Profil Saya', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)), actions: [
        IconButton(onPressed: () => Get.toNamed(RouteNames.settings), icon: const Icon(Icons.settings_outlined)),
      ]),
      body: Obx(() {
        final user = auth.user.value;
        if (user == null) return const SizedBox();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Container(
              width: double.infinity, padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppTheme.primaryPurple, Color(0xFF4C1D95)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
                  child: user.photoUrl != null
                      ? ClipOval(child: Image.network(user.photoUrl!, fit: BoxFit.cover))
                      : const Center(child: Icon(Icons.person, size: 44, color: Colors.white)),
                ),
                const SizedBox(height: 16),
                Text(user.fullName, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text(user.email, style: GoogleFonts.inter(fontSize: 14, color: Colors.white70)),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  _buildProfileStat('Bergabung', _formatDate(user.createdAt)),
                  _buildProfileStat('Trading', '${user.totalTrades}'),
                  _buildProfileStat('Win Rate', '${user.winRate.toStringAsFixed(0)}%'),
                ]),
              ]),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Akun Saya', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 16),
                _buildMenuItem(Icons.person_outlined, 'Edit Profil', () {}),
                const Divider(height: 1),
                _buildMenuItem(Icons.verified_outlined, 'Verifikasi Identitas', () {}),
                const Divider(height: 1),
                _buildMenuItem(Icons.shield_outlined, 'Keamanan', () => Get.toNamed(RouteNames.security)),
                const Divider(height: 1),
                _buildMenuItem(Icons.notifications_outlined, 'Notifikasi', () => Get.toNamed(RouteNames.notifications)),
              ]),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Lainnya', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 16),
                _buildMenuItem(Icons.star_outlined, 'Ikuti Kami', () {}),
                const Divider(height: 1),
                _buildMenuItem(Icons.info_outlined, 'Tentang Aplikasi', () {}),
                const Divider(height: 1),
                _buildMenuItem(Icons.description_outlined, 'Syarat & Ketentuan', () {}),
                const Divider(height: 1),
                _buildMenuItem(Icons.logout, 'Keluar', () => auth.logout(), color: AppTheme.errorRed),
              ]),
            ),
          ]),
        );
      }),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(children: [
      Text(value, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
    ]);
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color ?? AppTheme.textSecondary, size: 22),
      title: Text(title, style: GoogleFonts.inter(fontSize: 14, color: color ?? Colors.white, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 20),
      onTap: onTap,
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${months[date.month - 1]} ${date.year}';
  }
}
