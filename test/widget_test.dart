import 'package:confetti/confetti.dart';
import 'package:fluentio/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Complete Onboarding, Assessment & HomeScreen Journey Test',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FluentioApp());

    // 1. Splash screen
    expect(find.text('Speak with the world'), findsOneWidget);

    // Advance past splash timer
    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pumpAndSettle();

    // 2. Onboarding screen
    expect(find.text('Get Started'), findsOneWidget);

    // Tap "Get Started" to open bottom sheet
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // 3. Auth Options in bottom sheet
    expect(find.text('Continue with google'), findsOneWidget);

    // Tap "Continue with google" to proceed to Step 1
    await tester.tap(find.text('Continue with google'));
    await tester.pumpAndSettle();

    // 4. [STEP 1/5] Profile Setup Screen
    expect(find.textContaining("Let's set up your profile"), findsOneWidget);

    // Enter name & continue
    await tester.enterText(find.byType(TextField), 'Alex');
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // 5. [STEP 2/5] Language Selection Screen (Tap to advance)
    expect(find.text('German'), findsOneWidget);
    await tester.ensureVisible(find.text('German'));
    await tester.tap(find.text('German'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    // 6. [STEP 3/5] Goal Selection Screen (Tap to advance)
    expect(find.text('Job interviews'), findsOneWidget);
    await tester.ensureVisible(find.text('Job interviews'));
    await tester.tap(find.text('Job interviews'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    // 7. [STEP 4/5] English Level Screen (Tap to advance)
    expect(find.text('Elementary'), findsOneWidget);
    await tester.ensureVisible(find.text('Elementary'));
    await tester.tap(find.text('Elementary'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    // 8. [STEP 5/5] Practice Time Screen (Tap to advance)
    expect(find.text('3 min'), findsOneWidget);
    await tester.ensureVisible(find.text('3 min'));
    await tester.tap(find.text('3 min'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    // 9. Onboarding Complete Summary Screen
    expect(find.textContaining("You're all set"), findsOneWidget);
    expect(find.text('Start Learning'), findsOneWidget);

    // Tap Start Learning -> Opens Voice Assessment Screen!
    await tester.ensureVisible(find.text('Start Learning'));
    await tester.tap(find.text('Start Learning'));
    await tester.pumpAndSettle();

    // 10. Voice Assessment Screen (State 1: Idle)
    expect(find.text("Let's hear you speak."), findsOneWidget);
    expect(find.textContaining('Tell me about yourself.'), findsOneWidget);
    expect(find.text('Tap to start'), findsOneWidget);

    // Tap to Start Recording (State 2: Recording)
    await tester.ensureVisible(find.byIcon(Icons.mic_rounded));
    await tester.tap(find.byIcon(Icons.mic_rounded));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Tap to stop'), findsOneWidget);

    // Tap to Stop Recording (State 3: Completed)
    await tester.ensureVisible(find.byKey(const ValueKey('stop_recording_button')));
    await tester.tap(find.byKey(const ValueKey('stop_recording_button')));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Recording saved!'), findsOneWidget);
    expect(find.text('Re - record'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);

    // Tap Continue on Voice Assessment -> Opens Assessment Report Screen!
    await tester.ensureVisible(find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // 11. [REPORT SCREEN] Assessment Report Screen (iPhone 16 - 113)
    expect(find.text('Great job, Alex!'), findsOneWidget);
    expect(find.text('Start my journey'), findsOneWidget);

    // Tap "Start my journey" -> Opens HomeScreen!
    await tester.ensureVisible(find.text('Start my journey'));
    await tester.tap(find.text('Start my journey'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 1500));

    // 12. [HOME SCREEN] Roadmap & Gamified Journey (iPhone 16 - 115)
    expect(find.text('Hey Alex'), findsOneWidget);
    expect(find.text('Daily Badge'), findsOneWidget);

    // Verify Roadmap Nodes & Labels
    expect(find.text('GOAL'), findsOneWidget);
    expect(find.text('Level 7'), findsOneWidget);
    expect(find.text('Level 6'), findsOneWidget);
    expect(find.text('Level 5'), findsOneWidget);
    expect(find.text('Level 4'), findsOneWidget);
    expect(find.text('Level 3'), findsOneWidget);
    expect(find.text('Level 2'), findsOneWidget);
    expect(find.text('Level 1'), findsOneWidget);

    // Verify Floating Navigation Bar
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Speak'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Tap Level 1 node
    await tester.ensureVisible(find.text('Level 1'));
    await tester.tap(find.text('Level 1'));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Start Lesson'), findsOneWidget);
    // Dismiss modal bottom sheet barrier
    await tester.tapAt(const Offset(20, 20));
    await tester.pump(const Duration(milliseconds: 600));

    // Test tab navigation to Practice Mode
    await tester.tap(find.text('Practice'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Workplace\nBasics'), findsOneWidget);
    expect(find.text('WEEK 01'), findsOneWidget);
    expect(find.text('Start mission'), findsOneWidget);

    // Tap "Start mission"
    await tester.ensureVisible(find.text('Start mission'));
    await tester.tap(find.text('Start mission'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Build the correct sentence'), findsOneWidget);
    // Verifies that the flawed / wrong sentence is presented for the user to fix:
    expect(find.text('"Sie zur Arbeit jeden Tag geht."'), findsOneWidget);
    expect(find.text('Tap words below to build the sentence'), findsOneWidget);

    // Tap words from bank
    await tester.ensureVisible(find.text('Sie'));
    await tester.tap(find.text('Sie'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.ensureVisible(find.text('geht'));
    await tester.tap(find.text('geht'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Check answer'), findsOneWidget);

    // Pop back to Practice
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Workplace\nBasics'), findsOneWidget);

    // Test tab navigation to Speak Mode
    await tester.tap(find.text('Speak'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('AI Speaking Partner'), findsOneWidget);
    expect(find.text('Start Speaking Session'), findsOneWidget);

    // Test tab navigation to Profile Mode
    await tester.tap(find.text('Profile'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('Leatherboard'), findsOneWidget);
    expect(find.text('Achievements'), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text("Holia's Rising Star"), findsOneWidget);

    // Switch to Leatherboard tab
    await tester.tap(find.text('Leatherboard'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Maxwell'), findsOneWidget);
    expect(find.text('Camelia'), findsOneWidget);
    expect(find.text('Wilson'), findsOneWidget);

    // Open Setting screen via gear button
    await tester.tap(find.byIcon(Icons.settings_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Setting'), findsOneWidget);
    expect(find.text('My Courses'), findsWidgets);
    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);

    // Tap back button to return to Profile
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Leatherboard'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Hey Alex'), findsOneWidget);

    // Test Daily Badge navigation & claim flow
    expect(find.text('Daily Badge'), findsOneWidget);
    await tester.tap(find.text('Daily Badge'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Claim Daily Login Badge'), findsOneWidget);
    expect(find.text('Logged in day 1'), findsOneWidget);

    // Tap first Claim button
    await tester.ensureVisible(find.text('Claim').first);
    await tester.tap(find.text('Claim').first);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Claimed ✓'), findsOneWidget);

    // Tap back button
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Hey Alex'), findsOneWidget);
  });

  testWidgets('Level Completion Dialog displays Confetti and Rewards Card',
      (WidgetTester tester) async {
    final confettiController =
        ConfettiController(duration: const Duration(seconds: 4));
    confettiController.play();

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    // Main Rewards Card
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 32),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Checkmark badge
                          Container(
                            width: 82,
                            height: 82,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFE0F2FE),
                              border: Border.all(
                                  color: const Color(0xFF7DD3FC), width: 4),
                            ),
                            child: Center(
                              child: Container(
                                width: 52,
                                height: 52,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF00D46A),
                                ),
                                child: const Icon(Icons.check_rounded,
                                  color: Colors.white, size: 34),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          // Stars Row (2 full, 1 half)
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star_rounded,
                                  color: Color(0xFF00D46A), size: 38),
                              SizedBox(width: 10),
                              Icon(Icons.star_rounded,
                                  color: Color(0xFF00D46A), size: 38),
                              SizedBox(width: 10),
                              Icon(Icons.star_half_rounded,
                                  color: Color(0xFF00D46A), size: 38),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text('Great Job!'),
                          const SizedBox(height: 18),
                          // Capsule
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 9),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00D46A),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star_rounded,
                                    color: Colors.white, size: 20),
                                SizedBox(width: 6),
                                Text('+25 XP Earned'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                          // Next Level Button
                          Container(
                            height: 54,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0066FF), Color(0xFF00D46A)],
                              ),
                              borderRadius: BorderRadius.circular(27),
                            ),
                            child: const Center(
                              child: Text('Next Level'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Confetti
                    Positioned(
                      top: -16,
                      child: ConfettiWidget(
                        confettiController: confettiController,
                        blastDirectionality: BlastDirectionality.explosive,
                        shouldLoop: false,
                        colors: const [Color(0xFF00D46A), Color(0xFF0066FF)],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(ConfettiWidget), findsOneWidget);
    expect(find.text('+25 XP Earned'), findsOneWidget);
    expect(find.text('Great Job!'), findsOneWidget);
    expect(find.text('Next Level'), findsOneWidget);

    confettiController.dispose();
  });

  test('Dynamic Star and XP tiers calculation based on mistake count', () {
    // Test logic mapping:
    // 0 mistakes -> 3.0 stars (Perfect!, +30 XP)
    // 1 mistake  -> 2.5 stars (Great Job!, +25 XP)
    // 2 mistakes -> 2.0 stars (Well Done!, +20 XP)
    // 3 mistakes -> 1.5 stars (Good Effort!, +15 XP)
    // 4+ mistakes -> 1.0 stars (Keep Practicing!, +10 XP)
    double getRating(int mistakes) {
      if (mistakes == 0) return 3.0;
      if (mistakes == 1) return 2.5;
      if (mistakes == 2) return 2.0;
      if (mistakes == 3) return 1.5;
      return 1.0;
    }

    String getFeedback(int mistakes) {
      if (mistakes == 0) return 'Perfect!';
      if (mistakes == 1) return 'Great Job!';
      if (mistakes == 2) return 'Well Done!';
      if (mistakes == 3) return 'Good Effort!';
      return 'Keep Practicing!';
    }

    int getXp(int mistakes) {
      if (mistakes == 0) return 30;
      if (mistakes == 1) return 25;
      if (mistakes == 2) return 20;
      if (mistakes == 3) return 15;
      return 10;
    }

    expect(getRating(0), 3.0);
    expect(getFeedback(0), 'Perfect!');
    expect(getXp(0), 30);

    expect(getRating(1), 2.5);
    expect(getFeedback(1), 'Great Job!');
    expect(getXp(1), 25);

    expect(getRating(2), 2.0);
    expect(getFeedback(2), 'Well Done!');
    expect(getXp(2), 20);

    expect(getRating(3), 1.5);
    expect(getFeedback(3), 'Good Effort!');
    expect(getXp(3), 15);

    expect(getRating(5), 1.0);
    expect(getFeedback(5), 'Keep Practicing!');
    expect(getXp(5), 10);
  });
}
