import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nextrade/app/theme/app_theme.dart';
import 'package:nextrade/providers/notification_controller.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        title: Text('Notifikasi', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        actions: [
          Obx(() {
            if (controller.unreadCount > 0) {
              return IconButton(onPressed: () => controller.markAllAsRead(), icon: const Icon(Icons.done_all));
            }
            return const SizedBox();
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.notifications.isEmpty) {
          return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.notifications_none, size: 64, color: AppTheme.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text('Tidak ada notifikasi', style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary)),
          ]));
        }
        return RefreshIndicator(
          onRefresh: () => controller.loadNotifications(),
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: controller.notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final notif = controller.notifications[index];
              return GestureDetector(
                onTap: notif.isRead ? null : () => controller.markAsRead(notif.id),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: !notif.isRead ? AppTheme.primaryPurple.withValues(alpha: 0.1) : AppTheme.darkCard,
                    borderRadius: BorderRadius.circular(12),
                    border: !notif.isRead ? Border.all(color: AppTheme.primaryPurple.withValues(alpha: 0.2)) : null,
                  ),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.primaryPurple.withValues(alpha: 0.2)),
                      child: Icon(_getIcon(notif.type), color: AppTheme.primaryPurple, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Expanded(child: Text(notif.title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))),
                        if (!notif.isRead) ...[
                          const SizedBox(width: 8),
                          Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.primaryPurple)),
                        ],
                      ]),
                      const SizedBox(height: 4),
                      Text(notif.description, style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
                      const SizedBox(height: 6),
                      Text(_formatTime(notif.createdAt), style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary.withValues(alpha: 0.7))),
                    ])),
                  ]),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'price_alert': return Icons.trending_up;
      case 'signal': return Icons.notifications_active;
      case 'ai': return Icons.auto_awesome;
      case 'news': return Icons.newspaper;
      case 'leaderboard': return Icons.emoji_events;
      default: return Icons.notifications_outlined;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return DateFormat('dd MMM yyyy').format(time);
  }
}
