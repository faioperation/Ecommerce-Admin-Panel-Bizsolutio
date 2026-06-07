import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationsController extends GetxController {
  final NotificationRepository _repository;

  NotificationsController(this._repository);

  final RxList<NotificationEntity> notifications = <NotificationEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  int _currentPage = 1;
  final int _limit = 15;
  final RxInt totalCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTotalCount();
    fetchNotifications(isRefresh: true);
  }

  Future<void> _loadTotalCount() async {
    totalCount.value = await _repository.getTotalCount();
  }

  Future<void> fetchNotifications({bool isRefresh = false}) async {
    if (isLoading.value) return;

    try {
      if (isRefresh) {
        _currentPage = 1;
        notifications.clear();
      }

      isLoading.value = true;
      error.value = '';

      final newNotifications = await _repository.getNotifications(
        page: _currentPage,
        limit: _limit,
      );

      if (isRefresh) {
        notifications.value = newNotifications;
      } else {
        notifications.addAll(newNotifications);
      }

      _currentPage++;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await _repository.deleteNotification(id);
      notifications.removeWhere((n) => n.id == id);
      totalCount.value--;
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> sendNotificationNow(String id) async {
    try {
      await _repository.sendNotification(id);
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isSent: true);
      }
    } catch (e) {
      error.value = e.toString();
    }
  }
}
