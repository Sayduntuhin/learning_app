import 'package:flutter/material.dart';

enum SlideDirection {
  fromTop,
  fromBottom,
  fromLeft,
  fromRight,
}

/// A smooth, configurable entry animation widget combining Fade and Directional Slide.
class FadeSlideTransition extends StatefulWidget {
  final Widget child;
  final SlideDirection direction;
  final Duration duration;
  final Duration delay;
  final double offsetDistance;
  final Curve curve;

  const FadeSlideTransition({
    super.key,
    required this.child,
    this.direction = SlideDirection.fromBottom,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.offsetDistance = 0.25,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<FadeSlideTransition> createState() => _FadeSlideTransitionState();
}

class _FadeSlideTransitionState extends State<FadeSlideTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    Offset startOffset;
    switch (widget.direction) {
      case SlideDirection.fromTop:
        startOffset = Offset(0, -widget.offsetDistance);
        break;
      case SlideDirection.fromBottom:
        startOffset = Offset(0, widget.offsetDistance);
        break;
      case SlideDirection.fromLeft:
        startOffset = Offset(-widget.offsetDistance, 0);
        break;
      case SlideDirection.fromRight:
        startOffset = Offset(widget.offsetDistance, 0);
        break;
    }

    _slideAnimation = Tween<Offset>(
      begin: startOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
