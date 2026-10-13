import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../assessment/voice_assessment_view.dart';

class SpeakView extends StatefulWidget {
  final String? userName;

  const SpeakView({
    super.key,
    this.userName,
  });

  @override
  State<SpeakView> createState() => _SpeakViewState();
}

class _SpeakViewState extends State<SpeakView> {
  int _selectedScenarioIndex = 0;

  final List<_ScenarioModel> _scenarios = const [
    _ScenarioModel(
      title: 'Daily Life',
      subtitle: 'Free-flowing talk about your routine',
      displaySubtitle: 'Free-flowing talk about your...',
      iconEmoji: '☕',
      duration: '3 min',
      isUnlocked: true,
      isActive: true,
    ),
    _ScenarioModel(
      title: 'Job Interview',
      subtitle: 'Answering common interview questions',
      displaySubtitle: 'Answering common interview...',
      iconEmoji: '💼',
      duration: '5 min',
      isUnlocked: false,
      isActive: false,
    ),
    _ScenarioModel(
      title: 'Travel & Dining',
      subtitle: 'Ordering food & asking for directions',
      displaySubtitle: 'Ordering food & asking for...',
      iconEmoji: '✈️',
      duration: '4 min',
      isUnlocked: false,
      isActive: false,
    ),
  ];

  void _onScenarioTap(int index) {
    final scenario = _scenarios[index];
    if (scenario.isUnlocked) {
      setState(() => _selectedScenarioIndex = index);
      _startSpeakingSession(scenario.title);
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.lock_outline_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Complete "${_scenarios[0].title}" to unlock ${scenario.title}!',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1E293B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _startSpeakingSession([String? scenarioTitle]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VoiceAssessmentView(
          userName: widget.userName,
          goal: scenarioTitle ?? _scenarios[_selectedScenarioIndex].title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Subtle ambient wave overlay matching design
        Positioned.fill(
          child: Opacity(
            opacity: 0.90,
            child: Image.asset(
              'assets/images/bg_waves.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ),
        ),

        // Ambient soft glowing accents
        Positioned(
          left: -40.w,
          top: 20.h,
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
          right: -30.w,
          top: 30.h,
          child: Container(
            width: 240.w,
            height: 240.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00E676).withValues(alpha: 0.08),
            ),
          ),
        ),
        Positioned(
          right: -40.w,
          bottom: 40.h,
          child: Container(
            width: 260.w,
            height: 260.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00D46A).withValues(alpha: 0.06),
            ),
          ),
        ),

        // Main Scrollable Content
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 110.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top AI Speaking Partner Hero Card
              _buildHeroCard(),

              SizedBox(height: 28.h),

              // Conversation Scenarios Section Header
              _buildSectionHeader(),

              SizedBox(height: 14.h),

              // Scenario Cards
              ...List.generate(_scenarios.length, (index) {
                final scenario = _scenarios[index];
                return _buildScenarioCard(scenario, index);
              }),
            ],
          ),
        ),
      ],
    );
  }

  /// Top AI Speaking Partner Vibrant Gradient Hero Card
  Widget _buildHeroCard() {
    return GestureDetector(
      onTap: () => _startSpeakingSession(),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26.r),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0056F6),
              Color(0xFF00A28E),
              Color(0xFF00D464),
            ],
            stops: [0.0, 0.58, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0056F6).withValues(alpha: 0.28),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: const Color(0xFF00D464).withValues(alpha: 0.18),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Avatar with glowing cyan ring + Title
            Row(
              children: [
                Container(
                  width: 52.w,
                  height: 52.w,
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF5EEAD4).withValues(alpha: 0.95),
                      width: 2.0,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/tutor_mission.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset(
                        'assets/images/tutor_portrait.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, trace) => const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    'AI Speaking Partner',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 18.h),

            // Speech Bubble Container
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.20),
                  width: 1.0,
                ),
              ),
              child: Text(
                '"Hey! Let\'s practice speaking today. Pick a scenario below or tap the microphone to start talking."',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.45,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section Header: "Conversation Scenarios" + "1 of 3 Unlocked" pill
  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Conversation Scenarios',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18.5.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
            letterSpacing: -0.3,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.5.h),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF2F6),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            '1 of 3 Unlocked',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
      ],
    );
  }

  /// Individual Scenario Card matching exact screenshot design
  Widget _buildScenarioCard(_ScenarioModel scenario, int index) {
    if (scenario.isUnlocked) {
      // Active / Unlocked Card with vibrant Blue-to-Green gradient border
      return GestureDetector(
        onTap: () => _onScenarioTap(index),
        child: Container(
          margin: EdgeInsets.only(bottom: 14.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF0056F6),
                Color(0xFF00D46A),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0056F6).withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: const Color(0xFF00D46A).withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(1.8), // Exact gradient border outline
          child: Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.2.r),
            ),
            child: Row(
              children: [
                // Icon Box (Coffee cup with soft mint background)
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8FAF1),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Center(
                    child: Text(
                      scenario.iconEmoji,
                      style: TextStyle(fontSize: 22.sp),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),

                // Title + "Active" badge + Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            scenario.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15.5.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 7.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'Active',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF15803D),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        scenario.displaySubtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),

                // "3 min" Green Pill + Chevron Right
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8FAF1),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Text(
                    scenario.duration,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF00B86B),
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF00C853),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Locked Scenario Card with subtle grey border & lock badges
    return GestureDetector(
      onTap: () => _onScenarioTap(index),
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: const Color(0xFFF1F5F9),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Box with circular lock badge at bottom right
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Center(
                    child: Text(
                      scenario.iconEmoji,
                      style: TextStyle(fontSize: 22.sp),
                    ),
                  ),
                ),
                Positioned(
                  right: -1,
                  bottom: -1,
                  child: Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF64748B),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.lock_rounded,
                        size: 8.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 14.w),

            // Title + Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scenario.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15.5.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    scenario.displaySubtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),

            // Lock Pill Badge (e.g. 🔒 5 min)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.lock_rounded,
                    size: 11,
                    color: Color(0xFF94A3B8),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    scenario.duration,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScenarioModel {
  final String title;
  final String subtitle;
  final String displaySubtitle;
  final String iconEmoji;
  final String duration;
  final bool isUnlocked;
  final bool isActive;

  const _ScenarioModel({
    required this.title,
    required this.subtitle,
    required this.displaySubtitle,
    required this.iconEmoji,
    required this.duration,
    required this.isUnlocked,
    this.isActive = false,
  });
}

