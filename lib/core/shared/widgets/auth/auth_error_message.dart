import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

/// Error message widget for authentication forms
class AuthErrorMessage extends StatelessWidget {
  final String message;

  const AuthErrorMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMD),
      decoration: BoxDecoration(
        color: AppColors.errorLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        border: Border.all(
          color: AppColors.errorLight.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: AppSizes.iconSM,
          ),
          const SizedBox(width: AppSizes.spacingSM),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: AppSizes.fontSizeSM,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
