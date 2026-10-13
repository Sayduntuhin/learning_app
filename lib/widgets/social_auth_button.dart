import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

enum SocialAuthType { google, apple }

/// Reusable social authentication button with standard branding.
class SocialAuthButton extends StatelessWidget {
  final SocialAuthType type;
  final VoidCallback? onPressed;

  const SocialAuthButton({
    super.key,
    required this.type,
    this.onPressed,
  });

  const SocialAuthButton.google({
    super.key,
    this.onPressed,
  }) : type = SocialAuthType.google;

  const SocialAuthButton.apple({
    super.key,
    this.onPressed,
  }) : type = SocialAuthType.apple;

  @override
  Widget build(BuildContext context) {
    final bool isGoogle = type == SocialAuthType.google;

    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(27),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(27),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isGoogle)
                  const Icon(Icons.g_mobiledata, size: 28, color: Color(0xFFEA4335))
                else
                  const Icon(Icons.apple, size: 22, color: Colors.black),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    isGoogle ? 'Continue with google' : 'Continue with Apple',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkNavy,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
