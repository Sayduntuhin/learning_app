import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'onboarding_complete_view.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/widgets.dart';

typedef PracticeTimeView = PracticeTimeScreen;

class PracticeTimeItem {
  final String title;
  final IconData icon;

  const PracticeTimeItem({required this.title, required this.icon});
}

class PracticeTimeScreen extends StatefulWidget {
  final String? userName;
  final String? language;
  final String? goal;
  final String? level;

  const PracticeTimeScreen({
    super.key,
    this.userName,
    this.language,
    this.goal,
    this.level,
  });

  @override
  State<PracticeTimeScreen> createState() => _PracticeTimeScreenState();
}

class _PracticeTimeScreenState extends State<PracticeTimeScreen> {
  int? _selectedIndex = 1; // "3 min" initially highlighted (matches design)

  final List<PracticeTimeItem> _times = const [
    PracticeTimeItem(title: '1 min', icon: Icons.timer_outlined),
    PracticeTimeItem(title: '3 min', icon: Icons.timer_outlined),
    PracticeTimeItem(title: '5 min', icon: Icons.timer_outlined),
    PracticeTimeItem(title: '10+ min', icon: Icons.timer_outlined),
  ];

  void _onSelectTime(int index) {
    setState(() {
      _selectedIndex = index;
    });

    final selectedTime = _times[index].title;
    debugPrint('[Fluentio] Practice time selected: $selectedTime');

    Future.delayed(const Duration(milliseconds: 220), () {
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OnboardingCompleteScreen(
            userName: widget.userName,
            language: widget.language,
            goal: widget.goal,
            level: widget.level,
            practiceTime: selectedTime,
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

                        // [TOP ANIMATION] Logo Header & Progress Bar (Step 5 of 5)
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
                                "How much time can you\npractice?",
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
                                "Even 5 minutes a day makes a big difference!",
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

                        // [RIGHT ANIMATION] Staggered Practice Time Cards (Instant tap-to-advance)
                        ...List.generate(_times.length, (index) {
                          final item = _times[index];
                          final isSelected = _selectedIndex == index;

                          return FadeSlideTransition(
                            direction: SlideDirection.fromRight,
                            duration: const Duration(milliseconds: 500),
                            delay: Duration(milliseconds: 220 + (index * 70)),
                            child: SelectionOptionCard(
                              title: item.title,
                              icon: item.icon,
                              isSelected: isSelected,
                              onTap: () => _onSelectTime(index),
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
