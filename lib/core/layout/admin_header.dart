import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'layout_controller.dart';
import '../theme/app_spacing.dart';
import '../theme/app_colors.dart';
import 'responsive_builder.dart';

class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final LayoutController layoutController = Get.find<LayoutController>();
    final bool isMobile = ResponsiveBuilder.isMobile(context);

    return Container(
      height: AppSpacing.headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerTheme.color ?? AppColors.borderLight)),
      ),
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: layoutController.openDrawer,
            )
          else
            Obx(() => IconButton(
              icon: Icon(layoutController.isSidebarCollapsed.value ? Icons.menu : Icons.menu_open),
              onPressed: layoutController.toggleSidebar,
            )),
          const Spacer(),
          // Search Bar
          if (!isMobile)
            Container(
              width: 300,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search, size: 20),
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                ),
              ),
            ),
          if (!isMobile) const Spacer(),
          // Notifications
          IconButton(
            icon: const Badge(
              label: Text('3'),
              child: Icon(Icons.notifications_outlined),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: AppSpacing.md),
          // User Profile Menu
          PopupMenuButton(
            offset: const Offset(0, 48),
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Text('A', style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              const PopupMenuItem(child: Text('Profile')),
              const PopupMenuItem(child: Text('Settings')),
              const PopupMenuDivider(),
              const PopupMenuItem(child: Text('Logout', style: TextStyle(color: AppColors.error))),
            ],
          ),
        ],
      ),
    );
  }
}
