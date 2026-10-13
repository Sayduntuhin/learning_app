import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// Reusable animated dot page indicator for carousels and onboarding.
class PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final ValueChanged<int>? onDotTap;
  final Gradient activeGradient;
  final Color inactiveColor;
  final double activeWidth;
  final double inactiveWidth;
  final double height;
  final double spacing;

  const PageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.onDotTap,
    this.activeGradient = AppTheme.brandGradient,
    this.inactiveColor = AppTheme.dotInactive,
    this.activeWidth = 12,
    this.inactiveWidth = 7,
    this.height = 7,
    this.spacing = 4.5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final bool isActive = index == currentIndex;
        return GestureDetector(
          onTap: onDotTap != null ? () => onDotTap!(index) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(horizontal: spacing),
            width: isActive ? activeWidth : inactiveWidth,
            height: height,
            decoration: BoxDecoration(
              gradient: isActive ? activeGradient : null,
              color: isActive ? null : inactiveColor,
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
        );
      }),
    );
  }
}
