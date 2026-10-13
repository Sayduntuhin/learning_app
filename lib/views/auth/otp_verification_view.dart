import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/widgets.dart';

typedef OtpVerificationView = OtpVerificationScreen;

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String _enteredOtp = '';
  int _secondsRemaining = 42;
  Timer? _timer;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining = 42;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onVerify() {
    setState(() {
      _isVerifying = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _isVerifying = false;
      });

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AppTheme.primaryGreen, size: 28),
              const SizedBox(width: 10),
              Text(
                'Success!',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.darkNavy,
                ),
              ),
            ],
          ),
          content: Text(
            'Your email ${widget.email} has been verified with OTP $_enteredOtp. Welcome to Fluentio!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppTheme.subtitleGray,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text(
                'Go to Home',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
          ],
        ),
      );
    });
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
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        SizedBox(height: isInsideFrame ? 28 : 16),

                        // Logo header
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: const FluentioLogo.full(height: 65),
                        ),

                        const SizedBox(height: 20),
                        const Spacer(),

                        // Bottom Sheet Form Card
                        AuthCardContainer(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'OTP Verification',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.darkNavy,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "We've sent a 4-digit verification code to your email.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.subtitleGray,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // 4-Digit OTP Input
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: OtpInputRow(
                                  length: 4,
                                  onChanged: (code) {
                                    setState(() {
                                      _enteredOtp = code;
                                    });
                                  },
                                  onCompleted: (code) {
                                    _enteredOtp = code;
                                    _onVerify();
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Circular Countdown Timer
                              CircularTimerWidget(
                                remainingSeconds: _secondsRemaining,
                                totalSeconds: 60,
                                size: 88,
                              ),
                              const SizedBox(height: 16),

                              // Resend text with RichText
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    color: AppTheme.subtitleGray,
                                  ),
                                  children: [
                                    const TextSpan(text: "Didn't receive the code? "),
                                    TextSpan(
                                      text: 'Resend',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: _secondsRemaining == 0
                                            ? AppTheme.primaryBlue
                                            : Colors.grey.shade400,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = _secondsRemaining == 0 ? _startTimer : null,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Verify OTP Button
                              GradientButton(
                                text: 'Verify OTP',
                                isLoading: _isVerifying,
                                onPressed: _onVerify,
                              ),
                              const SizedBox(height: 10),

                              // Back Button
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Back',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.subtitleGray,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
}
