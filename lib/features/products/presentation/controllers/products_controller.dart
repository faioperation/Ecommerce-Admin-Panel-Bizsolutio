import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';

class ProductsController extends GetxController {
  final ProductRepository _repository;

  ProductsController(this._repository);

  final RxList<ProductEntity> products = <ProductEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Pagination & Filters
  int _currentPage = 1;
  final int _limit = 15;
  String _searchQuery = '';
  String _categoryFilter = 'All';
  String _statusFilter = 'All';

  final RxInt totalCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTotalCount();
    fetchProducts(isRefresh: true);
  }

  Future<void> _loadTotalCount() async {
    totalCount.value = await _repository.getTotalCount();
  }

  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (isLoading.value) return;

    try {
      if (isRefresh) {
        _currentPage = 1;
        products.clear();
      }

      isLoading.value = true;
      error.value = '';

      final newProducts = await _repository.getProducts(
        page: _currentPage,
        limit: _limit,
        searchQuery: _searchQuery,
        categoryFilter: _categoryFilter,
        statusFilter: _statusFilter,
      );

      if (isRefresh) {
        products.value = newProducts;
      } else {
        products.addAll(newProducts);
      }

      _currentPage++;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to load products',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void onSearch(String query) {
    _searchQuery = query;
    fetchProducts(isRefresh: true);
  }

  void onCategoryChanged(String? category) {
    if (category == null) return;
    _categoryFilter = category;
    fetchProducts(isRefresh: true);
  }

  void onStatusChanged(String? status) {
    if (status == null) return;
    _statusFilter = status;
    fetchProducts(isRefresh: true);
  }

  // Bulk Actions
  Future<void> bulkApprove(List<ProductEntity> selectedProducts) async {
    try {
      final ids = selectedProducts.map((p) => p.id).toList();
      await _repository.bulkApprove(ids);
      fetchProducts(isRefresh: true);
      Get.snackbar('Success', '\${ids.length} products approved',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to approve products',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> bulkDisable(List<ProductEntity> selectedProducts) async {
    try {
      final ids = selectedProducts.map((p) => p.id).toList();
      await _repository.bulkDisable(ids);
      fetchProducts(isRefresh: true);
      Get.snackbar('Success', '\${ids.length} products disabled',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to disable products',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
