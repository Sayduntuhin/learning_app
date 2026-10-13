import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

import 'mission_exercise_view.dart';

class PracticeView extends StatelessWidget {
  final VoidCallback? onStartMission;
  final String language;

  const PracticeView({
    super.key,
    this.onStartMission,
    this.language = 'English',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
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

        // Background soft ambient glows
        Positioned(
          left: -40.w,
          top: 30.h,
          child: Container(
            width: 220.w,
            height: 220.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF38BDF8).withValues(alpha: 0.08),
            ),
          ),
        ),
        Positioned(
          right: -50.w,
          top: 180.h,
          child: Container(
            width: 260.w,
            height: 260.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF10B981).withValues(alpha: 0.07),
            ),
          ),
        ),

        // Scrollable Mission Content
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 100.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.h),
              // Hero Mission Card ("Workplace Basics")
              _buildHeroMissionCard(context),

              SizedBox(height: 30.h),

              // Mission Details List (Goal, Skill, Duration, Reward)
              _buildMissionDetailsList(),

              SizedBox(height: 0.12.sh),

              // "Start mission" Primary Action Button
              _buildStartMissionButton(context),
            ],
          ),
        ),
      ],
    );
  }

  // Hero Mission Card with Week Tag, Title, AI Tutor Portrait, XP, and Segmented Progress
  Widget _buildHeroMissionCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Corner accents (Cyan brackets on top-left and top-right)
          Positioned(
            left: 14.w,
            top: 14.h,
            child: _buildCornerAccent(isLeft: true),
          ),
          Positioned(
            right: 14.w,
            top: 14.h,
            child: _buildCornerAccent(isLeft: false),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Week 01 Tag + Workplace Basics + Tutor Photo
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // "WEEK 01" Green Capsule Pill
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00D46A),
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00D46A).withValues(alpha: 0.28),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  color: Colors.white,
                                  size: 13,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  'WEEK 01',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 12.h),

                          // Title: "Workplace Basics"
                          Text(
                            'Workplace\nBasics',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.darkNavy,
                              height: 1.15,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // AI Tutor Portrait Avatar with Soft Halo
                    Container(
                      width: 78.w,
                      height: 78.w,
                      padding: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFBAE6FD), Color(0xFFBBF7D0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0284C7).withValues(alpha: 0.16),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/tutor_mission.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            'assets/images/tutor_portrait.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: const Color(0xFFE0F2FE),
                              child: const Icon(Icons.person, color: AppTheme.primaryBlue),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Stats Badges Wrap: XP Pill + Level Pill
                Wrap(
                  spacing: 8.w,
                  runSpacing: 6.h,
                  children: [
                    // "155 XP" Pill
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFFFDE68A), width: 1.2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('⚡', style: TextStyle(fontSize: 12)),
                          SizedBox(width: 4.w),
                          Text(
                            '155 XP',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF92400E),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // "Level 1" Pill with Game Controller Icon
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFF93C5FD), width: 1.2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🎮', style: TextStyle(fontSize: 12)),
                          SizedBox(width: 4.w),
                          Text(
                            'Level 1',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1E40AF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14.h),

                // 5-Segment Progress Bar
                _buildSegmentedProgressBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Segmented Progress Bar matching the screenshot
  Widget _buildSegmentedProgressBar() {
    return Row(
      children: List.generate(5, (index) {
        final isFilled = index == 0;
        final isHalfFilled = index == 1;

        return Expanded(
          child: Container(
            height: 5.5.h,
            margin: EdgeInsets.only(right: index == 4 ? 0 : 5.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              gradient: isFilled
                  ? const LinearGradient(
                      colors: [Color(0xFF0055FF), Color(0xFF00D46A)],
                    )
                  : isHalfFilled
                      ? const LinearGradient(
                          colors: [Color(0xFF00D46A), Color(0xFF86EFAC)],
                        )
                      : null,
              color: (!isFilled && !isHalfFilled) ? const Color(0xFFE2E8F0) : null,
            ),
          ),
        );
      }),
    );
  }

  // Corner Accent Brackets for Hero Card
  Widget _buildCornerAccent({required bool isLeft}) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        border: Border(
          top: const BorderSide(color: Color(0xFF38BDF8), width: 2.2),
          left: isLeft ? const BorderSide(color: Color(0xFF38BDF8), width: 2.2) : BorderSide.none,
          right: !isLeft ? const BorderSide(color: Color(0xFF38BDF8), width: 2.2) : BorderSide.none,
        ),
      ),
    );
  }

  // Mission Details List (Goal, Skill, Duration, Reward)
  Widget _buildMissionDetailsList() {
    final items = [
      _MissionDetailItem(
        label: 'GOAL',
        description: 'Talk about what you love doing in your free time.',
      ),
      _MissionDetailItem(
        label: 'SKILL',
        description: 'Fluency + Vocabulary',
      ),
      _MissionDetailItem(
        label: 'DURATION',
        description: 'About 5 minutes',
      ),
      _MissionDetailItem(
        label: 'REWARD',
        description: '+25 XP + Streak bonus',
      ),
    ];

    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _buildDetailRow(items[i]),
          if (i != items.length - 1)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              child: Divider(
                color: Colors.grey.shade100,
                thickness: 1.2,
                height: 1,
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildDetailRow(_MissionDetailItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Soft pastel mint squircle with green scalloped check badge inside
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/check_badge.png',
              width: 22.w,
              height: 22.w,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.check_rounded,
                color: Color(0xFF16A34A),
                size: 18,
              ),
            ),
          ),
        ),

        SizedBox(width: 14.w),

        // Label and Description
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.darkNavy,
                  letterSpacing: 0.6,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                item.description,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.subtitleGray,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Radiant Gradient "Start mission" Button
  Widget _buildStartMissionButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onStartMission != null) {
          onStartMission!();
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MissionExerciseView(language: language),
            ),
          );
        }
      },
      child: Container(
        height: 54.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0055FF), Color(0xFF00D46A)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(27.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0055FF).withValues(alpha: 0.32),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Start mission',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16.5.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}

class _MissionDetailItem {
  final String label;
  final String description;

  const _MissionDetailItem({
    required this.label,
    required this.description,
  });
}
