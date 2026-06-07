import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../core/theme/app_colors.dart';
// AppColors.primary is used for Revenue chart accent
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';

class RevenueChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const RevenueChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Revenue Overview', style: AppTextStyles.h4),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: SfCartesianChart(
              margin: EdgeInsets.zero,
              primaryXAxis: const CategoryAxis(
                majorGridLines: MajorGridLines(width: 0),
                axisLine: AxisLine(width: 0),
              ),
              primaryYAxis: const NumericAxis(
                axisLine: AxisLine(width: 0),
                labelFormat: '\${value}',
                majorTickLines: MajorTickLines(size: 0),
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries>[
                SplineAreaSeries<Map<String, dynamic>, String>(
                  dataSource: data,
                  xValueMapper: (Map<String, dynamic> item, _) => item['month'] as String,
                  yValueMapper: (Map<String, dynamic> item, _) => item['revenue'] as num,
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderColor: AppColors.primary,
                  borderWidth: 3,
                  name: 'Revenue',
                  // Use gradient for a beautiful modern look
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.4),
                      AppColors.primary.withValues(alpha: 0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
