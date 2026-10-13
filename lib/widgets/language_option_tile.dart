import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import 'flag_icon_widget.dart';

/// Reusable selectable language tile matching the modern Fluentio design:
/// - Rounded rectangular flag badge
/// - Language name with optional English/native subtitle in parentheses
/// - Crisp radio or green checkmark badge
/// - Selected state with active emerald border
class LanguageOptionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final CountryFlag flag;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageOptionTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  bool _containsBengali(String text) {
    for (final rune in text.runes) {
      if (rune >= 0x0980 && rune <= 0x09FF) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final hasBengali = _containsBengali(title);

    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        border: Border.all(
          color: isSelected ? AppTheme.primaryGreen : const Color(0xFFE2E8F0),
          width: isSelected ? 1.6 : 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? AppTheme.primaryGreen.withValues(alpha: 0.12)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: isSelected ? 12 : 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              children: [
                // Country Flag (Rounded rectangle badge)
                FlagIconWidget(
                  flag: flag,
                  width: 38,
                  height: 26,
                  borderRadius: 5,
                ),
                const SizedBox(width: 14),

                // Language Name & Subtitle
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: hasBengali
                              ? GoogleFonts.hindSiliguri(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.darkNavy,
                                  height: 1.2,
                                )
                              : GoogleFonts.plusJakartaSans(
                                  fontSize: 15.5,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                                  color: AppTheme.darkNavy,
                                ),
                        ),
                      ),
                      if (subtitle != null && subtitle!.isNotEmpty) ...[
                        const SizedBox(width: 5),
                        Text(
                          '($subtitle)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.subtitleGray,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Radio / Checkmark Indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryGreen : const Color(0xFFCBD5E1),
                      width: 1.6,
                    ),
                  ),
                  child: isSelected
                      ? const Center(
                          child: Icon(
                            Icons.check_rounded,
                            size: 15,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
