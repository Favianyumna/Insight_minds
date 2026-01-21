import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';

/// Reusable stat card widget for displaying statistics
class StatCard extends StatelessWidget {
  final String label;
  final dynamic value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMD),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppSizes.iconMD),
          const SizedBox(height: AppSizes.spacingSM),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: AppSizes.fontSize3XL,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: AppSizes.spacingXS),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSizes.fontSizeSM,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
