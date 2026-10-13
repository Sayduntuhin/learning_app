import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'language_selection_view.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/widgets.dart';

typedef ProfileSetupView = ProfileSetupScreen;

class ProfileSetupScreen extends StatefulWidget {
  final String? email;

  const ProfileSetupScreen({
    super.key,
    this.email,
  });

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  int? _selectedAvatarIndex = 0; // 0 = first avatar selected by default
  XFile? _pickedImageFile; // If picked from real camera or gallery
  bool _isLoadingImage = false;

  final List<String> _avatars = const [
    'assets/images/avatars/avatar_1.jpg',
    'assets/images/avatars/avatar_2.jpg',
    'assets/images/avatars/avatar_3.jpg',
    'assets/images/avatars/avatar_4.jpg',
    'assets/images/avatars/avatar_5.jpg',
  ];

  @override
  void initState() {
    super.initState();
    debugPrint('[Fluentio] ProfileSetupScreen initialized. Platform: ${kIsWeb ? "Web" : Platform.operatingSystem}');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _onUploadPhoto() async {
    debugPrint('[Fluentio] Tapped upload photo circle. Opening source picker...');
    final source = await ImageSourcePickerSheet.show(context);
    
    if (source == null) {
      debugPrint('[Fluentio] Source picker dismissed.');
      return;
    }

    debugPrint('[Fluentio] Selected image source: $source');
    setState(() {
      _isLoadingImage = true;
    });

    try {
      final ImageSource imageSource = source == SelectedImageSource.camera
          ? ImageSource.camera
          : ImageSource.gallery;

      debugPrint('[Fluentio] Calling ImagePicker.pickImage(source: $imageSource)...');
      
      final XFile? file = await _imagePicker.pickImage(
        source: imageSource,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (file != null) {
        final length = await file.length();
        debugPrint('[Fluentio] Image picked successfully! Path: ${file.path}, Size: ${(length / 1024).toStringAsFixed(1)} KB');
        
        if (!mounted) return;
        setState(() {
          _pickedImageFile = file;
          _selectedAvatarIndex = null;
          _isLoadingImage = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              source == SelectedImageSource.camera
                  ? 'Photo captured from Camera!'
                  : 'Photo selected from Gallery!',
            ),
            backgroundColor: AppTheme.primaryGreen,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        debugPrint('[Fluentio] ImagePicker canceled by user.');
        if (mounted) {
          setState(() {
            _isLoadingImage = false;
          });
        }
      }
    } catch (e, stackTrace) {
      debugPrint('[Fluentio] ERROR during ImagePicker: $e\nStackTrace: $stackTrace');
      if (mounted) {
        setState(() {
          _isLoadingImage = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open ${source == SelectedImageSource.camera ? "camera" : "gallery"}: $e'),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _onContinue() {
    final name = _nameController.text.trim();
    debugPrint('[Fluentio] User tapped Continue: name="$name", photo=${_pickedImageFile?.path ?? "avatar #$_selectedAvatarIndex"}');

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LanguageSelectionScreen(
          userName: name.isEmpty ? null : name,
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
    final bool hasCustomPhoto = _pickedImageFile != null;

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

                        // [TOP ANIMATION] Logo header & Progress Bar (Step 1 of 5)
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
                                activeIndex: 0,
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
                          delay: const Duration(milliseconds: 120),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Let's set up your profile\npicture & name",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.darkNavy,
                                  height: 1.25,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'You can choose a avatar instead of a real picture',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.subtitleGray,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 26),

                        // [RIGHT ANIMATION] Photo Upload Circle & Avatars
                        FadeSlideTransition(
                          direction: SlideDirection.fromRight,
                          duration: const Duration(milliseconds: 550),
                          delay: const Duration(milliseconds: 220),
                          child: Column(
                            children: [
                              // Large Circular Profile / Camera selector
                              Center(
                                child: GestureDetector(
                                  onTap: _isLoadingImage ? null : _onUploadPhoto,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 110,
                                        height: 110,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          border: Border.all(
                                            color: hasCustomPhoto
                                                ? AppTheme.primaryGreen
                                                : Colors.grey.shade200,
                                            width: hasCustomPhoto ? 2.5 : 1.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                                              blurRadius: 20,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: _isLoadingImage
                                              ? const SizedBox(
                                                  width: 32,
                                                  height: 32,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 3,
                                                    color: AppTheme.primaryBlue,
                                                  ),
                                                )
                                              : hasCustomPhoto
                                                  ? ClipOval(
                                                      child: kIsWeb
                                                          ? Image.network(
                                                              _pickedImageFile!.path,
                                                              width: 98,
                                                              height: 98,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.file(
                                                              File(_pickedImageFile!.path),
                                                              width: 98,
                                                              height: 98,
                                                              fit: BoxFit.cover,
                                                            ),
                                                    )
                                                  : Container(
                                                      width: 72,
                                                      height: 72,
                                                      decoration: const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Color(0xFFE8F1FF),
                                                      ),
                                                      child: const Icon(
                                                        Icons.add_a_photo_outlined,
                                                        size: 28,
                                                        color: AppTheme.primaryBlue,
                                                      ),
                                                    ),
                                        ),
                                      ),
                                      if (hasCustomPhoto && !_isLoadingImage)
                                        Positioned(
                                          right: 2,
                                          bottom: 2,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: AppTheme.primaryBlue,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.edit,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              // "OR" Divider
                              Center(
                                child: Text(
                                  'OR',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade400,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              // Avatar Picker Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(_avatars.length, (index) {
                                  final isSelected = _selectedAvatarIndex == index && !hasCustomPhoto;
                                  return GestureDetector(
                                    onTap: () {
                                      debugPrint('[Fluentio] Selected avatar #$index');
                                      setState(() {
                                        _selectedAvatarIndex = index;
                                        _pickedImageFile = null;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 250),
                                      width: 54,
                                      height: 54,
                                      padding: const EdgeInsets.all(2.5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: isSelected ? AppTheme.brandGradient : null,
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: AppTheme.primaryGreen.withValues(alpha: 0.4),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        padding: const EdgeInsets.all(1.5),
                                        child: ClipOval(
                                          child: Image.asset(
                                            _avatars[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // [LEFT ANIMATION] Name Input Field
                        FadeSlideTransition(
                          direction: SlideDirection.fromLeft,
                          duration: const Duration(milliseconds: 550),
                          delay: const Duration(milliseconds: 320),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "What's your name",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.darkNavy,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.02),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _nameController,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    color: AppTheme.darkNavy,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Enter your name (in English)',
                                    hintStyle: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      color: Colors.grey.shade400,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person_outline_rounded,
                                      color: Colors.grey.shade400,
                                      size: 20,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),
                        const SizedBox(height: 28),

                        // [BOTTOM ANIMATION] Continue Button
                        FadeSlideTransition(
                          direction: SlideDirection.fromBottom,
                          duration: const Duration(milliseconds: 550),
                          delay: const Duration(milliseconds: 400),
                          child: GradientButton(
                            text: 'Continue',
                            onPressed: _onContinue,
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
}
