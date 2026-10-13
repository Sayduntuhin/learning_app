import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingView extends StatelessWidget {
  final String? userName;
  final String? language;

  const SettingView({
    super.key,
    this.userName,
    this.language,
  });

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
            child: Column(
              children: [
                // Top Bar with Back Button & Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
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
                            Icons.arrow_back_ios_new_rounded,
                            size: 16,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Text(
                        'Setting',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
                    child: Column(
                      children: [
                        // User Avatar with Radiant Glow
                        Container(
                          width: 88.w,
                          height: 88.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3.5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0066FF).withValues(alpha: 0.16),
                                blurRadius: 20,
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

                        SizedBox(height: 20.h),

                        // My Courses Card
                        _buildMyCoursesCard(),

                        SizedBox(height: 18.h),

                        // Settings Menu Group Card
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                              _buildSettingRow(
                                icon: Icons.edit_outlined,
                                title: 'Edit Profile',
                                subtitle: 'Update your personal information',
                                onTap: () {},
                              ),
                              _buildDivider(),
                              _buildSettingRow(
                                icon: Icons.translate_rounded,
                                title: 'Native Language',
                                subtitle: 'Change your native language',
                                onTap: () {},
                              ),
                              _buildDivider(),
                              _buildSettingRow(
                                icon: Icons.language_rounded,
                                title: 'App Language',
                                subtitle: 'Change your app language',
                                onTap: () {},
                              ),
                              _buildDivider(),
                              _buildSettingRow(
                                icon: Icons.menu_book_outlined,
                                title: 'My Courses',
                                subtitle: 'View your courses',
                                onTap: () {},
                              ),
                              _buildDivider(),
                              _buildSettingRow(
                                icon: Icons.vpn_key_outlined,
                                title: 'Privacy & Policy',
                                subtitle: 'See how we protect you',
                                onTap: () {},
                              ),
                              _buildDivider(),
                              _buildSettingRow(
                                icon: Icons.delete_outline_rounded,
                                title: 'Delete Account',
                                subtitle: 'Delete your account and data',
                                onTap: () {},
                              ),
                              _buildDivider(),
                              _buildSettingRow(
                                icon: Icons.logout_rounded,
                                title: 'Log out',
                                subtitle: null,
                                onTap: () {},
                                isDestructive: true,
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildMyCoursesCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon + Title + Subtitle
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Color(0xFF0066FF),
                  size: 22,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Courses',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Manage and track your languages',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 18.h),

          // Course Progress Sub-card
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Flag + Name + Level Pill + Add Button
                Row(
                  children: [
                    // Circular UK Flag Badge
                    Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE2E8F0),
                      ),
                      child: Center(
                        child: Text(
                          '🇬🇧',
                          style: TextStyle(fontSize: 22.sp),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'English',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            'B1 Intermediate',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF16A34A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // + Add Course Button
                    Container(
                      width: 34.w,
                      height: 34.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Color(0xFF64748B),
                        size: 20,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14.h),

                Text(
                  '18/24 Lessons',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                ),

                SizedBox(height: 8.h),

                // Overall Progress + Percentage
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'OVERALL PROGRESS',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    Text(
                      '72% Completed',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0066FF),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8.h),

                // Rounded Gradient Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: Container(
                    height: 8.h,
                    width: double.infinity,
                    color: const Color(0xFFE2E8F0),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.72,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0066FF), Color(0xFF00D46A)],
                          ),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
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

  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    required String? subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            // Circular Icon Badge
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: isDestructive ? const Color(0xFFFEF2F2) : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDestructive ? const Color(0xFFFEE2E2) : const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
              ),
              child: Icon(
                icon,
                size: 18,
                color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF1E293B),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w700,
                      color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF0F172A),
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: const Color(0xFFCBD5E1),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: const Color(0xFFF1F5F9),
    );
  }
}
