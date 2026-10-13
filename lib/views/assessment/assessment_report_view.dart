import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home_view.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/widgets.dart';

typedef AssessmentReportView = AssessmentReportScreen;

class SkillScore {
  final String name;
  final String icon;
  final int percentage;
  final Color color;

  const SkillScore({
    required this.name,
    required this.icon,
    required this.percentage,
    required this.color,
  });
}

class SuggestionItem {
  final IconData icon;
  final String title;
  final String description;

  const SuggestionItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class AssessmentReportScreen extends StatefulWidget {
  final String? userName;
  final String? language;
  final String? goal;
  final String? level;
  final String? practiceTime;

  const AssessmentReportScreen({
    super.key,
    this.userName,
    this.language,
    this.goal,
    this.level,
    this.practiceTime,
  });

  @override
  State<AssessmentReportScreen> createState() => _AssessmentReportScreenState();
}

class _AssessmentReportScreenState extends State<AssessmentReportScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressAnimController;
  late final Animation<double> _progressAnimation;

  final List<SkillScore> _skills = const [
    SkillScore(
      name: 'Fluency',
      icon: '🗣️',
      percentage: 68,
      color: Color(0xFF6366F1), // Indigo
    ),
    SkillScore(
      name: 'Grammar',
      icon: '📝',
      percentage: 54,
      color: Color(0xFFEF4444), // Coral Red
    ),
    SkillScore(
      name: 'Vocabulary',
      icon: '📚',
      percentage: 72,
      color: Color(0xFF10B981), // Emerald
    ),
    SkillScore(
      name: 'Pronunciation',
      icon: '🎵',
      percentage: 61,
      color: Color(0xFFF59E0B), // Amber
    ),
  ];

  final List<SuggestionItem> _suggestions = const [
    SuggestionItem(
      icon: Icons.track_changes_rounded,
      title: 'Practice daily sentences',
      description: 'Build grammar confidence with 5-min drills',
    ),
    SuggestionItem(
      icon: Icons.mic_rounded,
      title: 'Shadow native speakers',
      description: 'Mimic rhythm and pronunciation patterns',
    ),
    SuggestionItem(
      icon: Icons.chat_bubble_outline_rounded,
      title: 'Speak without translating',
      description: 'Think directly in English to boost fluency',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _progressAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _progressAnimation = CurvedAnimation(
      parent: _progressAnimController,
      curve: Curves.easeOutCubic,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _progressAnimController.forward();
      }
    });
  }

  @override
  void dispose() {
    _progressAnimController.dispose();
    super.dispose();
  }

  void _onStartJourney() {
    debugPrint('[Fluentio] Starting journey -> Navigating to HomeScreen...');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          userName: widget.userName,
          language: widget.language,
          level: widget.level,
        ),
      ),
    );
  }

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
    final displayName = (widget.userName != null && widget.userName!.trim().isNotEmpty)
        ? widget.userName!.trim()
        : 'Alex';

    return Container(
      color: Colors.white,
      child: BackgroundWaves(
        child: SafeArea(
          top: !isInsideFrame,
          bottom: !isInsideFrame,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: isInsideFrame ? 16 : 8),

                // [TOP ANIMATION] Coach Avatar & Header
                FadeSlideTransition(
                  direction: SlideDirection.fromTop,
                  duration: const Duration(milliseconds: 550),
                  child: Column(
                    children: [
                      // AI Coach Avatar
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryGreen.withValues(alpha: 0.2),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/tutor_portrait.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              'assets/images/avatars/avatar_4.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Accent Tag: "YOUR AI SPEAKING COACH"
                      Text(
                        'YOUR AI SPEAKING COACH',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0284C7),
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Headline: "Great job, Alex!"
                      Text(
                        'Great job, $displayName!',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.darkNavy,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Subtitle
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '"I have analyzed your speaking. Here is your personalized English level report!"',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppTheme.subtitleGray,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // [LEFT ANIMATION] Level & Score Hero Card
                FadeSlideTransition(
                  direction: SlideDirection.fromLeft,
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 150),
                  child: _buildScoreCard(),
                ),

                const SizedBox(height: 16),

                // [RIGHT ANIMATION] Skill Breakdown Card
                FadeSlideTransition(
                  direction: SlideDirection.fromRight,
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 230),
                  child: _buildSkillBreakdownCard(),
                ),

                const SizedBox(height: 20),

                // [LEFT ANIMATION] AI Coach Suggests Section
                FadeSlideTransition(
                  direction: SlideDirection.fromLeft,
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 300),
                  child: _buildSuggestionsSection(),
                ),

                const SizedBox(height: 24),

                // [BOTTOM ANIMATION] Start My Journey Button
                FadeSlideTransition(
                  direction: SlideDirection.fromBottom,
                  duration: const Duration(milliseconds: 550),
                  delay: const Duration(milliseconds: 380),
                  child: GradientButton(
                    text: 'Start my journey',
                    onPressed: _onStartJourney,
                  ),
                ),

                SizedBox(height: isInsideFrame ? 24 : 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade100, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Medal Icon Badge
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                '🏅',
                style: TextStyle(fontSize: 26),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Level & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YOUR LEVEL',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryGreen,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.level != null ? '${widget.level} B1' : 'Elementary B1',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.darkNavy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Overall score: 64 / 100',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.subtitleGray,
                  ),
                ),
              ],
            ),
          ),

          // Big Score Badge (64 SCORE)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '64',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0284C7),
                  height: 1,
                ),
              ),
              Text(
                'SCORE',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.subtitleGray,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillBreakdownCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade100, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'SKILL BREAKDOWN',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryGreen,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 16),

          // Skills List
          ..._skills.map((skill) => _buildSkillRow(skill)),
        ],
      ),
    );
  }

  Widget _buildSkillRow(SkillScore skill) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            children: [
              Text(skill.icon, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 8),
              Text(
                skill.name,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkNavy,
                ),
              ),
              const Spacer(),
              Text(
                '${skill.percentage}%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: skill.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),

          // Animated Progress Bar
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              final animatedValue = (skill.percentage / 100) * _progressAnimation.value;
              return Container(
                height: 6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: animatedValue.clamp(0.01, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: skill.color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Mini Avatar
        Row(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/tutor_portrait.jpg',
                width: 22,
                height: 22,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.psychology_rounded,
                  color: AppTheme.primaryBlue,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'AI COACH SUGGESTS',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0284C7),
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 3 Suggestion Cards
        ..._suggestions.map((item) => _buildSuggestionCard(item)),
      ],
    );
  }

  Widget _buildSuggestionCard(SuggestionItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade100, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Green Icon Bubble
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.icon,
              color: AppTheme.primaryGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),

          // Title & Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.darkNavy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: AppTheme.subtitleGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
