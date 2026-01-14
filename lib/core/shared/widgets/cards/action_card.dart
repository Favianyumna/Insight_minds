import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

/// Reusable action card widget with a button
class ActionCard extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? icon;
  final Color? iconColor;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final bool buttonEnabled;
  final Widget? child;

  const ActionCard({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.iconColor,
    required this.buttonText,
    this.onButtonPressed,
    this.buttonEnabled = true,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppSizes.elevationMD,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: AppSizes.iconXL,
                color: iconColor ?? AppColors.primary,
              ),
              const SizedBox(height: AppSizes.spacingLG),
            ],
            Text(
              title,
              style: const TextStyle(
                fontSize: AppSizes.fontSizeXL,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: AppSizes.spacingSM),
              Text(
                description!,
                style: TextStyle(
                  fontSize: AppSizes.fontSizeMD,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (child != null) ...[
              const SizedBox(height: AppSizes.spacingLG),
              child!,
            ],
            const SizedBox(height: AppSizes.spacingXL),
            FilledButton(
              onPressed: buttonEnabled ? onButtonPressed : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, AppSizes.buttonHeightMD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                ),
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
