import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/layout/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_button.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/stat_card.dart';
import '../widgets/revenue_chart.dart';
import '../widgets/user_growth_chart.dart';
import '../widgets/activity_feed.dart';
import '../widgets/quick_actions.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final isMobile = ResponsiveBuilder.isMobile(context);
    final isTablet = ResponsiveBuilder.isTablet(context);

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: AppLoader());
      }

      if (controller.error.value.isNotEmpty) {
        return AppEmptyState(
          icon: Icons.error_outline,
          title: 'Failed to load dashboard',
          message: controller.error.value,
          action: AppButton(
            label: 'Retry',
            icon: Icons.refresh,
            type: AppButtonType.outline,
            onPressed: controller.refresh,
          ),
        );
      }

      final stats = controller.stats.value;
      if (stats == null) return const SizedBox.shrink();

      final int statColumns = isMobile ? 2 : (isTablet ? 3 : 6);

      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dashboard', style: AppTextStyles.h2),
                      const SizedBox(height: 4),
                      Text(
                        "Welcome back! Here's what's happening.",
                        style: AppTextStyles.body.copyWith(
                          color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                AppButton(
                  label: 'Refresh',
                  icon: Icons.refresh,
                  type: AppButtonType.outline,
                  onPressed: controller.refresh,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Stats Grid ───────────────────────────────────────────────
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: statColumns,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: statColumns == 6 ? 1.3 : 1.2,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return [
                  StatCard(
                    title: 'Total Users',
                    value: NumberFormat.compact().format(stats.totalUsers),
                    icon: Icons.people_alt_outlined,
                    color: AppColors.primary,
                    trend: '+12.5%',
                    isPositiveTrend: true,
                  ),
                  StatCard(
                    title: 'Total Sellers',
                    value: NumberFormat.compact().format(stats.totalSellers),
                    icon: Icons.store_outlined,
                    color: AppColors.chartPalette[1],
                    trend: '+8.2%',
                    isPositiveTrend: true,
                  ),
                  StatCard(
                    title: 'Active Livestreams',
                    value: stats.activeLivestreams.toString(),
                    icon: Icons.live_tv_outlined,
                    color: AppColors.error,
                    trend: '+5 today',
                    isPositiveTrend: true,
                  ),
                  StatCard(
                    title: 'Running Auctions',
                    value: stats.runningAuctions.toString(),
                    icon: Icons.gavel_outlined,
                    color: AppColors.warning,
                    trend: '-3.1%',
                    isPositiveTrend: false,
                  ),
                  StatCard(
                    title: 'Revenue',
                    value: currencyFormatter.format(stats.revenue),
                    icon: Icons.attach_money_outlined,
                    color: AppColors.success,
                    trend: '+18.7%',
                    isPositiveTrend: true,
                  ),
                  StatCard(
                    title: 'Orders',
                    value: NumberFormat.compact().format(stats.orders),
                    icon: Icons.shopping_bag_outlined,
                    color: AppColors.info,
                    trend: '+4.3%',
                    isPositiveTrend: true,
                  ),
                ][index];
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Charts + Activity Feed ───────────────────────────────────
            if (!isMobile && !isTablet)
              SizedBox(
                height: 380,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 5,
                      child: RevenueChart(data: controller.revenueData),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      flex: 3,
                      child: UserGrowthChart(data: controller.userGrowthData),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      flex: 3,
                      child: ActivityFeedWidget(
                          activities: controller.recentActivity),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: RevenueChart(data: controller.revenueData),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 300,
                    child: UserGrowthChart(data: controller.userGrowthData),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 360,
                    child: ActivityFeedWidget(
                        activities: controller.recentActivity),
                  ),
                ],
              ),
            const SizedBox(height: AppSpacing.xl),

            // ── Quick Actions ────────────────────────────────────────────
            const QuickActionsWidget(),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      );
    });
  }
}
