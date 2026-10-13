import 'package:flutter/material.dart';

/// Reusable background overlay rendering the subtle wave patterns.
class BackgroundWaves extends StatelessWidget {
  final Widget? child;
  final BoxFit fit;
  final Alignment alignment;

  const BackgroundWaves({
    super.key,
    this.child,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.bottomCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/bg_waves.png',
            fit: fit,
            alignment: alignment,
          ),
        ),
        ?child,
      ],
    );
  }
}
