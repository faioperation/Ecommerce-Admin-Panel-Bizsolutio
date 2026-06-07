import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/seller_entity.dart';
import '../../domain/repositories/seller_repository.dart';

class SellersController extends GetxController {
  final SellerRepository _repository;

  SellersController(this._repository);

  final RxList<SellerEntity> sellers = <SellerEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Pagination & Search
  int _currentPage = 1;
  final int _limit = 15;
  String _searchQuery = '';
  
  int totalCount = 50; // Mock total count

  @override
  void onInit() {
    super.onInit();
    fetchSellers(isRefresh: true);
  }

  Future<void> fetchSellers({bool isRefresh = false}) async {
    if (isLoading.value) return;

    try {
      if (isRefresh) {
        _currentPage = 1;
        sellers.clear();
      }

      isLoading.value = true;
      error.value = '';

      final newSellers = await _repository.getSellers(
        page: _currentPage,
        limit: _limit,
        searchQuery: _searchQuery,
      );

      if (isRefresh) {
        sellers.value = newSellers;
      } else {
        sellers.addAll(newSellers);
      }
      
      _currentPage++;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to load sellers', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void onSearch(String query) {
    _searchQuery = query;
    fetchSellers(isRefresh: true);
  }
}
