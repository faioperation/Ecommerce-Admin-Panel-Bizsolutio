import 'dart:io';

void main() async {
  final dir = Directory('lib/features');
  if (!dir.existsSync()) {
    print('lib/features not found');
    return;
  }

  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  final replacements = {
    'AppColors.textPrimaryLight': '(Theme.of(context).brightness == Brightness.dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)',
    'AppColors.textSecondaryLight': '(Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)',
    'AppColors.textTertiaryLight': '(Theme.of(context).brightness == Brightness.dark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)',
    'AppColors.borderLight': '(Theme.of(context).brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight)',
    'AppColors.surfaceLight': '(Theme.of(context).brightness == Brightness.dark ? AppColors.surfaceDark : AppColors.surfaceLight)',
    'AppColors.cardLight': '(Theme.of(context).brightness == Brightness.dark ? AppColors.cardDark : AppColors.cardLight)',
    'AppColors.hoverLight': '(Theme.of(context).brightness == Brightness.dark ? AppColors.hoverDark : AppColors.hoverLight)',
  };

  int updatedCount = 0;

  for (final file in files) {
    String content = file.readAsStringSync();
    bool changed = false;

    for (final entry in replacements.entries) {
      if (content.contains(entry.key)) {
        content = content.replaceAll(entry.key, entry.value);
        changed = true;
      }
    }

    if (changed) {
      file.writeAsStringSync(content);
      print('Updated: \${file.path}');
      updatedCount++;
    }
  }

  print('Finished! Updated \$updatedCount files.');
}
