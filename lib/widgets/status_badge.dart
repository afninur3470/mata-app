import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';
import '../app/theme/app_typography.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final StatusType type;

  const StatusBadge({
    super.key,
    required this.text,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case StatusType.success:
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        break;
      case StatusType.warning:
        backgroundColor = AppColors.warning.withValues(alpha: 0.1);
        textColor = AppColors.warning;
        break;
      case StatusType.danger:
        backgroundColor = AppColors.danger.withValues(alpha: 0.1);
        textColor = AppColors.danger;
        break;
      case StatusType.info:
        backgroundColor = AppColors.supportPrimary.withValues(alpha: 0.1);
        textColor = AppColors.supportPrimary;
        break;
      case StatusType.primary:
        backgroundColor = AppColors.engineerPrimary.withValues(alpha: 0.1);
        textColor = AppColors.engineerPrimary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text.toUpperCase(),
        style: AppTypography.bodySmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

enum StatusType {
  success,
  warning,
  danger,
  info,
  primary,
}
