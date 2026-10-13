import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'goal_selection_view.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/widgets.dart';

typedef LanguageSelectionView = LanguageSelectionScreen;

class TargetLanguage {
  final String id;
  final String name;
  final String? subtitle;
  final CountryFlag flag;
  final String standardName;

  const TargetLanguage({
    required this.id,
    required this.name,
    this.subtitle,
    required this.flag,
    required this.standardName,
  });
}

class SpeakerCategory {
  final String id;
  final String title;
  final CountryFlag nativeFlag;
  final List<TargetLanguage> targetLanguages;

  const SpeakerCategory({
    required this.id,
    required this.title,
    required this.nativeFlag,
    required this.targetLanguages,
  });
}

class LanguageSelectionScreen extends StatefulWidget {
  final String? userName;

  const LanguageSelectionScreen({
    super.key,
    this.userName,
  });

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? _expandedCategoryId;
  String? _selectedLanguageKey;
  late List<SpeakerCategory> _orderedCategories;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const List<SpeakerCategory> _baseCategories = [
    // 1. Bengali Speakers
    SpeakerCategory(
      id: 'bengali',
      title: 'For Bengali speakers',
      nativeFlag: CountryFlag.bengali,
      targetLanguages: [
        TargetLanguage(
          id: 'english',
          name: 'ইংরেজি',
          subtitle: 'English',
          flag: CountryFlag.usa,
          standardName: 'English',
        ),
        TargetLanguage(
          id: 'japanese',
          name: 'জাপানিজ',
          subtitle: 'Japanese',
          flag: CountryFlag.japan,
          standardName: 'Japanese',
        ),
        TargetLanguage(
          id: 'german',
          name: 'জার্মান',
          subtitle: 'German',
          flag: CountryFlag.germany,
          standardName: 'German',
        ),
        TargetLanguage(
          id: 'french',
          name: 'ফ্রেঞ্চ',
          subtitle: 'French',
          flag: CountryFlag.france,
          standardName: 'French',
        ),
        TargetLanguage(
          id: 'spanish',
          name: 'স্প্যানিশ',
          subtitle: 'Spanish',
          flag: CountryFlag.spain,
          standardName: 'Spanish',
        ),
        TargetLanguage(
          id: 'korean',
          name: 'কোরিয়ান',
          subtitle: 'Korean',
          flag: CountryFlag.korea,
          standardName: 'Korean',
        ),
        TargetLanguage(
          id: 'italian',
          name: 'ইতালিয়ান',
          subtitle: 'Italian',
          flag: CountryFlag.italy,
          standardName: 'Italian',
        ),
        TargetLanguage(
          id: 'arabic',
          name: 'আরবি',
          subtitle: 'Arabic',
          flag: CountryFlag.arabic,
          standardName: 'Arabic',
        ),
      ],
    ),

    // 2. English Speakers
    SpeakerCategory(
      id: 'english',
      title: 'For English speakers',
      nativeFlag: CountryFlag.usa,
      targetLanguages: [
        TargetLanguage(
          id: 'spanish',
          name: 'Spanish',
          subtitle: 'Español',
          flag: CountryFlag.spain,
          standardName: 'Spanish',
        ),
        TargetLanguage(
          id: 'french',
          name: 'French',
          subtitle: 'Français',
          flag: CountryFlag.france,
          standardName: 'French',
        ),
        TargetLanguage(
          id: 'german',
          name: 'German',
          subtitle: 'Deutsch',
          flag: CountryFlag.germany,
          standardName: 'German',
        ),
        TargetLanguage(
          id: 'japanese',
          name: 'Japanese',
          subtitle: '日本語',
          flag: CountryFlag.japan,
          standardName: 'Japanese',
        ),
        TargetLanguage(
          id: 'korean',
          name: 'Korean',
          subtitle: '한국어',
          flag: CountryFlag.korea,
          standardName: 'Korean',
        ),
        TargetLanguage(
          id: 'italian',
          name: 'Italian',
          subtitle: 'Italiano',
          flag: CountryFlag.italy,
          standardName: 'Italian',
        ),
        TargetLanguage(
          id: 'bengali',
          name: 'Bengali',
          subtitle: 'বাংলা',
          flag: CountryFlag.bengali,
          standardName: 'Bengali',
        ),
        TargetLanguage(
          id: 'arabic',
          name: 'Arabic',
          subtitle: 'العربية',
          flag: CountryFlag.arabic,
          standardName: 'Arabic',
        ),
        TargetLanguage(
          id: 'indonesian',
          name: 'Indonesian',
          subtitle: 'Bahasa Indonesia',
          flag: CountryFlag.indonesia,
          standardName: 'Indonesian',
        ),
        TargetLanguage(
          id: 'ukrainian',
          name: 'Ukrainian',
          subtitle: 'Українська',
          flag: CountryFlag.ukraine,
          standardName: 'Ukrainian',
        ),
      ],
    ),

    // 3. Arabic Speakers
    SpeakerCategory(
      id: 'arabic',
      title: 'For Arabic speakers',
      nativeFlag: CountryFlag.arabic,
      targetLanguages: [
        TargetLanguage(
          id: 'english',
          name: 'الإنجليزية',
          subtitle: 'English',
          flag: CountryFlag.usa,
          standardName: 'English',
        ),
        TargetLanguage(
          id: 'french',
          name: 'الفرنسية',
          subtitle: 'French',
          flag: CountryFlag.france,
          standardName: 'French',
        ),
        TargetLanguage(
          id: 'german',
          name: 'الألمانية',
          subtitle: 'German',
          flag: CountryFlag.germany,
          standardName: 'German',
        ),
        TargetLanguage(
          id: 'spanish',
          name: 'الإسبانية',
          subtitle: 'Spanish',
          flag: CountryFlag.spain,
          standardName: 'Spanish',
        ),
        TargetLanguage(
          id: 'japanese',
          name: 'اليابانية',
          subtitle: 'Japanese',
          flag: CountryFlag.japan,
          standardName: 'Japanese',
        ),
        TargetLanguage(
          id: 'turkish',
          name: 'التركية',
          subtitle: 'Turkish',
          flag: CountryFlag.turkey,
          standardName: 'Turkish',
        ),
      ],
    ),

    // 4. Ukrainian Speakers
    SpeakerCategory(
      id: 'ukrainian',
      title: 'For Ukrainian speakers',
      nativeFlag: CountryFlag.ukraine,
      targetLanguages: [
        TargetLanguage(
          id: 'english',
          name: 'Англійська',
          subtitle: 'English',
          flag: CountryFlag.usa,
          standardName: 'English',
        ),
        TargetLanguage(
          id: 'polish',
          name: 'Польська',
          subtitle: 'Polish',
          flag: CountryFlag.poland,
          standardName: 'Polish',
        ),
        TargetLanguage(
          id: 'german',
          name: 'Німецька',
          subtitle: 'German',
          flag: CountryFlag.germany,
          standardName: 'German',
        ),
        TargetLanguage(
          id: 'spanish',
          name: 'Іспанська',
          subtitle: 'Spanish',
          flag: CountryFlag.spain,
          standardName: 'Spanish',
        ),
        TargetLanguage(
          id: 'french',
          name: 'Французька',
          subtitle: 'French',
          flag: CountryFlag.france,
          standardName: 'French',
        ),
      ],
    ),

    // 5. Italian Speakers
    SpeakerCategory(
      id: 'italian',
      title: 'For Italian speakers',
      nativeFlag: CountryFlag.italy,
      targetLanguages: [
        TargetLanguage(
          id: 'english',
          name: 'Inglese',
          subtitle: 'English',
          flag: CountryFlag.usa,
          standardName: 'English',
        ),
        TargetLanguage(
          id: 'spagnolo',
          name: 'Spagnolo',
          subtitle: 'Spanish',
          flag: CountryFlag.spain,
          standardName: 'Spanish',
        ),
        TargetLanguage(
          id: 'francese',
          name: 'Francese',
          subtitle: 'French',
          flag: CountryFlag.france,
          standardName: 'French',
        ),
        TargetLanguage(
          id: 'tedesco',
          name: 'Tedesco',
          subtitle: 'German',
          flag: CountryFlag.germany,
          standardName: 'German',
        ),
        TargetLanguage(
          id: 'giapponese',
          name: 'Giapponese',
          subtitle: 'Japanese',
          flag: CountryFlag.japan,
          standardName: 'Japanese',
        ),
      ],
    ),

    // 6. Indonesian Speakers
    SpeakerCategory(
      id: 'indonesian',
      title: 'For Indonesian speakers',
      nativeFlag: CountryFlag.indonesia,
      targetLanguages: [
        TargetLanguage(
          id: 'english',
          name: 'Inggris',
          subtitle: 'English',
          flag: CountryFlag.usa,
          standardName: 'English',
        ),
        TargetLanguage(
          id: 'japanese',
          name: 'Jepang',
          subtitle: 'Japanese',
          flag: CountryFlag.japan,
          standardName: 'Japanese',
        ),
        TargetLanguage(
          id: 'korean',
          name: 'Korea',
          subtitle: 'Korean',
          flag: CountryFlag.korea,
          standardName: 'Korean',
        ),
        TargetLanguage(
          id: 'arabic',
          name: 'Arab',
          subtitle: 'Arabic',
          flag: CountryFlag.arabic,
          standardName: 'Arabic',
        ),
        TargetLanguage(
          id: 'mandarin',
          name: 'Mandarin',
          subtitle: 'Chinese',
          flag: CountryFlag.china,
          standardName: 'Chinese',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _orderedCategories = List.from(_baseCategories);

    // 1. Instant Zero-Permission Detection via Device Locale & TimeZone
    final initialCategoryId = _detectLocaleAndDeviceLanguage();
    _applyLocationOrdering(initialCategoryId);

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });

    // 2. Silent Background IP Geo Verification (Zero-Permission, non-blocking)
    _fetchSilentIpGeoCountry();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Detects native language category instantly without any user prompt or permission dialog
  /// using the system's locale, country code, and timezone offset.
  String _detectLocaleAndDeviceLanguage() {
    try {
      final locale = ui.PlatformDispatcher.instance.locale;
      final countryCode = (locale.countryCode ?? '').toUpperCase();
      final languageCode = locale.languageCode.toLowerCase();
      final offsetHours = DateTime.now().timeZoneOffset.inHours;

      debugPrint('[Fluentio] Detecting location: country=$countryCode, lang=$languageCode, tzOffset=${offsetHours}h');

      // 1. High-confidence Country Code check
      if (countryCode == 'BD') return 'bengali';
      if (['US', 'GB', 'UK', 'CA', 'AU', 'NZ', 'IE'].contains(countryCode)) return 'english';
      if (countryCode == 'ID') return 'indonesian';
      if (countryCode == 'UA') return 'ukrainian';
      if (countryCode == 'IT') return 'italian';
      if (['SA', 'AE', 'EG', 'QA', 'KW', 'OM', 'BH', 'JO', 'LB', 'IQ', 'MA', 'DZ'].contains(countryCode)) {
        return 'arabic';
      }

      // 2. Language Code check
      if (languageCode == 'bn') return 'bengali';
      if (languageCode == 'en') return 'english';
      if (languageCode == 'id') return 'indonesian';
      if (languageCode == 'uk') return 'ukrainian';
      if (languageCode == 'it') return 'italian';
      if (languageCode == 'ar') return 'arabic';

      // 3. Timezone offset checks (e.g. Bangladesh UTC+6, Indonesia UTC+7..9, UK UTC+0/1, US UTC-4..-10)
      if (offsetHours == 6) return 'bengali';
      if (offsetHours >= 7 && offsetHours <= 9) return 'indonesian';
      if (offsetHours <= -4 && offsetHours >= -10) return 'english';
      if (offsetHours == 0 || offsetHours == 1) return 'english';
      if (offsetHours == 2 || offsetHours == 3) return 'ukrainian';
    } catch (e) {
      debugPrint('[Fluentio] Error reading locale/timezone: $e');
    }

    return 'bengali';
  }

  /// Re-orders categories so the detected native language is at the top (First-In / First-Out)
  /// and automatically expands it with its primary target language selected.
  void _applyLocationOrdering(String primaryCategoryId) {
    final catIndex = _baseCategories.indexWhere((c) => c.id == primaryCategoryId);
    if (catIndex != -1) {
      final primary = _baseCategories[catIndex];
      final others = _baseCategories.where((c) => c.id != primaryCategoryId).toList();

      _orderedCategories = [primary, ...others];
      _expandedCategoryId = primaryCategoryId;

      // Select the first target language of this primary category
      if (primary.targetLanguages.isNotEmpty) {
        _selectedLanguageKey = '${primaryCategoryId}_${primary.targetLanguages.first.id}';
      }
      debugPrint('[Fluentio] Prioritized "$primaryCategoryId" first based on location/locale.');
    }
  }

  /// Silent, zero-permission background check using lightweight IP lookup.
  /// If the user travels or has an English phone in Bangladesh or Indonesia, this smoothly corrects the order.
  Future<void> _fetchSilentIpGeoCountry() async {
    if (kIsWeb) return; // Skip raw sockets on web
    try {
      final client = HttpClient()..connectionTimeout = const Duration(milliseconds: 1800);
      final request = await client
          .getUrl(Uri.parse('http://ip-api.com/line/?fields=countryCode'))
          .timeout(const Duration(milliseconds: 1800));
      final response = await request.close().timeout(const Duration(milliseconds: 1800));

      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        client.close();
        final code = body.trim().toUpperCase();
        debugPrint('[Fluentio] Silent IP Geo check response: $code');

        String? detectedId;
        if (code == 'BD') detectedId = 'bengali';
        if (['US', 'GB', 'UK', 'CA', 'AU', 'NZ', 'IE'].contains(code)) detectedId = 'english';
        if (code == 'ID') detectedId = 'indonesian';
        if (code == 'UA') detectedId = 'ukrainian';
        if (code == 'IT') detectedId = 'italian';
        if (['SA', 'AE', 'EG', 'QA', 'KW', 'OM', 'BH', 'JO', 'LB', 'IQ', 'MA', 'DZ'].contains(code)) {
          detectedId = 'arabic';
        }

        if (detectedId != null && detectedId != _orderedCategories.first.id) {
          if (!mounted) return;
          setState(() {
            _applyLocationOrdering(detectedId!);
          });
        }
      } else {
        client.close();
      }
    } catch (e) {
      debugPrint('[Fluentio] Silent IP Geo check ignored: $e');
    }
  }

  void _toggleCategory(String categoryId) {
    setState(() {
      if (_expandedCategoryId == categoryId) {
        _expandedCategoryId = null;
      } else {
        _expandedCategoryId = categoryId;
      }
    });
  }

  void _onSelectLanguage(String categoryId, TargetLanguage targetLanguage) {
    final selectionKey = '${categoryId}_${targetLanguage.id}';
    setState(() {
      _selectedLanguageKey = selectionKey;
    });

    final selectedLanguage = targetLanguage.standardName;
    debugPrint('[Fluentio] Language selected: $selectedLanguage ($selectionKey)');

    Future.delayed(const Duration(milliseconds: 240), () {
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => GoalSelectionScreen(
            userName: widget.userName,
            language: selectedLanguage,
          ),
        ),
      );
    });
  }

  List<SpeakerCategory> get _filteredCategories {
    if (_searchQuery.isEmpty) {
      return _orderedCategories;
    }

    return _orderedCategories.where((cat) {
      final matchesCat = cat.title.toLowerCase().contains(_searchQuery) ||
          cat.id.toLowerCase().contains(_searchQuery);
      if (matchesCat) return true;

      final hasMatchingLanguage = cat.targetLanguages.any((lang) =>
          lang.name.toLowerCase().contains(_searchQuery) ||
          (lang.subtitle != null && lang.subtitle!.toLowerCase().contains(_searchQuery)) ||
          lang.standardName.toLowerCase().contains(_searchQuery));
      return hasMatchingLanguage;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 640;

    if (!isDesktop) {
      return Scaffold(
        backgroundColor: Colors.white,
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
    final categories = _filteredCategories;

    return Container(
      color: Colors.white,
      child: BackgroundWaves(
        child: SafeArea(
          top: !isInsideFrame,
          bottom: !isInsideFrame,
          child: Column(
            children: [
              // Scrollable Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: isInsideFrame ? 20 : 14),

                      // Logo Header & 4-Segment Progress Bar (Step 1 active)
                      FadeSlideTransition(
                        direction: SlideDirection.fromTop,
                        duration: const Duration(milliseconds: 480),
                        delay: const Duration(milliseconds: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: FluentioLogo.full(height: 48),
                            ),
                            SizedBox(height: 16),
                            SegmentedProgressBar(
                              totalSegments: 4,
                              activeIndex: 0,
                              height: 4.5,
                              spacing: 6,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Headline & Subtitle
                      FadeSlideTransition(
                        direction: SlideDirection.fromLeft,
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Which language do you\nwant to learn?",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.darkNavy,
                                height: 1.22,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "We'll personalize your learning path just for you.",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.subtitleGray,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Accordion Categories & Target Languages
                      ...List.generate(categories.length, (index) {
                        final category = categories[index];
                        final isExpanded = _expandedCategoryId == category.id;

                        // Highlight the top category with green border if collapsed
                        final bool isFeatured = index == 0 && _expandedCategoryId == null;

                        return FadeSlideTransition(
                          direction: SlideDirection.fromRight,
                          duration: const Duration(milliseconds: 480),
                          delay: Duration(milliseconds: 160 + (index * 40)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Collapsed Tile or Expanded Header
                              if (!isExpanded)
                                _buildCollapsedCategoryTile(
                                  category: category,
                                  isFeatured: isFeatured,
                                  onTap: () => _toggleCategory(category.id),
                                )
                              else
                                _buildExpandedCategorySection(
                                  category: category,
                                  onToggle: () => _toggleCategory(category.id),
                                ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Pinned Bottom Search Bar
              _buildBottomSearchBar(isInsideFrame),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedCategoryTile({
    required SpeakerCategory category,
    required bool isFeatured,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isFeatured ? AppTheme.primaryGreen : const Color(0xFFE2E8F0),
          width: isFeatured ? 1.6 : 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: isFeatured
                ? AppTheme.primaryGreen.withValues(alpha: 0.10)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: isFeatured ? 10 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    category.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.darkNavy,
                    ),
                  ),
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedCategorySection({
    required SpeakerCategory category,
    required VoidCallback onToggle,
  }) {
    // Filter target languages if search query is active
    final targetLanguages = category.targetLanguages.where((lang) {
      if (_searchQuery.isEmpty) return true;
      return lang.name.toLowerCase().contains(_searchQuery) ||
          (lang.subtitle != null && lang.subtitle!.toLowerCase().contains(_searchQuery)) ||
          lang.standardName.toLowerCase().contains(_searchQuery);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Header with Up Arrow
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 12, left: 2, right: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkNavy,
                ),
              ),
              InkWell(
                onTap: onToggle,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_up_rounded,
                    size: 20,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
        ),

        // List of Target Languages for this Category
        ...List.generate(targetLanguages.length, (i) {
          final lang = targetLanguages[i];
          final selectionKey = '${category.id}_${lang.id}';
          final isSelected = _selectedLanguageKey == selectionKey;

          return LanguageOptionTile(
            title: lang.name,
            subtitle: lang.subtitle,
            flag: lang.flag,
            isSelected: isSelected,
            onTap: () => _onSelectLanguage(category.id, lang),
          );
        }),

        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildBottomSearchBar(bool isInsideFrame) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        22,
        10,
        22,
        14 + (isInsideFrame ? 6 : 4),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(
            color: Color(0xFFF1F5F9),
            width: 1.2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: 1.2,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              color: Color(0xFF94A3B8),
              size: 21,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.darkNavy,
                ),
                decoration: InputDecoration(
                  hintText: _expandedCategoryId == null
                      ? 'Search languages or native origin..'
                      : 'Search languages',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF94A3B8),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              GestureDetector(
                onTap: () => _searchController.clear(),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
