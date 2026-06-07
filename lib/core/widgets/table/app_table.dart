import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../app_button.dart';
import '../app_search_field.dart';
import '../app_card.dart';
import 'app_table_source.dart';
import 'table_action_models.dart';
import 'table_export_service.dart';

class AppTable extends StatefulWidget {
  final String title;
  final List<GridColumn> columns;
  final AppTableSource source;
  final List<TableBulkAction>? bulkActions;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onFilter;
  final bool showCheckboxColumn;
  final DataGridController? controller;

  const AppTable({
    super.key,
    required this.title,
    required this.columns,
    required this.source,
    this.bulkActions,
    this.onSearch,
    this.onFilter,
    this.showCheckboxColumn = true,
    this.controller,
  });

  @override
  State<AppTable> createState() => _AppTableState();
}

class _AppTableState extends State<AppTable> {
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  late final DataGridController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? DataGridController();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: SfDataGrid(
              key: _key,
              source: widget.source,
              columns: widget.columns,
              controller: _internalController,
              allowSorting: true,
              allowMultiColumnSorting: true,
              allowFiltering: false, // We use external custom filters
              selectionMode: SelectionMode.multiple,
              showCheckboxColumn: widget.showCheckboxColumn,
              headerGridLinesVisibility: GridLinesVisibility.none,
              gridLinesVisibility: GridLinesVisibility.horizontal,
              rowHeight: 60,
              headerRowHeight: 56,
              columnWidthMode: ColumnWidthMode.fill,
            ),
          ),
          const Divider(height: 1, thickness: 1),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Text(widget.title, style: AppTextStyles.h4),
          const Spacer(),
          if (widget.onSearch != null)
            SizedBox(
              width: 250,
              child: AppSearchField(
                hintText: 'Search...',
                onChanged: widget.onSearch,
              ),
            ),
          const SizedBox(width: AppSpacing.md),
          if (widget.onFilter != null)
            AppButton(
              label: 'Filter',
              icon: Icons.filter_list,
              type: AppButtonType.outline,
              onPressed: widget.onFilter,
            ),
          const SizedBox(width: AppSpacing.md),
          // Export Menu
          PopupMenuButton<String>(
            tooltip: 'Export',
            icon: const Icon(Icons.download),
            onSelected: (value) {
              if (value == 'excel') {
                TableExportService.exportToExcel(_key, widget.title);
              } else if (value == 'pdf') {
                TableExportService.exportToPdf(_key, widget.title);
              } else if (value == 'csv') {
                TableExportService.exportToCsv(_key, widget.title);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'excel', child: Text('Export Excel')),
              PopupMenuItem(value: 'pdf', child: Text('Export PDF')),
              PopupMenuItem(value: 'csv', child: Text('Export CSV')),
            ],
          ),
          // Bulk Actions
          if (widget.bulkActions != null && widget.bulkActions!.isNotEmpty) ...[
            const SizedBox(width: AppSpacing.md),
            PopupMenuButton<TableBulkAction>(
              tooltip: 'Bulk Actions',
              icon: const Icon(Icons.more_vert),
              onSelected: (action) {
                final selectedRows = _internalController.selectedRows;
                action.onAction(selectedRows);
              },
              itemBuilder: (context) => widget.bulkActions!.map((action) {
                return PopupMenuItem(
                  value: action,
                  child: Text(
                    action.label,
                    style: TextStyle(color: action.isDestructive ? AppColors.error : null),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return SizedBox(
      height: 60,
      child: SfDataPager(
        delegate: widget.source,
        pageCount: widget.source.totalCount > 0 
            ? (widget.source.totalCount / widget.source.rowsPerPage).ceil().toDouble() 
            : 1,
        direction: Axis.horizontal,
      ),
    );
  }
}
