import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../models/daily_login_model.dart';
import '../../widgets/widgets.dart';

typedef DailyBadgeScreen = DailyBadgeView;

class DailyBadgeView extends StatefulWidget {
  final VoidCallback? onBack;
  final bool isEmbedded;

  const DailyBadgeView({
    super.key,
    this.onBack,
    this.isEmbedded = false,
  });

  @override
  State<DailyBadgeView> createState() => _DailyBadgeViewState();
}

class _DailyBadgeViewState extends State<DailyBadgeView> {
  final List<DailyLoginDay> _days = [
    DailyLoginDay(dayNumber: 1, title: 'Logged in day 1', isClaimed: false),
    DailyLoginDay(dayNumber: 2, title: 'Logged in day 2', isClaimed: false),
    DailyLoginDay(dayNumber: 3, title: 'Logged in day 3', isClaimed: false),
    DailyLoginDay(dayNumber: 4, title: 'Logged in day 4', isClaimed: false),
    DailyLoginDay(dayNumber: 5, title: 'Logged in day 5', isClaimed: false),
    DailyLoginDay(dayNumber: 6, title: 'Logged in day 6', isClaimed: false),
    DailyLoginDay(dayNumber: 7, title: 'Logged in day 7', isClaimed: false),
  ];

  void _onClaim(DailyLoginDay day) {
    if (day.isClaimed) return;

    setState(() {
      day.isClaimed = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Claimed ${day.title} bonus! +${day.xpReward} XP'),
        backgroundColor: AppTheme.primaryGreen,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEmbedded) {
      return _buildContent(context, isInsideFrame: false);
    }

    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 640;

    if (!isDesktop) {
      return Scaffold(
        body: _buildContent(context, isInsideFrame: false),
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
              child: _buildContent(context, isInsideFrame: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, {required bool isInsideFrame}) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          // Background subtle waves image
          Positioned.fill(
            child: Opacity(
              opacity: 0.9,
              child: Image.asset(
                'assets/images/bg_waves.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ),

          // Background ambient soft mint & blue blooms
          Positioned(
            right: -60,
            top: 40,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF10B981).withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            left: -50,
            top: 180,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF38BDF8).withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            left: -40,
            bottom: 80,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6366F1).withValues(alpha: 0.06),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            top: !isInsideFrame,
            bottom: !isInsideFrame,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: isInsideFrame ? 16 : 8),

                // Top Bar with Back Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.onBack != null) {
                            widget.onBack!();
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade200, width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: AppTheme.darkNavy,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Scrollable content containing Hero Badge & Daily List
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      children: [
                        // Hero 3D Badge Image with Glow
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Radial amber bloom
                              Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFF59E0B).withValues(alpha: 0.22),
                                      blurRadius: 36,
                                      spreadRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                              // 3D Badge Image
                              Image.asset(
                                'assets/images/daily_badge_without_bg.png',
                                width: 145.w,
                                height: 145.h,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 130.w,
                                  height: 130.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
                                    ),
                                    border: Border.all(color: const Color(0xFFFDE68A), width: 3),
                                  ),
                                  child: const Center(
                                    child: Text('🔥', style: TextStyle(fontSize: 64)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 6),

                        // "Daily Login" Oval Pill
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            'Daily Login',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Headline
                        Text(
                          'Claim Daily Login Badge',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.darkNavy,
                            letterSpacing: -0.3,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // List of Days
                        ..._days.map((day) => _buildDayCard(day)),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(DailyLoginDay day) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade100, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Soft pastel mint squircle with green scalloped check badge inside
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/check_badge.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF16A34A),
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Title
          Expanded(
            child: Text(
              day.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14.5.sp,
                fontWeight: FontWeight.w700,
                color: AppTheme.darkNavy,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Claim Button
          GestureDetector(
            onTap: () => _onClaim(day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.symmetric(
                horizontal: day.isClaimed ? 12 : 18,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                gradient: day.isClaimed
                    ? null
                    : const LinearGradient(
                        colors: [Color(0xFF0066FF), Color(0xFF00D46A)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                color: day.isClaimed ? const Color(0xFFF1F5F9) : null,
                borderRadius: BorderRadius.circular(20),
                boxShadow: day.isClaimed
                    ? null
                    : [
                        BoxShadow(
                          color: const Color(0xFF0066FF).withValues(alpha: 0.28),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
              ),
              child: Text(
                day.isClaimed ? 'Claimed ✓' : 'Claim',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w800,
                  color: day.isClaimed ? const Color(0xFF94A3B8) : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
