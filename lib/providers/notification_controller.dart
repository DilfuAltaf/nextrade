import 'package:get/get.dart';
import 'package:nextrade/models/notification_model.dart';
import 'package:nextrade/providers/auth_controller.dart';
import 'package:nextrade/services/firestore_service.dart';

class NotificationController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthController _authController = Get.find();

  final notifications = <NotificationItemModel>[].obs;
  final unreadCount = 0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;
      final userId = _authController.user.value?.uid;
      if (userId == null) return;
      final data = await _firestoreService.getNotifications(userId);
      notifications.value = data;
      unreadCount.value = data.where((n) => !n.isRead).length;
    } catch (e) {
      // silent fail
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String id) async {
    await _firestoreService.markNotificationRead(id);
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      unreadCount.value = notifications.where((n) => !n.isRead).length;
    }
  }

  Future<void> markAllAsRead() async {
    final userId = _authController.user.value?.uid;
    if (userId == null) return;
    await _firestoreService.markAllNotificationsRead(userId);
    for (var i = 0; i < notifications.length; i++) {
      notifications[i] = notifications[i].copyWith(isRead: true);
    }
    unreadCount.value = 0;
  }

  Future<void> addNotification(NotificationItemModel notification) async {
    await _firestoreService.addNotification(notification);
    notifications.insert(0, notification);
    unreadCount.value++;
  }
}
