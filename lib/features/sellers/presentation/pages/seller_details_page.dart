import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../controllers/seller_details_controller.dart';
import '../widgets/kyc_review_card.dart';
import '../widgets/seller_analytics_widget.dart';

class SellerDetailsPage extends StatefulWidget {
  final String sellerId;
  const SellerDetailsPage({super.key, required this.sellerId});

  @override
  State<SellerDetailsPage> createState() => _SellerDetailsPageState();
}

class _SellerDetailsPageState extends State<SellerDetailsPage> {
  late final SellerDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SellerDetailsController>();
    controller.loadSeller(widget.sellerId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.seller.value == null) {
        return const Center(child: AppLoader());
      }

      final seller = controller.seller.value;
      if (seller == null) {
        return const Center(child: Text('Seller not found'));
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text('Seller Details', style: AppTextStyles.h2),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Profile & Settings
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    // Profile Info
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        children: [
                          AppAvatar(imageUrl: seller.logoUrl, initials: seller.shopName.substring(0, 1), radius: 50),
                          const SizedBox(height: AppSpacing.md),
                          Text(seller.shopName, style: AppTextStyles.h3),
                          const SizedBox(height: AppSpacing.xs),
                          Text(seller.ownerName, style: AppTextStyles.body.copyWith(color: AppColors.textSecondaryLight)),
                          const SizedBox(height: AppSpacing.lg),
                          
                          _buildInfoRow('ID', seller.id),
                          const Divider(),
                          _buildInfoRow('Email', seller.email),
                          const Divider(),
                          _buildInfoRow('Phone', seller.phone),
                          const Divider(),
                          _buildInfoRow('Joined', DateFormat('MMM d, yyyy').format(seller.joinedAt)),
                          const Divider(),
                          _buildInfoRow('Followers', NumberFormat.compact().format(seller.followers)),
                          const Divider(),
                          
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Status', style: AppTextStyles.body),
                                AppStatusChip(
                                  label: seller.status.toUpperCase(),
                                  type: seller.status == 'active' 
                                      ? AppStatusType.success 
                                      : (seller.status == 'rejected' ? AppStatusType.error : AppStatusType.warning),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Admin Actions
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Administrative Actions', style: AppTextStyles.h4.copyWith(color: AppColors.error)),
                          const SizedBox(height: AppSpacing.lg),
                          
                          if (seller.status == 'pending') ...[
                            _buildActionTile('Approve Seller', 'Allow the seller to open their shop.', 'Approve', controller.approveSeller),
                            const Divider(),
                            _buildActionTile('Reject Seller', 'Deny the seller application.', 'Reject', controller.rejectSeller, isDestructive: true),
                            const Divider(),
                          ],

                          _buildActionTile('Suspend Seller', 'Temporarily suspend the shop.', 'Suspend', controller.suspendSeller),
                          const Divider(),
                          _buildActionTile(
                            'Freeze Payouts', 
                            seller.payoutsFrozen ? 'Payouts are currently frozen.' : 'Prevent seller from withdrawing funds.', 
                            'Freeze', 
                            controller.freezePayouts,
                          ),
                          const Divider(),
                          _buildActionTile(
                            'Disable Livestreams', 
                            seller.livestreamsDisabled ? 'Livestreams are disabled.' : 'Revoke livestreaming privileges.', 
                            'Disable', 
                            controller.disableLivestreams,
                          ),
                          const Divider(),
                          _buildActionTile(
                            'Disable Auctions', 
                            seller.auctionsDisabled ? 'Auctions are disabled.' : 'Revoke auction privileges.', 
                            'Disable', 
                            controller.disableAuctions,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xl),
              
              // Right Column: KYC & Analytics
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    KycReviewCard(
                      status: seller.kycStatus,
                      onApprove: () => controller.reviewKyc(true),
                      onReject: () => controller.reviewKyc(false),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SellerAnalyticsWidget(
                      totalRevenue: seller.totalRevenue,
                      totalSales: seller.totalSales,
                      conversionRate: seller.conversionRate,
                      rating: seller.rating,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        ),
      );
    });
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body.copyWith(color: AppColors.textSecondaryLight)),
          Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildActionTile(String title, String description, String buttonLabel, VoidCallback onPressed, {bool isDestructive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.h5.copyWith(color: isDestructive ? AppColors.error : AppColors.textPrimaryLight)),
                const SizedBox(height: 4),
                Text(description, style: AppTextStyles.bodySm.copyWith(color: AppColors.textSecondaryLight)),
              ],
            ),
          ),
          AppButton(
            label: buttonLabel,
            type: AppButtonType.outline,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AppConfirmationDialog(
                  title: title,
                  content: 'Are you sure you want to perform this action?',
                  confirmText: 'Confirm',
                  cancelText: 'Cancel',
                  onConfirm: onPressed,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
