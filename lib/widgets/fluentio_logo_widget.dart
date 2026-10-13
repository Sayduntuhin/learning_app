import 'package:flutter/material.dart';

enum FluentioLogoVariant {
  iconOnly,
  fullBanner,
}

/// Reusable Fluentio Logo widget supporting both icon-only and full-banner variants.
class FluentioLogo extends StatelessWidget {
  final FluentioLogoVariant variant;
  final double? height;
  final double? width;
  final BoxFit fit;

  const FluentioLogo({
    super.key,
    this.variant = FluentioLogoVariant.iconOnly,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  });

  const FluentioLogo.icon({
    super.key,
    this.height = 52,
    this.width,
    this.fit = BoxFit.contain,
  }) : variant = FluentioLogoVariant.iconOnly;

  const FluentioLogo.full({
    super.key,
    this.height = 80,
    this.width,
    this.fit = BoxFit.contain,
  }) : variant = FluentioLogoVariant.fullBanner;

  @override
  Widget build(BuildContext context) {
    final assetPath = variant == FluentioLogoVariant.iconOnly
        ? 'assets/images/fluentio_bird.png'
        : 'assets/images/fluentio_logo.png';

    return Image.asset(
      assetPath,
      height: height,
      width: width,
      fit: fit,
    );
  }
}
