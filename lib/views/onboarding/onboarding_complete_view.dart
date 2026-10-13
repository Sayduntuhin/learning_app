import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../assessment/voice_assessment_view.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/widgets.dart';

typedef OnboardingCompleteView = OnboardingCompleteScreen;

class OnboardingCompleteScreen extends StatelessWidget {
  final String? userName;
  final String? language;
  final String? goal;
  final String? level;
  final String? practiceTime;

  const OnboardingCompleteScreen({
    super.key,
    this.userName,
    this.language,
    this.goal,
    this.level,
    this.practiceTime,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 640;

    if (!isDesktop) {
      return Scaffold(
        body: _buildScreenContent(context, isInsideFrame: false),
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
              child: _buildScreenContent(context, isInsideFrame: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenContent(BuildContext context, {required bool isInsideFrame}) {
    final name = (userName != null && userName!.trim().isNotEmpty) ? userName!.trim() : 'Learner';

    return Container(
      color: Colors.white,
      child: BackgroundWaves(
        child: SafeArea(
          top: !isInsideFrame,
          bottom: !isInsideFrame,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: isInsideFrame ? 24 : 16),

                        // [TOP ANIMATION] Logo Header & 100% Progress Bar (Step 5 of 5)
                        FadeSlideTransition(
                          direction: SlideDirection.fromTop,
                          duration: const Duration(milliseconds: 500),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: FluentioLogo.full(height: 52),
                              ),
                              SizedBox(height: 18),
                              SegmentedProgressBar(
                                totalSegments: 5,
                                activeIndex: 4,
                                height: 4.5,
                                spacing: 6,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // [LEFT ANIMATION] Headline & Subtitle
                        FadeSlideTransition(
                          direction: SlideDirection.fromLeft,
                          duration: const Duration(milliseconds: 550),
                          delay: const Duration(milliseconds: 140),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "You're all set,\n$name!",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.darkNavy,
                                  height: 1.25,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Your personalized English journey is ready to explore.",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.subtitleGray,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // [RIGHT ANIMATION] Personalized Path Summary Cards
                        FadeSlideTransition(
                          direction: SlideDirection.fromRight,
                          duration: const Duration(milliseconds: 500),
                          delay: const Duration(milliseconds: 180),
                          child: _buildSummaryCard(
                            title: 'Target Language',
                            value: language ?? 'German',
                            icon: Icons.language_rounded,
                            color: const Color(0xFF6366F1),
                          ),
                        ),
                        const SizedBox(height: 12),

                        FadeSlideTransition(
                          direction: SlideDirection.fromRight,
                          duration: const Duration(milliseconds: 500),
                          delay: const Duration(milliseconds: 260),
                          child: _buildSummaryCard(
                            title: 'Learning Focus',
                            value: goal ?? 'Job interviews',
                            icon: Icons.track_changes_rounded,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 12),

                        FadeSlideTransition(
                          direction: SlideDirection.fromRight,
                          duration: const Duration(milliseconds: 500),
                          delay: const Duration(milliseconds: 340),
                          child: _buildSummaryCard(
                            title: 'Starting Level',
                            value: level ?? 'Elementary',
                            icon: Icons.trending_up_rounded,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 12),

                        FadeSlideTransition(
                          direction: SlideDirection.fromRight,
                          duration: const Duration(milliseconds: 500),
                          delay: const Duration(milliseconds: 420),
                          child: _buildSummaryCard(
                            title: 'Daily Goal',
                            value: '${practiceTime ?? "3 min"} / day',
                            icon: Icons.timer_rounded,
                            color: const Color(0xFFF59E0B),
                          ),
                        ),

                        const Spacer(),
                        const SizedBox(height: 24),

                        // [BOTTOM ANIMATION] Start Learning CTA
                        FadeSlideTransition(
                          direction: SlideDirection.fromBottom,
                          duration: const Duration(milliseconds: 550),
                          delay: const Duration(milliseconds: 460),
                          child: GradientButton(
                            text: 'Start Learning',
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => VoiceAssessmentScreen(
                                    userName: userName,
                                    language: language,
                                    goal: goal,
                                    level: level,
                                    practiceTime: practiceTime,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: isInsideFrame ? 28 : 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.subtitleGray,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.darkNavy,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: AppTheme.primaryGreen,
            size: 24,
          ),
        ],
      ),
    );
  }
}
