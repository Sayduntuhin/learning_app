import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/widgets.dart';

typedef OnboardingView = OnboardingScreen;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showDeviceFrame = true;

  final List<OnboardingSlideData> _slides = const [
    OnboardingSlideData(
      titlePrefix: 'Speak English\nWith ',
      gradientWord: 'Confidence',
      imagePath: 'assets/images/hero_woman.png',
      subtitle:
          'Practice realistic conversations and boost your fluency with personalized AI tutoring.',
    ),
    OnboardingSlideData(
      titlePrefix: 'Learn Anytime\nWith ',
      gradientWord: 'AI Tutor',
      imagePath: 'assets/images/hero_woman.png',
      subtitle:
          'Get instant feedback on pronunciation, vocabulary, and grammar in real-time.',
    ),
    OnboardingSlideData(
      titlePrefix: 'Achieve Goals\nWith ',
      gradientWord: 'Fluency',
      imagePath: 'assets/images/hero_woman.png',
      subtitle:
          'Track your streaks, master daily challenges, and unlock new career opportunities.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onGetStarted() {
    AuthFlowBottomSheet.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 640;

    if (!isDesktop) {
      return Scaffold(
        body: _buildScreenContent(isInsideFrame: false),
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
            child: _showDeviceFrame
                ? DeviceMockupFrame(
                    child: _buildScreenContent(isInsideFrame: true),
                  )
                : Container(
                    width: 440,
                    height: 880,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: _buildScreenContent(isInsideFrame: false),
                  ),
          ),
          // Frame toggle switch
          Positioned(
            top: 20,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _showDeviceFrame
                        ? Icons.phone_android_rounded
                        : Icons.fullscreen_rounded,
                    size: 18,
                    color: AppTheme.primaryBlue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _showDeviceFrame ? 'Frame: ON' : 'Frame: OFF',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkNavy,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Switch(
                    value: _showDeviceFrame,
                    activeThumbColor: AppTheme.primaryGreen,
                    onChanged: (val) {
                      setState(() {
                        _showDeviceFrame = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenContent({required bool isInsideFrame}) {
    return Container(
      color: Colors.white,
      child: BackgroundWaves(
        child: SafeArea(
          top: !isInsideFrame,
          bottom: !isInsideFrame,
          child: Column(
            children: [
              SizedBox(height: isInsideFrame ? 26 : 16),

              // Reusable Fluentio Logo Icon
              const FluentioLogo.icon(height: 52),

              const SizedBox(height: 18),

              // Headline with Reusable Gradient
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildHeadline(_slides[_currentPage]),
              ),

              const SizedBox(height: 12),

              // Hero Illustration Carousel
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Hero(
                          tag: 'hero_image_$index',
                          child: Image.asset(
                            slide.imagePath,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Reusable Page Indicator
              PageIndicator(
                count: _slides.length,
                currentIndex: _currentPage,
                onDotTap: (index) {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOutCubic,
                  );
                },
              ),

              const SizedBox(height: 28),

              // Reusable Gradient Action Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: GradientButton(
                  text: 'Get Started',
                  onPressed: _onGetStarted,
                ),
              ),

              SizedBox(height: isInsideFrame ? 28 : 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeadline(OnboardingSlideData slide) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.plusJakartaSans(
          fontSize: 27,
          fontWeight: FontWeight.w800,
          color: AppTheme.darkNavy,
          height: 1.22,
          letterSpacing: -0.4,
        ),
        children: [
          TextSpan(text: slide.titlePrefix),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GradientText(
              slide.gradientWord,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 27,
                fontWeight: FontWeight.w800,
                height: 1.22,
                letterSpacing: -0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingSlideData {
  final String titlePrefix;
  final String gradientWord;
  final String imagePath;
  final String subtitle;

  const OnboardingSlideData({
    required this.titlePrefix,
    required this.gradientWord,
    required this.imagePath,
    required this.subtitle,
  });
}
