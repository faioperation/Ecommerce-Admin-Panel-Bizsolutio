import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum AppStatusType { success, error, warning, info, standard }

class AppStatusChip extends StatelessWidget {
  final String label;
  final AppStatusType type;

  const AppStatusChip({
    super.key,
    required this.label,
    this.type = AppStatusType.standard,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (type) {
      case AppStatusType.success:
        bgColor = AppColors.successSubtle;
        textColor = AppColors.success;
        break;
      case AppStatusType.error:
        bgColor = AppColors.errorSubtle;
        textColor = AppColors.error;
        break;
      case AppStatusType.warning:
        bgColor = AppColors.warningSubtle;
        textColor = AppColors.warning;
        break;
      case AppStatusType.info:
        bgColor = AppColors.infoSubtle;
        textColor = AppColors.info;
        break;
      case AppStatusType.standard:
        bgColor = Theme.of(context).colorScheme.surfaceContainerHighest;
        textColor = Theme.of(context).colorScheme.onSurface;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.overline.copyWith(color: textColor, fontWeight: FontWeight.w600),
      ),
    );
  }
}
