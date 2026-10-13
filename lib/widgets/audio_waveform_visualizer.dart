import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// Animated live audio waveform visualizer for recording and playback.
class AudioWaveformVisualizer extends StatefulWidget {
  final bool isRecording;
  final int barCount;
  final double height;
  final Gradient gradient;

  const AudioWaveformVisualizer({
    super.key,
    required this.isRecording,
    this.barCount = 28,
    this.height = 42,
    this.gradient = const LinearGradient(
      colors: [
        Color(0xFF38BDF8),
        Color(0xFF00D46A),
        Color(0xFF0055FF),
      ],
    ),
  });

  @override
  State<AudioWaveformVisualizer> createState() => _AudioWaveformVisualizerState();
}

class _AudioWaveformVisualizerState extends State<AudioWaveformVisualizer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final math.Random _random = math.Random(42);
  late List<double> _baseHeights;

  @override
  void initState() {
    super.initState();
    _baseHeights = List.generate(
      widget.barCount,
      (index) {
        // Bell-curve shaped amplitude
        final normalized = (index - widget.barCount / 2).abs() / (widget.barCount / 2);
        return (1.0 - normalized * 0.6) * (0.3 + _random.nextDouble() * 0.7);
      },
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    if (widget.isRecording) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AudioWaveformVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording != oldWidget.isRecording) {
      if (widget.isRecording) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          height: widget.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(widget.barCount, (index) {
              final wave = widget.isRecording
                  ? math.sin(_controller.value * 2 * math.pi + (index * 0.35))
                  : 0.0;
              final dynamicFactor = (wave.abs() * 0.5) + 0.5;
              final barHeight = (_baseHeights[index] * dynamicFactor * widget.height)
                  .clamp(4.0, widget.height);

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.2),
                width: 3.2,
                height: barHeight,
                decoration: BoxDecoration(
                  gradient: widget.gradient,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: widget.isRecording
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryGreen.withValues(alpha: 0.25),
                            blurRadius: 4,
                          ),
                        ]
                      : null,
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
