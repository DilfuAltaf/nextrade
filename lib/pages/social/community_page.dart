import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nextrade/app/routes/route_names.dart';
import 'package:nextrade/app/theme/app_theme.dart';
import 'package:nextrade/providers/social_controller.dart';
import 'package:nextrade/providers/auth_controller.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final social = Get.find<SocialController>();
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        title: Text('Community', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => _showCreatePostDialog(context))],
      ),
      body: Obx(() {
        if (social.isLoading.value) return const Center(child: CircularProgressIndicator());
        return RefreshIndicator(
          onRefresh: () => social.loadCommunityPosts(),
          child: social.communityPosts.isEmpty
              ? Center(child: Text('Belum ada diskusi', style: GoogleFonts.inter(color: AppTheme.textSecondary)))
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: social.communityPosts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final post = social.communityPosts[index];
                    final isLiked = post.likedBy.contains(auth.user.value?.uid ?? '');

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(12)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          GestureDetector(
                            onTap: () => Get.toNamed(RouteNames.traderProfile),
                            child: Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.primaryPurple.withValues(alpha: 0.2)),
                              child: Center(child: Text(post.username.substring(0, 2).toUpperCase(), style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryPurple))),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(post.username, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                            Text(_formatTime(post.createdAt), style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary)),
                          ])),
                          const Icon(Icons.more_horiz, color: AppTheme.textSecondary, size: 20),
                        ]),
                        const SizedBox(height: 12),
                        Text(post.content, style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary, height: 1.4)),
                        const SizedBox(height: 12),
                        Row(children: [
                          GestureDetector(
                            onTap: () => social.likePost(post.id),
                            child: Row(children: [
                              Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: isLiked ? AppTheme.errorRed : AppTheme.textSecondary, size: 18),
                              const SizedBox(width: 4),
                              Text('${post.likes}', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
                            ]),
                          ),
                          const SizedBox(width: 16),
                          Row(children: [
                            const Icon(Icons.chat_bubble_outline, color: AppTheme.textSecondary, size: 18),
                            const SizedBox(width: 4),
                            Text('${post.comments}', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
                          ]),
                          const Spacer(),
                          const Icon(Icons.bookmark_border, color: AppTheme.textSecondary, size: 18),
                        ]),
                      ]),
                    );
                  },
                ),
        );
      }),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    final contentController = TextEditingController();
    Get.dialog(Dialog(
      backgroundColor: AppTheme.darkCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Buat Diskusi', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          TextField(
            controller: contentController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(hintText: 'Tulis diskusi...', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (contentController.text.isNotEmpty) {
                  Get.find<SocialController>().addPost(contentController.text);
                  Get.back();
                }
              },
              child: const Text('Bagikan'),
            ),
          ),
        ]),
      ),
    ));
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 2) return 'Kemarin';
    return DateFormat('dd MMM yyyy').format(time);
  }
}
