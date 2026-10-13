import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'practice_time_view.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/widgets.dart';

typedef LevelSelectionView = LevelSelectionScreen;

class LevelItem {
  final String title;
  final IconData icon;

  const LevelItem({required this.title, required this.icon});
}

class LevelSelectionScreen extends StatefulWidget {
  final String? userName;
  final String? language;
  final String? goal;

  const LevelSelectionScreen({
    super.key,
    this.userName,
    this.language,
    this.goal,
  });

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  int? _selectedIndex = 1; // "Elementary" initially highlighted (matches design)

  final List<LevelItem> _levels = const [
    LevelItem(title: 'Beginner', icon: Icons.record_voice_over_rounded),
    LevelItem(title: 'Elementary', icon: Icons.groups_rounded),
    LevelItem(title: 'Intermediate', icon: Icons.forum_rounded),
    LevelItem(title: 'Advanced', icon: Icons.luggage_rounded),
  ];

  void _onSelectLevel(int index) {
    setState(() {
      _selectedIndex = index;
    });

    final selectedLevel = _levels[index].title;
    debugPrint('[Fluentio] Level selected: $selectedLevel');

    Future.delayed(const Duration(milliseconds: 220), () {
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PracticeTimeScreen(
            userName: widget.userName,
            language: widget.language,
            goal: widget.goal,
            level: selectedLevel,
          ),
        ),
      );
    });
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

                        // [TOP ANIMATION] Logo Header & Progress Bar (Step 4 of 5)
                        FadeSlideTransition(
                          direction: SlideDirection.fromTop,
                          duration: const Duration(milliseconds: 500),
                          delay: const Duration(milliseconds: 50),
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
                                activeIndex: 3,
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
                                "What's your current\nEnglish level?",
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
                                "Don't worry — there's no wrong answer!",
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

                        // [RIGHT ANIMATION] Staggered Level Cards (Instant tap-to-advance)
                        ...List.generate(_levels.length, (index) {
                          final item = _levels[index];
                          final isSelected = _selectedIndex == index;

                          return FadeSlideTransition(
                            direction: SlideDirection.fromRight,
                            duration: const Duration(milliseconds: 500),
                            delay: Duration(milliseconds: 220 + (index * 70)),
                            child: SelectionOptionCard(
                              title: item.title,
                              icon: item.icon,
                              isSelected: isSelected,
                              onTap: () => _onSelectLevel(index),
                            ),
                          );
                        }),

                        const Spacer(),
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
}
