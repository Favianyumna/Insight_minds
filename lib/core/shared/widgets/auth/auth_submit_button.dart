import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

/// Submit button for authentication forms with loading state
class AuthSubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;

  const AuthSubmitButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.paddingLG,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLG),
        ),
        elevation: AppSizes.elevationMD,
        minimumSize: const Size(double.infinity, AppSizes.buttonHeightMD),
      ),
      child: isLoading
          ? const SizedBox(
              height: AppSizes.iconSM,
              width: AppSizes.iconSM,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              text,
              style: const TextStyle(
                fontSize: AppSizes.fontSizeLG,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
