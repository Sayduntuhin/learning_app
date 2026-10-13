import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'assessment_report_view.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/widgets.dart';

typedef VoiceAssessmentView = VoiceAssessmentScreen;

enum VoiceRecordingState {
  idle,
  recording,
  completed,
}

class VoiceAssessmentScreen extends StatefulWidget {
  final String? userName;
  final String? language;
  final String? goal;
  final String? level;
  final String? practiceTime;

  const VoiceAssessmentScreen({
    super.key,
    this.userName,
    this.language,
    this.goal,
    this.level,
    this.practiceTime,
  });

  @override
  State<VoiceAssessmentScreen> createState() => _VoiceAssessmentScreenState();
}

class _VoiceAssessmentScreenState extends State<VoiceAssessmentScreen>
    with SingleTickerProviderStateMixin {
  VoiceRecordingState _state = VoiceRecordingState.idle;
  int _secondsElapsed = 0;
  final int _maxSeconds = 60;
  Timer? _timer;

  // Real Audio Hardware Controller
  late final AudioRecorder _audioRecorder;
  late final AudioPlayer _audioPlayer;
  String? _recordedFilePath;
  bool _isPlayingSavedAudio = false;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _audioPlayer = AudioPlayer();

    // Listen to playback completion to automatically update play/pause UI
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlayingSavedAudio = false;
        });
      }
    });
  }

  Future<void> _startRecording() async {
    setState(() {
      _state = VoiceRecordingState.recording;
      _secondsElapsed = 0;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsElapsed >= _maxSeconds) {
        _stopRecording();
      } else {
        setState(() {
          _secondsElapsed++;
        });
      }
    });

    try {
      bool hasPermission = false;
      try {
        hasPermission = await _audioRecorder.hasPermission();
      } catch (_) {
        hasPermission = true;
      }

      if (!hasPermission) {
        debugPrint('[Fluentio] Audio permission not granted.');
        return;
      }

      String? path;
      if (!kIsWeb) {
        try {
          final dir = await getTemporaryDirectory();
          path = '${dir.path}/fluentio_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
        } catch (_) {}
      }

      try {
        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: path ?? '',
        );
      } catch (e) {
        debugPrint('[Fluentio] Hardware audio recorder notice: $e');
      }
      debugPrint('[Fluentio] Audio recording session active.');
    } catch (e, stackTrace) {
      debugPrint('[Fluentio] Notice starting recorder: $e\n$stackTrace');
    }
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    setState(() {
      _state = VoiceRecordingState.completed;
    });

    try {
      final path = await _audioRecorder.stop();
      if (mounted && path != null) {
        setState(() {
          _recordedFilePath = path;
        });
      }
      debugPrint('[Fluentio] Voice recording saved at: $path');
    } catch (e) {
      debugPrint('[Fluentio] Notice stopping recorder: $e');
    }
  }

  Future<void> _togglePlayback() async {
    if (_isPlayingSavedAudio) {
      await _audioPlayer.pause();
      setState(() {
        _isPlayingSavedAudio = false;
      });
      debugPrint('[Fluentio] Playback paused.');
    } else {
      if (_recordedFilePath != null && _recordedFilePath!.isNotEmpty) {
        debugPrint('[Fluentio] Playing back real recorded voice: $_recordedFilePath');
        try {
          await _audioPlayer.play(DeviceFileSource(_recordedFilePath!));
          setState(() {
            _isPlayingSavedAudio = true;
          });
        } catch (e) {
          debugPrint('[Fluentio] Error playing back audio file: $e');
          setState(() {
            _isPlayingSavedAudio = true;
          });
          Future.delayed(Duration(seconds: _secondsElapsed.clamp(2, 60)), () {
            if (mounted && _isPlayingSavedAudio) {
              setState(() {
                _isPlayingSavedAudio = false;
              });
            }
          });
        }
      } else {
        debugPrint('[Fluentio] Simulating audio playback.');
        setState(() {
          _isPlayingSavedAudio = true;
        });
        Future.delayed(Duration(seconds: _secondsElapsed.clamp(2, 60)), () {
          if (mounted && _isPlayingSavedAudio) {
            setState(() {
              _isPlayingSavedAudio = false;
            });
          }
        });
      }
    }
  }

  void _reRecord() async {
    _timer?.cancel();
    try {
      await _audioPlayer.stop();
    } catch (_) {}
    setState(() {
      _state = VoiceRecordingState.idle;
      _secondsElapsed = 0;
      _isPlayingSavedAudio = false;
      _recordedFilePath = null;
    });
  }

  void _onContinue() {
    try {
      _audioPlayer.stop();
    } catch (_) {}

    debugPrint('[Fluentio] Navigating to AssessmentReportScreen...');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AssessmentReportScreen(
          userName: widget.userName,
          language: widget.language,
          goal: widget.goal,
          level: widget.level,
          practiceTime: widget.practiceTime,
        ),
      ),
    );
  }

  String _formatTime(int totalSecs) {
    final mins = (totalSecs ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSecs % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 640;

    if (!isDesktop) {
      return Scaffold(
        body: _buildScreenContent(context, isInsideFrame: false),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFE2E8F0),
                    Color(0xFFF8FAFC),
                    Color(0xFFE0F2FE),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: DeviceMockupFrame(
              child: _buildScreenContent(context, isInsideFrame: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenContent(BuildContext context, {required bool isInsideFrame}) {
    return Container(
      color: Colors.white,
      child: BackgroundWaves(
        child: SafeArea(
          top: !isInsideFrame,
          bottom: !isInsideFrame,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: isInsideFrame ? 24 : 16),

                        // [TOP ANIMATION] Logo Header
                        const FadeSlideTransition(
                          direction: SlideDirection.fromTop,
                          duration: Duration(milliseconds: 500),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FluentioLogo.full(height: 52),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // [LEFT ANIMATION] Headline & Subtitle
                        FadeSlideTransition(
                          direction: SlideDirection.fromLeft,
                          duration: const Duration(milliseconds: 550),
                          delay: const Duration(milliseconds: 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Let's hear you speak.",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.darkNavy,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Record yourself for 60 seconds. This helps us understand your current speaking level.",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.subtitleGray,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Speaking Prompt Speech Bubble with Pointer
                        Center(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0FDF4),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryGreen.withValues(alpha: 0.06),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'YOUR SPEAKING PROMPT',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.primaryGreen,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '"Tell me about yourself."',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.darkNavy,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Downward triangle pointer
                              CustomPaint(
                                size: const Size(14, 8),
                                painter: _TrianglePointerPainter(
                                  color: const Color(0xFFF0FDF4),
                                  borderColor: AppTheme.primaryGreen.withValues(alpha: 0.3),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Tutor Avatar Portrait
                        Center(
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.primaryBlue.withValues(alpha: 0.2),
                                  AppTheme.primaryGreen.withValues(alpha: 0.4),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryGreen.withValues(alpha: 0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(3),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/tutor_portrait.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Image.asset(
                                  'assets/images/avatars/avatar_4.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Bottom Interactive Flow based on State
                        _buildBottomInteractionArea(),

                        SizedBox(height: isInsideFrame ? 28 : 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBottomInteractionArea() {
    switch (_state) {
      case VoiceRecordingState.idle:
        return _buildIdleState();
      case VoiceRecordingState.recording:
        return _buildRecordingState();
      case VoiceRecordingState.completed:
        return _buildCompletedState();
    }
  }

  // STATE 1: IDLE (iPhone 16 - 110)
  Widget _buildIdleState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Green Circular Microphone Button
        Center(
          child: GestureDetector(
            onTap: _startRecording,
            child: Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryGreen,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.mic_rounded,
                  color: Colors.white,
                  size: 38,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // "Tap to start"
        Text(
          'Tap to start',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.darkNavy,
          ),
        ),
        const SizedBox(height: 8),

        // Caption
        Text(
          "Don't worry about mistakes. Just speak naturally.",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            color: AppTheme.subtitleGray,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // STATE 2: RECORDING (iPhone 16 - 111)
  Widget _buildRecordingState() {
    final progress = (_secondsElapsed / _maxSeconds).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Live Audio Waveform Visualizer
        const AudioWaveformVisualizer(
          isRecording: true,
          height: 48,
        ),
        const SizedBox(height: 18),

        // Timer (e.g. 00:02 / 01:00)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(_secondsElapsed),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.primaryGreen,
              ),
            ),
            Text(
              ' / ${_formatTime(_maxSeconds)}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.subtitleGray,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Linear Progress Bar
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress == 0 ? 0.03 : progress,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Stop Button & Label with tap interaction
        GestureDetector(
          key: const ValueKey('stop_recording_button'),
          onTap: _stopRecording,
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryGreen,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryGreen.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Tap to stop',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkNavy,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // STATE 3: COMPLETED (iPhone 16 - 112)
  Widget _buildCompletedState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Recording Saved Player Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppTheme.primaryGreen,
              width: 1.8,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryGreen.withValues(alpha: 0.12),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Play/Pause Button
              GestureDetector(
                onTap: _togglePlayback,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlayingSavedAudio ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Title & recorded duration
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recording saved!',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.darkNavy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_formatTime(_secondsElapsed.clamp(1, 60))} recorded',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppTheme.subtitleGray,
                      ),
                    ),
                  ],
                ),
              ),

              // Waveform equalizer icon bars with dynamic animated height
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _miniWaveBar(14, _isPlayingSavedAudio),
                  _miniWaveBar(24, _isPlayingSavedAudio),
                  _miniWaveBar(32, _isPlayingSavedAudio),
                  _miniWaveBar(18, _isPlayingSavedAudio),
                  _miniWaveBar(28, _isPlayingSavedAudio),
                  _miniWaveBar(12, _isPlayingSavedAudio),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Continue CTA Button
        GradientButton(
          text: 'Continue',
          onPressed: _onContinue,
        ),
        const SizedBox(height: 12),

        // Re-record Button
        TextButton(
          onPressed: _reRecord,
          child: Text(
            'Re - record',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.subtitleGray,
            ),
          ),
        ),
      ],
    );
  }

  Widget _miniWaveBar(double height, bool animate) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 1.5),
      width: 3,
      height: animate ? height : height * 0.5,
      decoration: BoxDecoration(
        color: animate ? AppTheme.primaryGreen : AppTheme.primaryBlue,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _TrianglePointerPainter extends CustomPainter {
  final Color color;
  final Color borderColor;

  _TrianglePointerPainter({required this.color, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
