import 'package:flutter/material.dart';


enum AppButtonType { primary, secondary, outline, text }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonType type;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.type = AppButtonType.primary,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    Widget child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton(onPressed: isDisabled ? null : onPressed, child: child);
      case AppButtonType.secondary:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Colors.white,
          ),
          onPressed: isDisabled ? null : onPressed,
          child: child,
        );
      case AppButtonType.outline:
        return OutlinedButton(onPressed: isDisabled ? null : onPressed, child: child);
      case AppButtonType.text:
        return TextButton(onPressed: isDisabled ? null : onPressed, child: child);
    }
  }
}
