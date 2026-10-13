import 'package:flutter/material.dart';

/// Reusable elevated bottom card with rounded top corners for auth forms.
class AuthCardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AuthCardContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(28, 32, 28, 24),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: child,
    );
  }
}
