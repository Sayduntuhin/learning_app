import 'package:flutter/material.dart';

/// Reusable device mockup frame container for desktop and web presentation.
class DeviceMockupFrame extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final double cornerRadius;

  const DeviceMockupFrame({
    super.key,
    required this.child,
    this.width = 380,
    this.height = 790,
    this.cornerRadius = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF22262E), // Outer bezel dark slate
        borderRadius: BorderRadius.circular(cornerRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 50,
            spreadRadius: 4,
            offset: const Offset(0, 24),
          ),
          BoxShadow(
            color: const Color(0xFF0055FF).withValues(alpha: 0.15),
            blurRadius: 60,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF333842),
          width: 3.5,
        ),
      ),
      padding: const EdgeInsets.all(4), // Bezel thickness
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cornerRadius - 4),
        child: Stack(
          children: [
            Positioned.fill(child: child),
            // Speaker pill cutout
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                width: 64,
                height: 4.5,
                decoration: BoxDecoration(
                  color: const Color(0xFF383D47),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
