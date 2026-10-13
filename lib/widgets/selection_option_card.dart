import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

/// Reusable selection option card with green brand icon, title, and animated checkmark indicator.
class SelectionOptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectionOptionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: isSelected ? AppTheme.brandGradient : null,
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? AppTheme.primaryGreen.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: isSelected ? 12 : 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(isSelected ? 2.0 : 0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSelected ? 20 : 22),
        child: InkWell(
          borderRadius: BorderRadius.circular(isSelected ? 20 : 22),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isSelected ? 20 : 22),
              border: isSelected
                  ? null
                  : Border.all(color: Colors.grey.shade200, width: 1.2),
            ),
            child: Row(
              children: [
                // Green Icon container
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.primaryGreen,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),

                // Title
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15.5,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                      color: AppTheme.darkNavy,
                    ),
                  ),
                ),

                // Radio Indicator / Checkmark
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryGreen : Colors.grey.shade300,
                      width: 1.8,
                    ),
                  ),
                  child: isSelected
                      ? const Center(
                          child: Icon(
                            Icons.check,
                            size: 16,
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
