import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'otp_verification_view.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/widgets.dart';

typedef EmailInputView = EmailInputScreen;

class EmailInputScreen extends StatefulWidget {
  const EmailInputScreen({super.key});

  @override
  State<EmailInputScreen> createState() => _EmailInputScreenState();
}

class _EmailInputScreenState extends State<EmailInputScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final email = _emailController.text.trim();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OtpVerificationScreen(
          email: email.isEmpty ? 'your.email@example.com' : email,
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
    return Container(
      color: Colors.white,
      child: BackgroundWaves(
        child: SafeArea(
          top: !isInsideFrame,
          bottom: !isInsideFrame,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        SizedBox(height: isInsideFrame ? 32 : 20),

                        // Back navigation if allowed
                        if (Navigator.canPop(context))
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                                color: AppTheme.darkNavy,
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ),

                        const SizedBox(height: 10),

                        // Full Logo
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: const FluentioLogo.full(height: 70),
                        ),

                        const SizedBox(height: 20),
                        const Spacer(),

                        // Bottom Sheet Form Card
                        AuthCardContainer(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Continue with E-mail',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.darkNavy,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Enter the mail address you want to use',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.subtitleGray,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Email Text Field
                                CustomTextField(
                                  label: 'Email address',
                                  hintText: 'your.email@example.com',
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icon(
                                    Icons.mail_outline_rounded,
                                    color: Colors.grey.shade500,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Continue Button
                                GradientButton(
                                  text: 'Continue',
                                  onPressed: _onContinue,
                                ),
                                const SizedBox(height: 12),

                                // Back Button
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Back',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.subtitleGray,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
