import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';

class KycReviewCard extends StatelessWidget {
  final String status;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const KycReviewCard({
    super.key,
    required this.status,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPending = status == 'pending' || status == 'unverified';

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('KYC Verification', style: AppTextStyles.h4)),
              const SizedBox(width: 8),
              _buildStatusIndicator(),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Documents Submitted:',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildDocumentRow(context, Icons.badge_outlined, 'National ID / Passport', 'Verified'),
          const SizedBox(height: AppSpacing.sm),
          _buildDocumentRow(context, Icons.business_outlined, 'Business License', 'Pending Review'),
          const SizedBox(height: AppSpacing.sm),
          _buildDocumentRow(context, Icons.account_balance_outlined, 'Bank Statement', 'Verified'),
          
          if (isPending) ...[
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Reject KYC',
                    type: AppButtonType.outline,
                    onPressed: onReject,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton(
                    label: 'Approve KYC',
                    onPressed: onApprove,
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    Color color;
    IconData icon;
    if (status == 'approved') {
      color = AppColors.success;
      icon = Icons.check_circle;
    } else if (status == 'rejected') {
      color = AppColors.error;
      icon = Icons.cancel;
    } else {
      color = AppColors.warning;
      icon = Icons.pending;
    }

    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          status.toUpperCase(),
          style: AppTextStyles.body.copyWith(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDocumentRow(BuildContext context, IconData icon, String name, String docStatus) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight)),
      ),
      child: Row(
        children: [
          Icon(icon, color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(name, style: AppTextStyles.body),
          ),
          Text(
            docStatus,
            style: AppTextStyles.bodySm.copyWith(
              color: docStatus == 'Verified' ? AppColors.success : AppColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Icon(Icons.remove_red_eye, size: 20, color: AppColors.primary),
        ],
      ),
    );
  }
}
