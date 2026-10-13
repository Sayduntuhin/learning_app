import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FloatingBottomNavBar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTabSelected;

  const FloatingBottomNavBar({
    super.key,
    required this.activeIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.09),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 1. Home
          _buildItem(
            index: 0,
            label: 'Home',
            inactiveIcon: const Icon(Icons.home_outlined, color: Color(0xFF94A3B8), size: 24),
            activeIcon: const Icon(Icons.home_rounded, color: Colors.white, size: 22),
          ),

          // 2. Practice (Card with 3 bars + star matching user's design)
          _buildItem(
            index: 1,
            label: 'Practice',
            inactiveIcon: const PracticeTabIcon(color: Color(0xFF94A3B8), size: 22),
            activeIcon: const PracticeTabIcon(color: Colors.white, size: 20),
          ),

          // 3. Speak
          _buildItem(
            index: 2,
            label: 'Speak',
            inactiveIcon: const Icon(Icons.record_voice_over_outlined, color: Color(0xFF94A3B8), size: 23),
            activeIcon: const Icon(Icons.record_voice_over_rounded, color: Colors.white, size: 21),
          ),

          // 4. Profile
          _buildItem(
            index: 3,
            label: 'Profile',
            inactiveIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF94A3B8), size: 24),
            activeIcon: const Icon(Icons.person_rounded, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required String label,
    required Widget inactiveIcon,
    required Widget activeIcon,
  }) {
    final isActive = activeIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: isActive
              ? Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF0066FF), Color(0xFF00D46A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x6600D46A),
                        blurRadius: 12,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      activeIcon,
                      const SizedBox(height: 1),
                      Text(
                        label,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    inactiveIcon,
                    const SizedBox(height: 2),
                    Text(
                      label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF94A3B8),
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Custom Practice tab icon (Card with 3 bars + star) matching user's design
class PracticeTabIcon extends StatelessWidget {
  final Color color;
  final double size;

  const PracticeTabIcon({
    super.key,
    required this.color,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Rounded mini card with 3 bar charts inside
          Positioned(
            left: 0,
            bottom: 1,
            child: Container(
              width: size * 0.78,
              height: size * 0.65,
              padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 1.6),
                borderRadius: BorderRadius.circular(3.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(width: 1.8, height: 4, color: color),
                  Container(width: 1.8, height: 7, color: color),
                  Container(width: 1.8, height: 9.5, color: color),
                ],
              ),
            ),
          ),
          // 4-point sparkle star on the top-right
          Positioned(
            right: -1,
            top: -1,
            child: Icon(
              Icons.star_rounded,
              color: color,
              size: size * 0.52,
            ),
          ),
        ],
      ),
    );
  }
}
