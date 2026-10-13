import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/profile_setup_screen.dart';
import '../core/theme/app_theme.dart';
import 'circular_timer_widget.dart';
import 'custom_text_field.dart';
import 'gradient_button.dart';
import 'otp_input_row.dart';
import 'social_auth_button.dart';

enum AuthFlowStep {
  options,
  emailInput,
  otpVerification,
}

/// Unified multi-step bottom sheet containing the complete auth flow:
/// Social options -> Email input -> 4-digit OTP verification.
class AuthFlowBottomSheet extends StatefulWidget {
  const AuthFlowBottomSheet({super.key});

  static Future<T?> show<T>(BuildContext context) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => const AuthFlowBottomSheet(),
    );
  }

  @override
  State<AuthFlowBottomSheet> createState() => _AuthFlowBottomSheetState();
}

class _AuthFlowBottomSheetState extends State<AuthFlowBottomSheet> {
  AuthFlowStep _currentStep = AuthFlowStep.options;
  final TextEditingController _emailController = TextEditingController();
  int _secondsRemaining = 42;
  Timer? _timer;
  bool _isVerifying = false;

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 42;
    });
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

  void _goToStep(AuthFlowStep step) {
    setState(() {
      _currentStep = step;
      if (step == AuthFlowStep.otpVerification) {
        _startTimer();
      }
    });
  }

  void _onSocialAuth(String provider) {
    Navigator.pop(context); // Close sheet
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ProfileSetupScreen(),
      ),
    );
  }

  void _onVerifyOtp() {
    setState(() {
      _isVerifying = true;
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _isVerifying = false;
      });

      final email = _emailController.text.trim().isEmpty
          ? 'your.email@example.com'
          : _emailController.text.trim();

      Navigator.pop(context); // Close bottom sheet

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProfileSetupScreen(email: email),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 30,
              offset: Offset(0, -10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 16, 28, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 44,
                height: 4.5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),

              // Animated Step Switcher
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      child: child,
                    ),
                  );
                },
                child: _buildCurrentStepWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStepWidget() {
    switch (_currentStep) {
      case AuthFlowStep.options:
        return _buildOptionsStep();
      case AuthFlowStep.emailInput:
        return _buildEmailStep();
      case AuthFlowStep.otpVerification:
        return _buildOtpStep();
    }
  }

  // STEP 1: Social Login & Email Options
  Widget _buildOptionsStep() {
    return Column(
      key: const ValueKey('step_options'),
      mainAxisSize: MainAxisSize.min,
      children: [
        SocialAuthButton.google(
          onPressed: () => _onSocialAuth('Google'),
        ),
        const SizedBox(height: 14),

        SocialAuthButton.apple(
          onPressed: () => _onSocialAuth('Apple'),
        ),
        const SizedBox(height: 18),

        Text(
          'OR',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade400,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 10),

        TextButton.icon(
          onPressed: () => _goToStep(AuthFlowStep.emailInput),
          icon: const Icon(
            Icons.mail_outline_rounded,
            size: 19,
            color: AppTheme.darkNavy,
          ),
          label: Text(
            'Continue with E-mail',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkNavy,
            ),
          ),
        ),
      ],
    );
  }

  // STEP 2: Email Input
  Widget _buildEmailStep() {
    return Column(
      key: const ValueKey('step_email'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Continue with E-mail',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppTheme.darkNavy,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Enter the mail address you want to use',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.subtitleGray,
          ),
        ),
        const SizedBox(height: 22),

        CustomTextField(
          label: 'Email address',
          hintText: 'your.email@example.com',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(
            Icons.mail_outline_rounded,
            color: Colors.grey.shade500,
            size: 20,
          ),
        ),
        const SizedBox(height: 24),

        GradientButton(
          text: 'Continue',
          onPressed: () => _goToStep(AuthFlowStep.otpVerification),
        ),
        const SizedBox(height: 10),

        TextButton(
          onPressed: () => _goToStep(AuthFlowStep.options),
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
    );
  }

  // STEP 3: OTP Verification
  Widget _buildOtpStep() {
    final emailDisplay = _emailController.text.trim().isEmpty
        ? 'your email'
        : _emailController.text.trim();

    return Column(
      key: const ValueKey('step_otp'),
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
          "We've sent a 4-digit verification code to $emailDisplay.",
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.subtitleGray,
          ),
        ),
        const SizedBox(height: 20),

        // 4-Digit OTP Entry Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: OtpInputRow(
            length: 4,
            onCompleted: (_) => _onVerifyOtp(),
          ),
        ),
        const SizedBox(height: 20),

        // Circular Timer
        CircularTimerWidget(
          remainingSeconds: _secondsRemaining,
          totalSeconds: 60,
          size: 88,
        ),
        const SizedBox(height: 16),

        // Resend text
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
          onPressed: _onVerifyOtp,
        ),
        const SizedBox(height: 10),

        // Back button to Email step
        TextButton(
          onPressed: () => _goToStep(AuthFlowStep.emailInput),
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
    );
  }
}
