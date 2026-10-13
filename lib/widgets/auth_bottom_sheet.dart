import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/email_input_screen.dart';
import '../core/theme/app_theme.dart';
import 'social_auth_button.dart';

/// Bottom sheet opened when clicking "Get Started" on the Onboarding screen.
class AuthBottomSheet extends StatelessWidget {
  const AuthBottomSheet({super.key});

  static Future<T?> show<T>(BuildContext context) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => const AuthBottomSheet(),
    );
  }

  void _onEmailAuth(BuildContext context) {
    Navigator.pop(context); // Close bottom sheet
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EmailInputScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 36),
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
            width: 44,
            height: 4.5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 24),

          // Google Button
          SocialAuthButton.google(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Continue with Google clicked')),
              );
            },
          ),
          const SizedBox(height: 14),

          // Apple Button
          SocialAuthButton.apple(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Continue with Apple clicked')),
              );
            },
          ),
          const SizedBox(height: 18),

          // OR divider
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

          // Continue with E-mail button
          TextButton.icon(
            onPressed: () => _onEmailAuth(context),
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
      ),
    );
  }
}
