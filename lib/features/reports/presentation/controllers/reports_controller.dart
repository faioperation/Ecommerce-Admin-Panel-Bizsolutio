import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';

class ReportsController extends GetxController {
  final ReportRepository _repository;

  ReportsController(this._repository);

  final RxList<ReportEntity> reports = <ReportEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  int _currentPage = 1;
  final int _limit = 15;
  String _statusFilter = 'All';
  String _targetTypeFilter = 'All';

  final RxInt totalCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTotalCount();
    fetchReports(isRefresh: true);
  }

  Future<void> _loadTotalCount() async {
    totalCount.value = await _repository.getTotalCount();
  }

  Future<void> fetchReports({bool isRefresh = false}) async {
    if (isLoading.value) return;

    try {
      if (isRefresh) {
        _currentPage = 1;
        reports.clear();
      }

      isLoading.value = true;
      error.value = '';

      final newReports = await _repository.getReports(
        page: _currentPage,
        limit: _limit,
        statusFilter: _statusFilter,
        targetTypeFilter: _targetTypeFilter,
      );

      if (isRefresh) {
        reports.value = newReports;
      } else {
        reports.addAll(newReports);
      }

      _currentPage++;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to load reports', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void onStatusChanged(String? status) {
    if (status == null) return;
    _statusFilter = status;
    fetchReports(isRefresh: true);
  }

  void onTargetTypeChanged(String? type) {
    if (type == null) return;
    _targetTypeFilter = type;
    fetchReports(isRefresh: true);
  }
}
