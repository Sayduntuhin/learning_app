import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// Reusable segmented progress bar for onboarding and multi-step onboarding flows.
class SegmentedProgressBar extends StatelessWidget {
  final int totalSegments;
  final int activeIndex;
  final double height;
  final double spacing;
  final Gradient activeGradient;
  final Color inactiveColor;

  const SegmentedProgressBar({
    super.key,
    this.totalSegments = 5,
    this.activeIndex = 0,
    this.height = 4.5,
    this.spacing = 6.0,
    this.activeGradient = AppTheme.brandGradient,
    this.inactiveColor = const Color(0xFFE2E8F0),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSegments, (index) {
        final bool isCompleted = index <= activeIndex;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: index < totalSegments - 1 ? spacing : 0,
            ),
            height: height,
            decoration: BoxDecoration(
              gradient: isCompleted ? activeGradient : null,
              color: isCompleted ? null : inactiveColor,
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
        );
      }),
    );
  }
}
