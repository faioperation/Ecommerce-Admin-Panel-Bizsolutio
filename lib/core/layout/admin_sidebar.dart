import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'layout_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final LayoutController layoutController = Get.find<LayoutController>();

    return Obx(() {
      final bool isCollapsed = layoutController.isSidebarCollapsed.value;
      final double width = isCollapsed ? 80.0 : AppSpacing.sidebarWidth;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(right: BorderSide(color: Theme.of(context).dividerTheme.color ?? AppColors.borderLight)),
        ),
        child: Column(
          children: [
            // Logo Area
            Container(
              height: AppSpacing.headerHeight,
              alignment: Alignment.center,
              child: isCollapsed
                  ? const Icon(Icons.local_shipping, color: AppColors.primary, size: 32)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.local_shipping, color: AppColors.primary, size: 28),
                        const SizedBox(width: 12),
                        Text('Vango Live', style: AppTextStyles.h3.copyWith(color: AppColors.primary)),
                      ],
                    ),
            ),
            const Divider(height: 1, thickness: 1),
            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                children: [
                  _SidebarItem(icon: Icons.dashboard, label: 'Dashboard', route: '/', isCollapsed: isCollapsed),
                  _SidebarItem(icon: Icons.people, label: 'Users', route: '/users', isCollapsed: isCollapsed),
                  _SidebarItem(icon: Icons.storefront, label: 'Sellers', route: '/sellers', isCollapsed: isCollapsed),
                  _SidebarItem(icon: Icons.inventory_2, label: 'Products', route: '/products', isCollapsed: isCollapsed),
                  _SidebarItem(icon: Icons.live_tv, label: 'Livestreams', route: '/livestreams', isCollapsed: isCollapsed),
                  _SidebarItem(icon: Icons.gavel, label: 'Auctions', route: '/auctions', isCollapsed: isCollapsed),
                  _SidebarItem(icon: Icons.shopping_cart, label: 'Orders', route: '/orders', isCollapsed: isCollapsed),
                  _SidebarItem(icon: Icons.account_balance_wallet, label: 'Wallets', route: '/wallets', isCollapsed: isCollapsed),
                  _SidebarItem(icon: Icons.flag, label: 'Reports', route: '/reports', isCollapsed: isCollapsed),
                  _SidebarItem(icon: Icons.notifications, label: 'Notifications', route: '/notifications', isCollapsed: isCollapsed),
                  _SidebarItem(icon: Icons.bar_chart, label: 'Analytics', route: '/analytics', isCollapsed: isCollapsed),
                  const Divider(),
                  _SidebarItem(icon: Icons.settings, label: 'Settings', route: '/settings', isCollapsed: isCollapsed),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool isCollapsed;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouterState.of(context).uri.toString();
    final bool isSelected = currentRoute == route || (route != '/' && currentRoute.startsWith(route));
    
    final Color activeColor = AppColors.primary;
    final Color inactiveColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);

    Widget item = isCollapsed
        ? Tooltip(
            message: label,
            child: Icon(icon, color: isSelected ? activeColor : inactiveColor),
          )
        : Row(
            children: [
              Icon(icon, color: isSelected ? activeColor : inactiveColor),
              const SizedBox(width: AppSpacing.md),
              Text(
                label,
                style: AppTextStyles.body.copyWith(
                  color: isSelected ? activeColor : inactiveColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          );

    return InkWell(
      onTap: () {
        context.go(route);
        // If mobile drawer is open, close it
        if (Scaffold.of(context).hasDrawer && Scaffold.of(context).isDrawerOpen) {
          Get.find<LayoutController>().closeDrawer();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: isCollapsed ? 0 : AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySubtle.withValues(alpha: 0.5) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: isCollapsed ? Alignment.center : Alignment.centerLeft,
        child: item,
      ),
    );
  }
}
