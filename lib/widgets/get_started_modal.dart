import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import 'fluentio_logo_widget.dart';
import 'gradient_button.dart';

/// Reusable modal bottom sheet for onboarding / registration / welcome flows.
class GetStartedModal extends StatelessWidget {
  final VoidCallback? onGoogleSignUp;
  final VoidCallback? onEmailSignUp;

  const GetStartedModal({
    super.key,
    this.onGoogleSignUp,
    this.onEmailSignUp,
  });

  static Future<T?> show<T>(BuildContext context) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => const GetStartedModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 24),

          // Logo
          const FluentioLogo.icon(height: 55),
          const SizedBox(height: 16),

          Text(
            'Welcome to Fluentio!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppTheme.darkNavy,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            'Start your journey to fluent English today. No credit card required.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppTheme.subtitleGray,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),

          // Google Auth Button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: onGoogleSignUp ?? () => Navigator.pop(context),
              icon: const Icon(Icons.g_mobiledata, size: 28, color: Colors.blue),
              label: Text(
                'Continue with Google',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkNavy,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade50,
                elevation: 0,
                side: BorderSide(color: Colors.grey.shade200, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Email Sign Up Button
          GradientButton(
            text: 'Sign Up with Email',
            height: 54,
            onPressed: onEmailSignUp ?? () => Navigator.pop(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
