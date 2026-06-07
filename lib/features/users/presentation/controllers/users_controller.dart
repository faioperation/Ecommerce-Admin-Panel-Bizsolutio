import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';

class UsersController extends GetxController {
  final UserRepository _repository;

  UsersController(this._repository);

  final RxList<UserEntity> users = <UserEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Pagination & Search
  int _currentPage = 1;
  final int _limit = 15;
  String _searchQuery = '';
  
  // To handle the data grid source updates
  int totalCount = 50; // Mock total count

  @override
  void onInit() {
    super.onInit();
    fetchUsers(isRefresh: true);
  }

  Future<void> fetchUsers({bool isRefresh = false}) async {
    if (isLoading.value) return;

    try {
      if (isRefresh) {
        _currentPage = 1;
        users.clear();
      }

      isLoading.value = true;
      error.value = '';

      final newUsers = await _repository.getUsers(
        page: _currentPage,
        limit: _limit,
        searchQuery: _searchQuery,
      );

      if (isRefresh) {
        users.value = newUsers;
      } else {
        users.addAll(newUsers);
      }
      
      _currentPage++;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to load users', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void onSearch(String query) {
    _searchQuery = query;
    fetchUsers(isRefresh: true);
  }
  
  Future<void> handlePageChange(int newPage) async {
    _currentPage = newPage;
    // When using data pager, we clear and fetch for the specific page
    try {
      isLoading.value = true;
      final pageUsers = await _repository.getUsers(
        page: _currentPage,
        limit: _limit,
        searchQuery: _searchQuery,
      );
      users.value = pageUsers;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load page', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
