import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../settings/setting_view.dart';

class ProfileView extends StatefulWidget {
  final String? userName;
  final String? language;

  const ProfileView({
    super.key,
    this.userName,
    this.language,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // 0: Progress, 1: Leaderboard
  int _selectedTab = 0;
  // 0: Today, 1: This week, 2: All time
  int _selectedTimeFilter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFCFF),
      body: Stack(
        children: [
          // Background Waves Texture
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg_waves.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top Header (Title + Settings Gear Icon)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  child: Row(
                    children: [
                      const Spacer(),
                      Text(
                        'Profile',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const Spacer(),
                      // Settings Gear Button -> Navigates to SettingView
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => SettingView(
                                userName: widget.userName,
                                language: widget.language,
                              ),
                            ),
                          );
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.settings_rounded,
                            size: 18,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // User Avatar with Halo
                Container(
                  width: 86.w,
                  height: 86.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0066FF).withValues(alpha: 0.15),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/tutor_mission.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFE2E8F0),
                        child: const Icon(Icons.person_rounded, color: Color(0xFF0066FF)),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Progress vs Leatherboard Tabs Row
                _buildTabsHeader(),

                SizedBox(height: 14.h),

                // Tab Content Body
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 110.h),
                    child: _selectedTab == 0
                        ? _buildProgressTabContent()
                        : _buildLeaderboardTabContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tabs Header: Progress vs Leatherboard
  Widget _buildTabsHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          // Progress Tab
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 0),
              behavior: HitTestBehavior.opaque,
              child: Column(
                children: [
                  Text(
                    'Progress',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16.sp,
                      fontWeight: _selectedTab == 0 ? FontWeight.w800 : FontWeight.w600,
                      color: _selectedTab == 0
                          ? const Color(0xFF0F172A)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 2.5.h,
                    decoration: BoxDecoration(
                      color: _selectedTab == 0
                          ? const Color(0xFF0F172A)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Leatherboard Tab (matching design screen label)
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 1),
              behavior: HitTestBehavior.opaque,
              child: Column(
                children: [
                  Text(
                    'Leatherboard',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16.sp,
                      fontWeight: _selectedTab == 1 ? FontWeight.w800 : FontWeight.w600,
                      color: _selectedTab == 1
                          ? const Color(0xFF0F172A)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 2.5.h,
                    decoration: BoxDecoration(
                      color: _selectedTab == 1
                          ? const Color(0xFF0F172A)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 1: PROGRESS CONTENT
  // ==========================================
  Widget _buildProgressTabContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Weekly Activity Bar Chart Card with 255 exp tooltip
        _buildWeeklyActivityCard(),

        SizedBox(height: 22.h),

        // Achievements Section
        Text(
          'Achievements',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),

        SizedBox(height: 12.h),

        // 3 Achievement Cards Row
        Row(
          children: [
            Expanded(
              child: _buildAchievementCard(
                iconWidget: const Icon(
                  Icons.military_tech_rounded,
                  color: Color(0xFFF59E0B),
                  size: 42,
                ),
                bannerText: "Holia's Rising Star",
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildAchievementCard(
                iconWidget: Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Color(0xFFF87171), Color(0xFFDC2626), Color(0xFF7F1D1D)],
                    ),
                  ),
                ),
                bannerText: 'Planet Explorer',
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildAchievementCard(
                iconWidget: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFFF97316),
                  size: 38,
                ),
                bannerText: 'Meteorite dodger',
              ),
            ),
          ],
        ),

        SizedBox(height: 22.h),

        // Overview Section
        Text(
          'Overview',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),

        SizedBox(height: 12.h),

        // 3 Overview Cards Row
        Row(
          children: [
            Expanded(
              child: _buildOverviewBadgeCard(
                child: const Icon(
                  Icons.shield_rounded,
                  color: Color(0xFFFBBF24),
                  size: 44,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildOverviewBadgeCard(
                child: Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Color(0xFFF87171), Color(0xFFDC2626), Color(0xFF991B1B)],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildOverviewBadgeCard(
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Color(0xFFFBBF24),
                  size: 44,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Weekly Activity Pill Bar Chart
  Widget _buildWeeklyActivityCard() {
    // 7 days bar heights (scale 0.0 to 1.0)
    final barHeights = [0.65, 0.78, 0.70, 0.60, 0.90, 1.00, 0.75];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Chart Area with Tooltip
          SizedBox(
            height: 140.h,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 7 Vertical Bars Row (using Expanded to dynamically fit any screen)
                Positioned.fill(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(7, (index) {
                      final hFactor = barHeights[index];

                      return Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FractionallySizedBox(
                            heightFactor: hFactor,
                            child: Container(
                              width: 18.w,
                              margin: EdgeInsets.symmetric(horizontal: 2.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.r),
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF0284C7),
                                    Color(0xFF00D46A),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // Floating "255 exp" Tooltip over 6th Bar
                Positioned(
                  top: 2.h,
                  right: 42.w,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7),
                          borderRadius: BorderRadius.circular(8.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0284C7).withValues(alpha: 0.35),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '255 exp',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Small downward pointer triangle
                      CustomPaint(
                        size: const Size(8, 4),
                        painter: _TrianglePainter(color: const Color(0xFF0284C7)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Achievement Card with Banner
  Widget _buildAchievementCard({
    required Widget iconWidget,
    required String bannerText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Center(child: iconWidget),
          ),
          // Blue Ribbon Banner at Bottom
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
            ),
            child: Text(
              bannerText,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 8.5.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Overview Square Card with Badge
  Widget _buildOverviewBadgeCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }

  // ==========================================
  // TAB 2: LEADERBOARD CONTENT
  // ==========================================
  Widget _buildLeaderboardTabContent() {
    return Column(
      children: [
        // Time Filter Chips: Today, This week, All time
        _buildTimeFilterRow(),

        SizedBox(height: 20.h),

        // 3D Podium for Top 3 (Camelia, Maxwell, Wilson)
        _buildPodiumSection(),

        SizedBox(height: 18.h),

        // Ranked List of Subsequent Positions (04 to 07)
        _buildRankedList(),
      ],
    );
  }

  // Time Filter Row
  Widget _buildTimeFilterRow() {
    final filters = ['Today', 'This week', 'All time'];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: List.generate(filters.length, (index) {
          final isSelected = _selectedTimeFilter == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTimeFilter = index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0066FF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF0066FF).withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    filters[index],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5.sp,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // 3D Podium Section (Rank 2 Camelia, Rank 1 Maxwell, Rank 3 Wilson)
  Widget _buildPodiumSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 2nd Place: Camelia (Coral Red pillar)
        Expanded(
          child: _buildPodiumColumn(
            name: 'Camelia',
            score: '6,500',
            rankNumber: '2',
            pillarHeight: 120.h,
            pillarColor: const Color(0xFFE85D56),
            avatarPath: 'assets/images/avatars/avatar_2.jpg',
            hasCrown: false,
          ),
        ),

        // 1st Place: Maxwell (Cyan/Blue pillar, Highest)
        Expanded(
          child: _buildPodiumColumn(
            name: 'Maxwell',
            score: '7,120',
            rankNumber: '1',
            pillarHeight: 160.h,
            pillarColor: const Color(0xFF0066FF),
            avatarPath: 'assets/images/avatars/avatar_1.jpg',
            hasCrown: true,
          ),
        ),

        // 3rd Place: Wilson (Royal Blue pillar)
        Expanded(
          child: _buildPodiumColumn(
            name: 'Wilson',
            score: '4,800',
            rankNumber: '3',
            pillarHeight: 95.h,
            pillarColor: const Color(0xFF0050D8),
            avatarPath: 'assets/images/avatars/avatar_3.jpg',
            hasCrown: false,
          ),
        ),
      ],
    );
  }

  Widget _buildPodiumColumn({
    required String name,
    required String score,
    required String rankNumber,
    required double pillarHeight,
    required Color pillarColor,
    required String avatarPath,
    required bool hasCrown,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Score Badge
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.diamond_rounded, color: Color(0xFFF59E0B), size: 12),
            SizedBox(width: 3.w),
            Text(
              score,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),

        SizedBox(height: 4.h),

        // Avatar + Crown
        Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  avatarPath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFE2E8F0),
                    child: const Icon(Icons.person, color: Color(0xFF64748B)),
                  ),
                ),
              ),
            ),
            if (hasCrown)
              Positioned(
                top: -12.h,
                right: -4.w,
                child: const Text('👑', style: TextStyle(fontSize: 16)),
              ),
          ],
        ),

        SizedBox(height: 6.h),

        // Podium Block
        Container(
          height: pillarHeight,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: pillarColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            boxShadow: [
              BoxShadow(
                color: pillarColor.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 14.h),
                child: Text(
                  rankNumber,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Ranked List Below Podium (Position 4 to 8)
  Widget _buildRankedList() {
    final rankedUsers = [
      {'rank': '04', 'name': 'Jessica Anderson', 'xp': '992 Xp', 'isUp': true, 'avatar': 'assets/images/avatars/avatar_4.jpg'},
      {'rank': '05', 'name': 'Sophia Anderson', 'xp': '584 Xp', 'isUp': false, 'avatar': 'assets/images/avatars/avatar_5.jpg'},
      {'rank': '06', 'name': 'Ethan Carter', 'xp': '448 Xp', 'isUp': true, 'avatar': 'assets/images/avatars/avatar_1.jpg'},
      {'rank': '07', 'name': 'Liam Johnson', 'xp': '580 Xp', 'isUp': true, 'avatar': 'assets/images/avatars/avatar_2.jpg'},
      {'rank': '07', 'name': 'Oliver Smith', 'xp': '580 Xp', 'isUp': false, 'avatar': 'assets/images/avatars/avatar_3.jpg'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: List.generate(rankedUsers.length, (index) {
          final user = rankedUsers[index];
          final isLast = index == rankedUsers.length - 1;

          return Container(
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(
                      bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
                    ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                // Rank number
                Text(
                  user['rank'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF64748B),
                  ),
                ),
                SizedBox(width: 12.w),
                // Circular user avatar
                Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: Image.asset(
                      user['avatar'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFE2E8F0),
                        child: const Icon(Icons.person, color: Color(0xFF64748B), size: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Name + XP
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        user['xp'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                // Trend Arrow Indicator (Green up / Blue down)
                Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                    color: (user['isUp'] as bool)
                        ? const Color(0xFF10B981)
                        : const Color(0xFF0284C7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    (user['isUp'] as bool)
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: Colors.white,
                    size: 13,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// Small helper painter for chart tooltip pointer triangle
class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
