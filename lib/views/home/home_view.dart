import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/widgets.dart';
import '../badge/daily_badge_view.dart';
import '../practice/practice_view.dart';
import '../practice/mission_exercise_view.dart';
import '../profile/profile_view.dart';
import '../speak/speak_view.dart';

typedef HomeView = HomeScreen;

class RoadmapNode {
  final int level;
  final String title;
  final bool isCompleted;
  final bool isLocked;
  final bool isGoal;
  final int stars; // 0 to 3 stars
  final double xPercent; // 0.0 to 1.0 relative to screen width
  final double yOffset; // y position in roadmap canvas

  const RoadmapNode({
    required this.level,
    required this.title,
    this.isCompleted = false,
    this.isLocked = false,
    this.isGoal = false,
    this.stars = 0,
    required this.xPercent,
    required this.yOffset,
  });
}

class HomeScreen extends StatefulWidget {
  final String? userName;
  final String? language;
  final String? level;

  const HomeScreen({
    super.key,
    this.userName,
    this.language,
    this.level,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  int _activeNavIndex = 0; // 0: Home, 1: Practice, 2: Speak, 3: Profile
  bool _showingDailyBadge = false;
  late String _currentLanguage;
  late CountryFlag _currentFlag;

  // Scroll Controller to initially center on Level 1 & Level 2
  final ScrollController _scrollController = ScrollController(initialScrollOffset: 960.0);

  // Animation Controllers for Path Drawing & Pulsing
  late final AnimationController _entryAnimController;
  late final AnimationController _pulseAnimController;
  late final Animation<double> _pathDrawAnimation;

  // 8 Roadmap nodes matching user's exact image shape (iPhone 16 - 115) with 3D stars
  final List<RoadmapNode> _nodes = const [
    // Top Goal (Top center-left next to Daily badge)
    RoadmapNode(
      level: 8,
      title: 'GOAL',
      isGoal: true,
      xPercent: 0.39,
      yOffset: 75,
    ),
    // Level 7 (Upper right)
    RoadmapNode(
      level: 7,
      title: 'Level 7',
      isLocked: true,
      xPercent: 0.86,
      yOffset: 250,
    ),
    // Level 6 (Upper middle)
    RoadmapNode(
      level: 6,
      title: 'Level 6',
      isLocked: true,
      xPercent: 0.52,
      yOffset: 310,
    ),
    // Level 5 (Middle left)
    RoadmapNode(
      level: 5,
      title: 'Level 5',
      isLocked: true,
      xPercent: 0.16,
      yOffset: 410,
    ),
    // Level 4 (Center)
    RoadmapNode(
      level: 4,
      title: 'Level 4',
      isLocked: true,
      xPercent: 0.48,
      yOffset: 500,
    ),
    // Level 3 (Right)
    RoadmapNode(
      level: 3,
      title: 'Level 3',
      isLocked: true,
      xPercent: 0.85,
      yOffset: 570,
    ),
    // Level 2 (Active / Completed - In Progress with 2 stars)
    RoadmapNode(
      level: 2,
      title: 'Level 2',
      isCompleted: true,
      stars: 2,
      xPercent: 0.56,
      yOffset: 720,
    ),
    // Level 1 (Completed with full 3 stars)
    RoadmapNode(
      level: 1,
      title: 'Level 1',
      isCompleted: true,
      stars: 3,
      xPercent: 0.24,
      yOffset: 835,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentLanguage = widget.language ?? 'English';
    _currentFlag = _flagForLanguage(_currentLanguage);

    _scrollToLevelOne();

    // 1. Entry Animation: Winding path draws smoothly from bottom to top
    _entryAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _pathDrawAnimation = CurvedAnimation(
      parent: _entryAnimController,
      curve: Curves.easeInOutCubic,
    );

    // 2. Pulse / Levitation Animation for Active Level, Next lesson button, & Goal
    _pulseAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _entryAnimController.forward().then((_) {
      if (mounted) {
        _pulseAnimController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _entryAnimController.dispose();
    _pulseAnimController.dispose();
    super.dispose();
  }

  void _scrollToLevelOne() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  CountryFlag _flagForLanguage(String lang) {
    switch (lang.toLowerCase()) {
      case 'german':
        return CountryFlag.germany;
      case 'russia':
        return CountryFlag.russia;
      case 'spanish':
        return CountryFlag.spain;
      case 'portugal':
        return CountryFlag.portugal;
      case 'english':
      default:
        return CountryFlag.uk;
    }
  }

  String _codeForLanguage(String lang) {
    switch (lang.toLowerCase()) {
      case 'german':
        return 'DE';
      case 'russia':
        return 'RU';
      case 'spanish':
        return 'ES';
      case 'portugal':
        return 'PT';
      case 'english':
      default:
        return 'EN';
    }
  }

  void _onNodeTap(RoadmapNode node) {
    if (node.isGoal) {
      _showGoalSheet();
    } else if (node.isLocked) {
      _showLockedDialog(node.title);
    } else {
      _showLessonSheet(node.title);
    }
  }

  void _showLessonSheet(String levelTitle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4.5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00E575), Color(0xFF00B853)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryGreen.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.school_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            levelTitle,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.darkNavy,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'ACTIVE',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF15803D),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Essential Conversation & Pronunciation',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppTheme.subtitleGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GradientButton(
              text: 'Start Lesson',
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MissionExerciseView(
                      language: _currentLanguage,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showGoalSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4.5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              '🏆 Fluency Milestone Goal',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete all 7 levels to unlock complete speaking fluency and earn your Fluentio Certificate!',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppTheme.subtitleGray,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            GradientButton(
              text: 'Got it',
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  void _showLockedDialog(String levelTitle) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.lock_rounded, color: Color(0xFF94A3B8), size: 26),
            const SizedBox(width: 10),
            Text(
              '$levelTitle Locked',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                color: AppTheme.darkNavy,
              ),
            ),
          ],
        ),
        content: Text(
          'Complete previous levels to unlock this speaking lesson.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: AppTheme.subtitleGray,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'OK',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker() {
    final languages = [
      {'name': 'English', 'flag': CountryFlag.uk, 'code': 'EN'},
      {'name': 'German', 'flag': CountryFlag.germany, 'code': 'DE'},
      {'name': 'Russia', 'flag': CountryFlag.russia, 'code': 'RU'},
      {'name': 'Spanish', 'flag': CountryFlag.spain, 'code': 'ES'},
      {'name': 'Portugal', 'flag': CountryFlag.portugal, 'code': 'PT'},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Switch Learning Language',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.darkNavy,
              ),
            ),
            const SizedBox(height: 12),
            ...languages.map((item) {
              final isSelected = item['name'] == _currentLanguage;
              return ListTile(
                leading: FlagIconWidget(
                  flag: item['flag'] as CountryFlag,
                  size: 32,
                ),
                title: Text(
                  item['name'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? AppTheme.primaryGreen : AppTheme.darkNavy,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle_rounded, color: AppTheme.primaryGreen)
                    : null,
                onTap: () {
                  setState(() {
                    _currentLanguage = item['name'] as String;
                    _currentFlag = item['flag'] as CountryFlag;
                  });
                  Navigator.pop(ctx);
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 640;
    final displayName = (widget.userName != null && widget.userName!.trim().isNotEmpty)
        ? widget.userName!.trim()
        : 'Alex';

    if (!isDesktop) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAFCFF),
        extendBody: true,
        body: Stack(
          children: [
            const Positioned.fill(
              child: _RoadmapBackgroundDecoration(),
            ),
            SafeArea(
              top: true,
              bottom: false,
              child: _showingDailyBadge
                  ? DailyBadgeView(
                      onBack: () {
                        setState(() => _showingDailyBadge = false);
                        _scrollToLevelOne();
                      },
                      isEmbedded: true,
                    )
                  : _buildTabBody(displayName, false),
            ),
          ],
        ),
        bottomNavigationBar: _showingDailyBadge
            ? null
            : SafeArea(
                top: false,
                left: false,
                right: false,
                bottom: true,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
                  child: FloatingBottomNavBar(
                    activeIndex: _activeNavIndex,
                    onTabSelected: (index) {
                      setState(() {
                        _activeNavIndex = index;
                        _showingDailyBadge = false;
                      });
                      if (index == 0) {
                        _scrollToLevelOne();
                      }
                    },
                  ),
                ),
              ),
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
              child: _buildDesktopScreenContent(context, displayName),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopScreenContent(BuildContext context, String displayName) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFFAFCFF),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(
            child: _RoadmapBackgroundDecoration(),
          ),
          SafeArea(
            top: false,
            bottom: false,
            child: _showingDailyBadge
                ? DailyBadgeView(
                    onBack: () {
                      setState(() => _showingDailyBadge = false);
                      _scrollToLevelOne();
                    },
                    isEmbedded: true,
                  )
                : _buildTabBody(displayName, true),
          ),
          if (!_showingDailyBadge)
            Positioned(
              left: 20.w,
              right: 20.w,
              bottom: 20.h,
              child: FloatingBottomNavBar(
                activeIndex: _activeNavIndex,
                onTabSelected: (index) {
                  setState(() {
                    _activeNavIndex = index;
                    _showingDailyBadge = false;
                  });
                  if (index == 0) {
                    _scrollToLevelOne();
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabBody(String displayName, bool isInsideFrame) {
    switch (_activeNavIndex) {
      case 1:
        return PracticeView(
          language: _currentLanguage,
        );
      case 2:
        return SpeakView(userName: widget.userName);
      case 3:
        return ProfileView(
          userName: widget.userName,
          language: _currentLanguage,
        );
      case 0:
      default:
        return _buildHomeRoadmapTab(displayName, isInsideFrame);
    }
  }

  Widget _buildHomeRoadmapTab(String displayName, bool isInsideFrame) {
    return Column(
      children: [
        SizedBox(height: isInsideFrame ? 16 : 8),

                // Top Header Row with Modern HUD Stat Badges
                FadeSlideTransition(
                  direction: SlideDirection.fromTop,
                  duration: const Duration(milliseconds: 550),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        // User Avatar with Radiant Ring
                        Container(
                          width: 44.w,
                          height: 44.w,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF38BDF8), Color(0xFF00D46A)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryBlue.withValues(alpha: 0.20),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/avatars/avatar_0.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: const Color(0xFFE0F2FE),
                                child: const Icon(Icons.person, color: AppTheme.primaryBlue),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        // "Hey Alex"
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hey $displayName',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.darkNavy,
                                  height: 1.1,
                                ),
                              ),
                              Text(
                                'Ready to speak?',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.subtitleGray,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Language Selector Pill with micro-glassmorphism
                        GestureDetector(
                          onTap: _showLanguagePicker,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade200, width: 1.2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FlagIconWidget(
                                  flag: _currentFlag,
                                  size: 18,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  _codeForLanguage(_currentLanguage),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.darkNavy,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppTheme.subtitleGray,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Roadmap Canvas Area with Extra Bottom Padding for Floating Nav
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const double totalCanvasHeight = 960.0;

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // 1. Scrollable Roadmap Canvas
                          SingleChildScrollView(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 70), // Clean compact spacing above nav bar
                            child: SizedBox(
                              height: totalCanvasHeight,
                              width: constraints.maxWidth,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  // Custom Animated Painted Winding Path Lines with Luminous Glow
                                  Positioned.fill(
                                    child: AnimatedBuilder(
                                      animation: _pathDrawAnimation,
                                      builder: (context, child) {
                                        return CustomPaint(
                                          painter: _ModernRoadmapPathPainter(
                                            nodes: _nodes,
                                            width: constraints.maxWidth,
                                            progress: _pathDrawAnimation.value,
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  // Render All 8 Roadmap Nodes with 3D tactile buttons
                                  ..._nodes.map(
                                    (node) => _buildAnimatedNodeWidget(node, constraints.maxWidth),
                                  ),

                                  // // "Next lesson" Modern Floating Pill Button (Centered below Level 2)
                                  // Positioned(
                                  //   left: (constraints.maxWidth * 0.50) - 60,
                                  //   top: 890,
                                  //   child: _buildNextLessonPill(),
                                  // ),
                                ],
                              ),
                            ),
                          ),

                          // 2. Daily Badge Widget (Pinned in the Up Stack - Always Visible when scrolling!)
                          Positioned(
                            left: 18,
                            top: 4,
                            child: _buildDailyBadge(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }

  void _onDailyBadgeTap() {
    setState(() {
      _showingDailyBadge = true;
    });
  }

  // Daily Badge Widget with 3D Calendar Flame and Streak Tag
  Widget _buildDailyBadge() {
    return AnimatedBuilder(
      animation: _pulseAnimController,
      builder: (context, child) {
        final floatOffset = math.sin(_pulseAnimController.value * math.pi) * 2.5;
        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: _onDailyBadgeTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.30),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/daily_login_badge.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Text(
                      '🔥',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFDBEAFE), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                'Daily Badge',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2563EB),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modern "Next Lesson" Floating Button with Speech Pointer & Forward Arrow
  // ignore: unused_element
  Widget _buildNextLessonPill() {
    return AnimatedBuilder(
      animation: _pulseAnimController,
      builder: (context, child) {
        final scale = 1.0 + (_pulseAnimController.value * 0.04);
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () => _showLessonSheet('Level 2'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Speech pointer bubble tick pointing up to Level 2
            CustomPaint(
              size: const Size(14, 7),
              painter: _TrianglePointerPainter(color: Colors.white),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
                //border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Next lesson',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryGreen,
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

  // Animated Node Component with Staggered Entrance & Modern 3D Tactile Buttons
  Widget _buildAnimatedNodeWidget(RoadmapNode node, double screenWidth) {
    final double posX = (screenWidth * node.xPercent) - 30;
    final double posY = node.yOffset - 30;

    // Staggered pop-in sequence from Level 1 up to GOAL
    final nodeIndex = 8 - node.level; // 0 for Level 1, 7 for Goal
    final startInterval = (nodeIndex * 0.08).clamp(0.0, 0.7);
    final endInterval = (startInterval + 0.35).clamp(0.1, 1.0);

    final scaleAnimation = CurvedAnimation(
      parent: _entryAnimController,
      curve: Interval(startInterval, endInterval, curve: Curves.easeOutBack),
    );

    return Positioned(
      left: posX,
      top: posY,
      child: AnimatedBuilder(
        animation: Listenable.merge([_entryAnimController, _pulseAnimController]),
        builder: (context, child) {
          double dy = 0.0;
          if (node.isGoal) {
            dy = math.sin(_pulseAnimController.value * math.pi) * 3.5;
          } else if (node.level == 2) {
            dy = math.sin(_pulseAnimController.value * math.pi) * 1.5;
          }

          return Transform.translate(
            offset: Offset(0, dy),
            child: Transform.scale(
              scale: scaleAnimation.value.clamp(0.0, 1.0),
              child: child,
            ),
          );
        },
        child: GestureDetector(
          onTap: () => _onNodeTap(node),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 3D Tactile Node Circle
              _build3DNodeCircle(node),
              const SizedBox(height: 5),

              // Mini Stars for Completed/Active Levels
              if (node.stars > 0)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    final isFilled = i < node.stars;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Icon(
                        Icons.star_rounded,
                        size: 11,
                        color: isFilled ? const Color(0xFFF59E0B) : const Color(0xFFE2E8F0),
                      ),
                    );
                  }),
                ),

              const SizedBox(height: 2),

              // Node Title Label Below
              Text(
                node.title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: node.isGoal ? 13 : 11.5,
                  fontWeight: FontWeight.w800,
                  color: node.isGoal
                      ? const Color(0xFF0284C7)
                      : (node.isCompleted ? AppTheme.primaryGreen : const Color(0xFF94A3B8)),
                  letterSpacing: node.isGoal ? 0.6 : 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 3D Arcade Push-Button Tactile Node Styling
  Widget _build3DNodeCircle(RoadmapNode node) {
    if (node.isGoal) {
      // Top Goal Node with radiant golden pedestal & shimmer
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFFFDE68A), Color(0xFFF59E0B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.only(bottom: 3.5),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: const Center(
            child: Text(
              '🏆',
              style: TextStyle(fontSize: 27),
            ),
          ),
        ),
      );
    }

    if (node.isCompleted) {
      // Completed / Active 3D Push-Button Node
      final isLevel2Active = node.level == 2;

      return Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Outer animated breathing pulse radar ring for Active Level 2
          if (isLevel2Active)
            AnimatedBuilder(
              animation: _pulseAnimController,
              builder: (context, child) {
                final radarScale = 1.0 + (_pulseAnimController.value * 0.16);
                final radarOpacity = (0.35 - (_pulseAnimController.value * 0.20)).clamp(0.0, 1.0);
                return Transform.scale(
                  scale: radarScale,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primaryGreen.withValues(alpha: radarOpacity),
                        width: 2.5,
                      ),
                    ),
                  ),
                );
              },
            ),

          // 3D Button Outer Bevel Base
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: node.level == 1 ? const Color(0xFF0284C7) : const Color(0xFF00A852),
              boxShadow: [
                BoxShadow(
                  color: (node.level == 1 ? const Color(0xFF0284C7) : AppTheme.primaryGreen)
                      .withValues(alpha: 0.32),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.only(bottom: 4), // 3D bevel depth
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: node.level == 1
                      ? [const Color(0xFF38BDF8), const Color(0xFF0284C7)]
                      : [const Color(0xFF00E575), const Color(0xFF00B853)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Locked Level 3D Frosted Node with Padlock
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFCBD5E1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.only(bottom: 3), // 3D bevel depth
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFF8FAFC),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        ),
        child: const Center(
          child: Icon(
            Icons.lock_outline_rounded,
            color: Color(0xFF94A3B8),
            size: 21,
          ),
        ),
      ),
    );
  }
}

// Custom Painter to draw connecting solid gradient and dashed lines with luminous neon glow
class _ModernRoadmapPathPainter extends CustomPainter {
  final List<RoadmapNode> nodes;
  final double width;
  final double progress; // 0.0 to 1.0

  _ModernRoadmapPathPainter({
    required this.nodes,
    required this.width,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.01) return;

    final nodeMap = {for (var n in nodes) n.level: n};

    // 1. Solid Curve: Level 1 (x: 0.24, y: 835) to Level 2 (x: 0.56, y: 720)
    final n1 = nodeMap[1]!;
    final n2 = nodeMap[2]!;
    final p1 = Offset(width * n1.xPercent, n1.yOffset);
    final p2 = Offset(width * n2.xPercent, n2.yOffset);

    final path1To2 = Path()
      ..moveTo(p1.dx, p1.dy)
      ..cubicTo(
        p1.dx + (p2.dx - p1.dx) * 0.4,
        p1.dy - 30,
        p1.dx + (p2.dx - p1.dx) * 0.6,
        p2.dy + 35,
        p2.dx,
        p2.dy,
      );

    // Glow under-layer
    final glowPaint1To2 = Paint()
      ..color = const Color(0xFF00D46A).withValues(alpha: 0.18)
      ..strokeWidth = 9.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    _drawTrimmedPath(canvas, path1To2, glowPaint1To2, progress, 0.0, 0.20);

    // Main vibrant stroke
    final solidPaint1To2 = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0284C7), Color(0xFF00D46A)],
      ).createShader(Rect.fromPoints(p1, p2))
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    _drawTrimmedPath(canvas, path1To2, solidPaint1To2, progress, 0.0, 0.20);

    // 2. Solid Curve: Level 2 (x: 0.56, y: 720) to Level 3 (x: 0.85, y: 570)
    final n3 = nodeMap[3]!;
    final p3 = Offset(width * n3.xPercent, n3.yOffset);

    final path2To3 = Path()
      ..moveTo(p2.dx, p2.dy)
      ..cubicTo(
        p2.dx + (p3.dx - p2.dx) * 0.7,
        p2.dy - 20,
        p3.dx - 10,
        p3.dy + 65,
        p3.dx,
        p3.dy,
      );

    // Glow under-layer
    final glowPaint2To3 = Paint()
      ..color = const Color(0xFF00D46A).withValues(alpha: 0.18)
      ..strokeWidth = 9.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    _drawTrimmedPath(canvas, path2To3, glowPaint2To3, progress, 0.20, 0.38);

    // Main vibrant emerald stroke
    final solidPaint2To3 = Paint()
      ..color = const Color(0xFF00D46A)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    _drawTrimmedPath(canvas, path2To3, solidPaint2To3, progress, 0.20, 0.38);

    // 3. Dashed Straight Lines for Levels 3 -> 4 -> 5 -> 6 -> 7 -> GOAL
    final dashedPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 2.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final n4 = nodeMap[4]!;
    final n5 = nodeMap[5]!;
    final n6 = nodeMap[6]!;
    final n7 = nodeMap[7]!;
    final nGoal = nodeMap[8]!;

    final p4 = Offset(width * n4.xPercent, n4.yOffset);
    final p5 = Offset(width * n5.xPercent, n5.yOffset);
    final p6 = Offset(width * n6.xPercent, n6.yOffset);
    final p7 = Offset(width * n7.xPercent, n7.yOffset);
    final pGoal = Offset(width * nGoal.xPercent, nGoal.yOffset);

    // Level 3 to Level 4
    final path3To4 = Path()..moveTo(p3.dx, p3.dy)..lineTo(p4.dx, p4.dy);
    _drawTrimmedDashedPath(canvas, path3To4, dashedPaint, progress, 0.38, 0.50);

    // Level 4 to Level 5
    final path4To5 = Path()..moveTo(p4.dx, p4.dy)..lineTo(p5.dx, p5.dy);
    _drawTrimmedDashedPath(canvas, path4To5, dashedPaint, progress, 0.50, 0.62);

    // Level 5 to Level 6
    final path5To6 = Path()..moveTo(p5.dx, p5.dy)..lineTo(p6.dx, p6.dy);
    _drawTrimmedDashedPath(canvas, path5To6, dashedPaint, progress, 0.62, 0.74);

    // Level 6 to Level 7
    final path6To7 = Path()..moveTo(p6.dx, p6.dy)..lineTo(p7.dx, p7.dy);
    _drawTrimmedDashedPath(canvas, path6To7, dashedPaint, progress, 0.74, 0.86);

    // Level 7 to GOAL
    final path7ToGoal = Path()..moveTo(p7.dx, p7.dy)..lineTo(pGoal.dx, pGoal.dy);
    _drawTrimmedDashedPath(canvas, path7ToGoal, dashedPaint, progress, 0.86, 1.00);
  }

  void _drawTrimmedPath(
    Canvas canvas,
    Path path,
    Paint paint,
    double overallProgress,
    double startThreshold,
    double endThreshold,
  ) {
    if (overallProgress <= startThreshold) return;

    final subProgress = ((overallProgress - startThreshold) / (endThreshold - startThreshold)).clamp(0.0, 1.0);
    for (final metric in path.computeMetrics()) {
      final extractEnd = metric.length * subProgress;
      final segment = metric.extractPath(0.0, extractEnd);
      canvas.drawPath(segment, paint);
    }
  }

  void _drawTrimmedDashedPath(
    Canvas canvas,
    Path path,
    Paint paint,
    double overallProgress,
    double startThreshold,
    double endThreshold, {
    double dashWidth = 8,
    double dashSpace = 6,
  }) {
    if (overallProgress <= startThreshold) return;

    final subProgress = ((overallProgress - startThreshold) / (endThreshold - startThreshold)).clamp(0.0, 1.0);

    for (final metric in path.computeMetrics()) {
      final totalToDraw = metric.length * subProgress;
      double distance = 0.0;

      while (distance < totalToDraw) {
        final double end = math.min(distance + dashWidth, totalToDraw);
        final segment = metric.extractPath(distance, end);
        canvas.drawPath(segment, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ModernRoadmapPathPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Speech Pointer Triangle
class _TrianglePointerPainter extends CustomPainter {
  final Color color;
  _TrianglePointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Background soft pastel shapes, ambient blooms, and floating sparkles
class _RoadmapBackgroundDecoration extends StatelessWidget {
  const _RoadmapBackgroundDecoration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top right emerald bloom
        Positioned(
          right: -40,
          top: 60,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF10B981).withValues(alpha: 0.06),
            ),
          ),
        ),
        // Middle left indigo bloom
        Positioned(
          left: -70,
          top: 340,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF6366F1).withValues(alpha: 0.06),
            ),
          ),
        ),
        // Bottom left soft sky cyan bloom
        Positioned(
          left: -40,
          bottom: 180,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF38BDF8).withValues(alpha: 0.07),
            ),
          ),
        ),
      ],
    );
  }
}
