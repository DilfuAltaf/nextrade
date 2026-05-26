import 'package:get/get.dart';
import 'package:nextrade/models/community_post_model.dart';
import 'package:nextrade/models/leaderboard_model.dart';
import 'package:nextrade/providers/auth_controller.dart';
import 'package:nextrade/services/firestore_service.dart';

class SocialController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthController _authController = Get.find();

  final leaderboard = <LeaderboardModel>[].obs;
  final communityPosts = <CommunityPostModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        loadLeaderboard(),
        loadCommunityPosts(),
      ]);
    } catch (e) {
      // silent fail
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadLeaderboard() async {
    try {
      final data = await _firestoreService.getLeaderboard();
      leaderboard.value = data;
    } catch (e) {
      // silent fail
    }
  }

  Future<void> loadCommunityPosts() async {
    try {
      final data = await _firestoreService.getCommunityPosts();
      communityPosts.value = data;
    } catch (e) {
      // silent fail
    }
  }

  Future<void> addPost(String content) async {
    final userId = _authController.user.value?.uid;
    final username = _authController.user.value?.fullName ?? 'User';
    if (userId == null) return;

    final post = CommunityPostModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      username: username,
      content: content,
      createdAt: DateTime.now(),
    );
    await _firestoreService.addCommunityPost(post);
    communityPosts.insert(0, post);
  }

  Future<void> likePost(String postId) async {
    final userId = _authController.user.value?.uid;
    if (userId == null) return;
    await _firestoreService.likePost(postId, userId);
    await loadCommunityPosts();
  }
}
