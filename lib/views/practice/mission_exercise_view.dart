import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MissionQuestion {
  final String wrongSentence;
  final String targetSentence;
  final String englishTranslation;
  final String audioLanguageCode;
  final List<String> correctWords;
  final List<String> wordBank;

  const MissionQuestion({
    required this.wrongSentence,
    required this.targetSentence,
    required this.englishTranslation,
    required this.audioLanguageCode,
    required this.correctWords,
    required this.wordBank,
  });
}

class MissionExerciseView extends StatefulWidget {
  final String language;
  final VoidCallback? onCompleted;

  const MissionExerciseView({
    super.key,
    this.language = 'English',
    this.onCompleted,
  });

  @override
  State<MissionExerciseView> createState() => _MissionExerciseViewState();
}

class _MissionExerciseViewState extends State<MissionExerciseView>
    with TickerProviderStateMixin {
  late final AudioPlayer _audioPlayer;
  late final List<MissionQuestion> _questions;
  int _currentIndex = 0;

  // Selected words placed in answer slot
  final List<String> _selectedWords = [];
  // Available words in bank (removes word when placed)
  late List<String> _availableWords;

  // Exercise validation state
  bool _isChecked = false;
  bool _isCorrect = false;
  bool _showTranslation = false;
  bool _isPlayingAudio = false;

  // Mistakes tracker to dynamically calculate stars & XP
  int _mistakeCount = 0;

  // Confetti celebratory controller
  late final ConfettiController _confettiController;

  // XP animations
  late final AnimationController _xpAnimController;
  late final Animation<double> _xpScaleAnimation;
  late final Animation<double> _xpOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _confettiController = ConfettiController(duration: const Duration(seconds: 4));
    _questions = _loadQuestionsForLanguage(widget.language);
    _availableWords = List.from(_questions[_currentIndex].wordBank);

    _xpAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _xpScaleAnimation = CurvedAnimation(
      parent: _xpAnimController,
      curve: Curves.elasticOut,
    );

    _xpOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _xpAnimController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _confettiController.dispose();
    _xpAnimController.dispose();
    super.dispose();
  }

  List<MissionQuestion> _loadQuestionsForLanguage(String lang) {
    final l = lang.toLowerCase();

    if (l.contains('german') || l.contains('deutsch')) {
      return const [
        MissionQuestion(
          wrongSentence: 'Sie zur Arbeit jeden Tag geht.',
          targetSentence: 'Sie geht jeden Tag zur Arbeit.',
          englishTranslation: 'She goes to work every day.',
          audioLanguageCode: 'de',
          correctWords: ['Sie', 'geht', 'jeden', 'Tag', 'zur', 'Arbeit'],
          wordBank: ['zur', 'Tag', 'Arbeit', 'Sie', 'jeden', 'gehen', 'geht', 'täglich', 'nie'],
        ),
        MissionQuestion(
          wrongSentence: 'Wir heute ein Teamtreffen haben.',
          targetSentence: 'Wir haben heute ein Teamtreffen.',
          englishTranslation: 'We have a team meeting today.',
          audioLanguageCode: 'de',
          correctWords: ['Wir', 'haben', 'heute', 'ein', 'Teamtreffen'],
          wordBank: ['heute', 'ein', 'Wir', 'Teamtreffen', 'haben', 'hat', 'morgen', 'sind'],
        ),
        MissionQuestion(
          wrongSentence: 'Können Sie den Bericht mir senden?',
          targetSentence: 'Können Sie mir den Bericht senden?',
          englishTranslation: 'Can you send me the report?',
          audioLanguageCode: 'de',
          correctWords: ['Können', 'Sie', 'mir', 'den', 'Bericht', 'senden'],
          wordBank: ['den', 'Sie', 'Können', 'senden', 'mir', 'Bericht', 'geben', 'Brief'],
        ),
        MissionQuestion(
          wrongSentence: 'Ich bald diese Aufgabe beende.',
          targetSentence: 'Ich beende diese Aufgabe bald.',
          englishTranslation: 'I will finish this task soon.',
          audioLanguageCode: 'de',
          correctWords: ['Ich', 'beende', 'diese', 'Aufgabe', 'bald'],
          wordBank: ['diese', 'Ich', 'bald', 'Aufgabe', 'beende', 'mache', 'spät'],
        ),
        MissionQuestion(
          wrongSentence: 'Gute bei der Präsentation Arbeit!',
          targetSentence: 'Gute Arbeit bei der Präsentation!',
          englishTranslation: 'Great job on the presentation!',
          audioLanguageCode: 'de',
          correctWords: ['Gute', 'Arbeit', 'bei', 'der', 'Präsentation'],
          wordBank: ['bei', 'Gute', 'der', 'Arbeit', 'Präsentation', 'schlecht', 'Projekt'],
        ),
      ];
    } else if (l.contains('spanish') || l.contains('español')) {
      return const [
        MissionQuestion(
          wrongSentence: 'Ella trabajar va a todos los días.',
          targetSentence: 'Ella va a trabajar todos los días.',
          englishTranslation: 'She goes to work every day.',
          audioLanguageCode: 'es',
          correctWords: ['Ella', 'va', 'a', 'trabajar', 'todos', 'los', 'días'],
          wordBank: ['a', 'días', 'trabajar', 'Ella', 'todos', 'ir', 'va', 'los', 'nunca'],
        ),
        MissionQuestion(
          wrongSentence: 'Tenemos hoy de equipo una reunión.',
          targetSentence: 'Tenemos una reunión de equipo hoy.',
          englishTranslation: 'We have a team meeting today.',
          audioLanguageCode: 'es',
          correctWords: ['Tenemos', 'una', 'reunión', 'de', 'equipo', 'hoy'],
          wordBank: ['una', 'hoy', 'Tenemos', 'equipo', 'reunión', 'de', 'ayer', 'somos'],
        ),
        MissionQuestion(
          wrongSentence: '¿Puedes el informe enviarme?',
          targetSentence: '¿Puedes enviarme el informe?',
          englishTranslation: 'Can you send me the report?',
          audioLanguageCode: 'es',
          correctWords: ['¿Puedes', 'enviarme', 'el', 'informe?'],
          wordBank: ['el', '¿Puedes', 'informe?', 'enviarme', 'darme', 'documento'],
        ),
        MissionQuestion(
          wrongSentence: 'Terminaré pronto esta tarea.',
          targetSentence: 'Terminaré esta tarea pronto.',
          englishTranslation: 'I will finish this task soon.',
          audioLanguageCode: 'es',
          correctWords: ['Terminaré', 'esta', 'tarea', 'pronto.'],
          wordBank: ['esta', 'Terminaré', 'pronto.', 'tarea', 'hacer', 'tarde'],
        ),
        MissionQuestion(
          wrongSentence: '¡Buen en la presentación trabajo!',
          targetSentence: '¡Buen trabajo en la presentación!',
          englishTranslation: 'Great job on the presentation!',
          audioLanguageCode: 'es',
          correctWords: ['¡Buen', 'trabajo', 'en', 'la', 'presentación!'],
          wordBank: ['en', '¡Buen', 'la', 'trabajo', 'presentación!', 'malo', 'reunión'],
        ),
      ];
    } else if (l.contains('french') || l.contains('français')) {
      return const [
        MissionQuestion(
          wrongSentence: 'Elle travail va au tous les jours.',
          targetSentence: 'Elle va au travail tous les jours.',
          englishTranslation: 'She goes to work every day.',
          audioLanguageCode: 'fr',
          correctWords: ['Elle', 'va', 'au', 'travail', 'tous', 'les', 'jours'],
          wordBank: ['au', 'jours', 'travail', 'Elle', 'tous', 'aller', 'va', 'les', 'jamais'],
        ),
        MissionQuestion(
          wrongSentence: 'Nous aujourd’hui une réunion avons d’équipe.',
          targetSentence: 'Nous avons une réunion d’équipe aujourd’hui.',
          englishTranslation: 'We have a team meeting today.',
          audioLanguageCode: 'fr',
          correctWords: ['Nous', 'avons', 'une', 'réunion', 'd’équipe', 'aujourd’hui'],
          wordBank: ['une', 'aujourd’hui', 'Nous', 'd’équipe', 'réunion', 'avons', 'demain'],
        ),
        MissionQuestion(
          wrongSentence: 'Pouvez-vous le rapport m’envoyer?',
          targetSentence: 'Pouvez-vous m’envoyer le rapport?',
          englishTranslation: 'Can you send me the report?',
          audioLanguageCode: 'fr',
          correctWords: ['Pouvez-vous', 'm’envoyer', 'le', 'rapport?'],
          wordBank: ['le', 'Pouvez-vous', 'rapport?', 'm’envoyer', 'donner', 'projet'],
        ),
        MissionQuestion(
          wrongSentence: 'Je bientôt cette tâche finirai.',
          targetSentence: 'Je finirai cette tâche bientôt.',
          englishTranslation: 'I will finish this task soon.',
          audioLanguageCode: 'fr',
          correctWords: ['Je', 'finirai', 'cette', 'tâche', 'bientôt.'],
          wordBank: ['cette', 'Je', 'bientôt.', 'tâche', 'finirai', 'faire', 'tard'],
        ),
        MissionQuestion(
          wrongSentence: 'Bravo la présentation pour!',
          targetSentence: 'Bravo pour la présentation!',
          englishTranslation: 'Great job on the presentation!',
          audioLanguageCode: 'fr',
          correctWords: ['Bravo', 'pour', 'la', 'présentation!'],
          wordBank: ['pour', 'Bravo', 'la', 'présentation!', 'bon', 'travail'],
        ),
      ];
    } else if (l.contains('russian') || l.contains('русский')) {
      return const [
        MissionQuestion(
          wrongSentence: 'Она работу на каждый день ходит.',
          targetSentence: 'Она ходит на работу каждый день.',
          englishTranslation: 'She goes to work every day.',
          audioLanguageCode: 'ru',
          correctWords: ['Она', 'ходит', 'на', 'работу', 'каждый', 'день'],
          wordBank: ['на', 'день', 'работу', 'Она', 'каждый', 'идти', 'ходит', 'никогда'],
        ),
        MissionQuestion(
          wrongSentence: 'У нас собрание сегодня команды.',
          targetSentence: 'У нас сегодня собрание команды.',
          englishTranslation: 'We have a team meeting today.',
          audioLanguageCode: 'ru',
          correctWords: ['У', 'нас', 'сегодня', 'собрание', 'команды'],
          wordBank: ['сегодня', 'У', 'собрание', 'нас', 'команды', 'завтра', 'было'],
        ),
        MissionQuestion(
          wrongSentence: 'Можете мне отчет отправить?',
          targetSentence: 'Можете отправить мне отчет?',
          englishTranslation: 'Can you send me the report?',
          audioLanguageCode: 'ru',
          correctWords: ['Можете', 'отправить', 'мне', 'отчет?'],
          wordBank: ['мне', 'Можете', 'отчет?', 'отправить', 'дать', 'файл'],
        ),
        MissionQuestion(
          wrongSentence: 'Я скоро эту задачу закончу.',
          targetSentence: 'Я закончу эту задачу скоро.',
          englishTranslation: 'I will finish this task soon.',
          audioLanguageCode: 'ru',
          correctWords: ['Я', 'закончу', 'эту', 'задачу', 'скоро'],
          wordBank: ['эту', 'Я', 'скоро', 'задачу', 'закончу', 'делать', 'поздно'],
        ),
        MissionQuestion(
          wrongSentence: 'Отличная с презентацией работа!',
          targetSentence: 'Отличная работа с презентацией!',
          englishTranslation: 'Great job on the presentation!',
          audioLanguageCode: 'ru',
          correctWords: ['Отличная', 'работа', 'с', 'презентацией!'],
          wordBank: ['с', 'Отличная', 'презентацией!', 'работа', 'хорошо', 'проект'],
        ),
      ];
    }

    // Default: English practice (Screen iPhone 16 - 120 matching)
    return const [
      MissionQuestion(
        wrongSentence: 'She work goes to every day.',
        targetSentence: 'She goes to work every day.',
        englishTranslation: 'She goes to work every day.',
        audioLanguageCode: 'en',
        correctWords: ['She', 'goes', 'to', 'work', 'every', 'day'],
        wordBank: ['to', 'day', 'work', 'She', 'every', 'go', 'goes', 'daily', 'never'],
      ),
      MissionQuestion(
        wrongSentence: 'We a team meeting today have.',
        targetSentence: 'We have a team meeting today.',
        englishTranslation: 'We have a team meeting today.',
        audioLanguageCode: 'en',
        correctWords: ['We', 'have', 'a', 'team', 'meeting', 'today'],
        wordBank: ['meeting', 'a', 'We', 'today', 'have', 'team', 'has', 'tomorrow', 'are'],
      ),
      MissionQuestion(
        wrongSentence: 'Can you me send the project report?',
        targetSentence: 'Can you send me the project report?',
        englishTranslation: 'Can you send me the project report?',
        audioLanguageCode: 'en',
        correctWords: ['Can', 'you', 'send', 'me', 'the', 'project', 'report'],
        wordBank: ['project', 'you', 'Can', 'send', 'the', 'me', 'report', 'give', 'document'],
      ),
      MissionQuestion(
        wrongSentence: 'I will this task finish before noon.',
        targetSentence: 'I will finish this task before noon.',
        englishTranslation: 'I will finish this task before noon.',
        audioLanguageCode: 'en',
        correctWords: ['I', 'will', 'finish', 'this', 'task', 'before', 'noon'],
        wordBank: ['finish', 'this', 'I', 'will', 'task', 'noon', 'before', 'do', 'night'],
      ),
      MissionQuestion(
        wrongSentence: 'Great job on the presentation completing!',
        targetSentence: 'Great job on completing the presentation!',
        englishTranslation: 'Great job on completing the presentation!',
        audioLanguageCode: 'en',
        correctWords: ['Great', 'job', 'on', 'completing', 'the', 'presentation'],
        wordBank: ['on', 'Great', 'the', 'job', 'presentation', 'completing', 'good', 'work'],
      ),
    ];
  }

  Future<void> _playVoice(String text, String langCode) async {
    if (_isPlayingAudio) return;
    setState(() => _isPlayingAudio = true);
    try {
      final encoded = Uri.encodeComponent(text);
      final url =
          'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=$langCode&q=$encoded';
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      debugPrint('[Fluentio] Audio play error: $e');
    } finally {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 1600), () {
          if (mounted) setState(() => _isPlayingAudio = false);
        });
      }
    }
  }

  void _playTargetVoice() {
    final current = _questions[_currentIndex];
    _playVoice(current.targetSentence, current.audioLanguageCode);
  }

  void _playEnglishVoice() {
    final current = _questions[_currentIndex];
    _playVoice(current.englishTranslation, 'en');
  }

  void _onWordTappedFromBank(String word) {
    if (_isChecked && _isCorrect) return;

    setState(() {
      _selectedWords.add(word);
      _availableWords.remove(word);
      _isChecked = false;
    });

    // Pronounce individual word lightly
    _playVoice(word, _questions[_currentIndex].audioLanguageCode);
  }

  void _onWordTappedFromAnswer(int index) {
    if (_isChecked && _isCorrect) return;

    setState(() {
      final removed = _selectedWords.removeAt(index);
      _availableWords.add(removed);
      _isChecked = false;
    });
  }

  void _checkAnswer() {
    if (_selectedWords.isEmpty) return;

    final current = _questions[_currentIndex];
    // Check match
    final cleanSelected = _selectedWords.map((w) => w.trim().toLowerCase()).toList();
    final cleanTarget = current.correctWords.map((w) => w.trim().toLowerCase()).toList();

    final isCorrect = cleanSelected.length == cleanTarget.length &&
        List.generate(cleanSelected.length, (i) => cleanSelected[i] == cleanTarget[i])
            .every((b) => b);

    setState(() {
      _isChecked = true;
      _isCorrect = isCorrect;
      if (!isCorrect) {
        _mistakeCount++;
      }
    });

    if (isCorrect) {
      _xpAnimController.forward(from: 0.0);
      _playTargetVoice();
    }
  }

  void _onNextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedWords.clear();
        _availableWords = List.from(_questions[_currentIndex].wordBank);
        _isChecked = false;
        _isCorrect = false;
        _showTranslation = false;
      });
      _playTargetVoice();
    } else {
      // Mission Complete! Show Completion Modal Dialog
      _showCompletionDialog();
    }
  }

  Widget _buildDynamicStar(int starIndex, double rating) {
    if (rating >= starIndex) {
      // Full green star
      return Icon(
        Icons.star_rounded,
        color: const Color(0xFF00D46A),
        size: 38.w,
      );
    } else if (rating >= starIndex - 0.5) {
      // Half star (green outline with left-half filled)
      return Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.star_border_rounded,
            color: const Color(0xFF00D46A),
            size: 38.w,
          ),
          ClipRect(
            clipper: _HalfClipper(),
            child: Icon(
              Icons.star_rounded,
              color: const Color(0xFF00D46A),
              size: 38.w,
            ),
          ),
        ],
      );
    } else {
      // Empty outline star for lost points
      return Icon(
        Icons.star_border_rounded,
        color: const Color(0xFFCBD5E1),
        size: 38.w,
      );
    }
  }

  void _showCompletionDialog() {
    _confettiController.play();

    // Dynamically calculate star rating, feedback text & bonus XP based on mistakes made:
    final double rating;
    final String feedbackText;
    final int earnedXp;

    if (_mistakeCount == 0) {
      // 0 mistakes: Perfect score! 3 full stars
      rating = 3.0;
      feedbackText = 'Perfect!';
      earnedXp = 30;
    } else if (_mistakeCount == 1) {
      // 1 mistake: Great job! 2.5 stars (matches screenshot with half star)
      rating = 2.5;
      feedbackText = 'Great Job!';
      earnedXp = 25;
    } else if (_mistakeCount == 2) {
      // 2 mistakes: 2 full stars
      rating = 2.0;
      feedbackText = 'Well Done!';
      earnedXp = 20;
    } else if (_mistakeCount == 3) {
      // 3 mistakes: 1.5 stars
      rating = 1.5;
      feedbackText = 'Good Effort!';
      earnedXp = 15;
    } else {
      // 4+ mistakes: 1 star
      rating = 1.0;
      feedbackText = 'Keep Practicing!';
      earnedXp = 10;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Main Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32.r),
                  border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.18),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 1. Glowing Checkmark Badge (matching reference)
                    Container(
                      width: 82.w,
                      height: 82.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE0F2FE), // Soft sky blue ring fill
                        border: Border.all(
                          color: const Color(0xFF7DD3FC), // Sky blue border
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 52.w,
                          height: 52.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF00D46A), // Solid emerald green
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 22.h),

                    // 2. Stars Row dynamically rendered based on mistakes made
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDynamicStar(1, rating),
                        SizedBox(width: 10.w),
                        _buildDynamicStar(2, rating),
                        SizedBox(width: 10.w),
                        _buildDynamicStar(3, rating),
                      ],
                    ),

                    SizedBox(height: 6.h),

                    // Dynamic feedback text based on accuracy
                    Text(
                      feedbackText,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                        letterSpacing: 0.2,
                      ),
                    ),

                    SizedBox(height: 18.h),

                    // 3. Dynamic XP Earned Capsule based on accuracy
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 9.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00D46A),
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00D46A).withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 6.w),
                          Text(
                            '+$earnedXp XP Earned',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 28.h),

                    // 4. Radiant "Next Level" CTA Button
                    GestureDetector(
                      onTap: () {
                        _confettiController.stop();
                        Navigator.of(ctx).pop(); // Close dialog
                        Navigator.of(context).pop(); // Return to Practice or Home
                        if (widget.onCompleted != null) widget.onCompleted!();
                      },
                      child: Container(
                        height: 54.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0066FF), Color(0xFF00D46A)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(27.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00D46A).withValues(alpha: 0.45),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Next Level',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 5. Confetti Explosive Blast Animation (confetti: ^0.8.0)
              Positioned(
                top: -16.h,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [
                    Color(0xFF00D46A),
                    Color(0xFF0066FF),
                    Color(0xFFFFB800),
                    Color(0xFFFF3366),
                    Color(0xFF8B5CF6),
                    Color(0xFF06B6D4),
                    Color(0xFFEC4899),
                  ],
                  numberOfParticles: 45,
                  emissionFrequency: 0.06,
                  gravity: 0.22,
                  maxBlastForce: 28,
                  minBlastForce: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = _questions[_currentIndex];
    final isForeignLanguage = current.audioLanguageCode.toLowerCase() != 'en';

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
                // 1. Top Header Bar (Back button + Segmented Progress Bar)
                _buildTopBar(),

                // 2. Question Content Body
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 12.h),

                        // Question Index Indicator & Floating +10 XP Coin Badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_currentIndex + 1}/${_questions.length}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            // +10 XP Floating Coin Animation
                            FadeTransition(
                              opacity: _xpOpacityAnimation,
                              child: ScaleTransition(
                                scale: _xpScaleAnimation,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFF59E0B), Color(0xFFEAB308)],
                                    ),
                                    borderRadius: BorderRadius.circular(16.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '+10',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      const Icon(Icons.monetization_on_rounded, color: Colors.white, size: 14),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 14.h),

                        // 3. AI Tutor Avatar & Speech Bubble with Voice & English Subtitle
                        _buildTutorPromptSection(current, isForeignLanguage),

                        SizedBox(height: 24.h),

                        // 4. Answer Slot Box (neutral / green / red states)
                        _buildAnswerSlotBox(),

                        SizedBox(height: 20.h),

                        // 5. Divider
                        Container(
                          height: 1,
                          color: const Color(0xFFE2E8F0),
                        ),

                        SizedBox(height: 20.h),

                        // 6. Word Bank Chips
                        _buildWordBank(),

                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),

                // 7. Bottom Action Button ("Check Answer" / "Next" / "Try Again")
                _buildBottomActionButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Top Bar with Back Arrow and Pill Progress Bar
  Widget _buildTopBar() {
    final progress = (_currentIndex + 1) / _questions.length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // Back Button
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

          // Capsule Segmented Progress Bar
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                height: 12.h,
                color: const Color(0xFF1E293B), // Dark capsule background matching design
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0066FF), Color(0xFF00D46A)],
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tutor Avatar & Speech Bubble
  Widget _buildTutorPromptSection(MissionQuestion current, bool isForeignLanguage) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI Tutor Studio Portrait with Halo
        Container(
          width: 58.w,
          height: 58.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0066FF).withValues(alpha: 0.15),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/tutor_mission.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFFE2E8F0),
                child: const Icon(Icons.face_3_rounded, color: Color(0xFF0066FF)),
              ),
            ),
          ),
        ),

        SizedBox(width: 12.w),

        // Speech Bubble
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF), // Soft lilac/blue bubble tint
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: const Color(0xFFE0E7FF), width: 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Speech Bubble Header & Speaker Audio Icon
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _isChecked && _isCorrect
                            ? 'Correct sentence ✓'
                            : 'Build the correct sentence',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w800,
                          color: _isChecked && _isCorrect
                              ? const Color(0xFF16A34A)
                              : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Voice Speaker Button (Speaks target sentence out loud)
                    GestureDetector(
                      onTap: _playTargetVoice,
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: _isPlayingAudio
                              ? const Color(0xFF00D46A)
                              : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isPlayingAudio ? Icons.graphic_eq_rounded : Icons.volume_up_rounded,
                          size: 16,
                          color: _isPlayingAudio ? Colors.white : const Color(0xFF0066FF),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 6.h),

                // Prompt sentence in quotes: Wrong/jumbled sentence to fix, replaced by correct sentence once solved!
                Text(
                  _isChecked && _isCorrect
                      ? '"${current.targetSentence}"'
                      : '"${current.wrongSentence}"',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: _isChecked && _isCorrect
                        ? const Color(0xFF16A34A)
                        : const Color(0xFF1E293B),
                    height: 1.3,
                  ),
                ),

                // English Translation Toggle / Card (When language is German, Spanish, French, etc.)
                if (isForeignLanguage) ...[
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () {
                      setState(() => _showTranslation = !_showTranslation);
                      if (_showTranslation) _playEnglishVoice();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: _showTranslation
                            ? Colors.white
                            : const Color(0xFF0066FF).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFF0066FF).withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _showTranslation ? Icons.translate_rounded : Icons.info_outline_rounded,
                            size: 13,
                            color: const Color(0xFF0066FF),
                          ),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              _showTranslation
                                  ? 'English: "${current.englishTranslation}"'
                                  : '🇬🇧 Tap to see English translation & voice',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0066FF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Answer Slot Box
  Widget _buildAnswerSlotBox() {
    Color borderColor;
    Color? fillColor;

    if (_isChecked) {
      if (_isCorrect) {
        borderColor = const Color(0xFF00D46A); // Bright Green
        fillColor = const Color(0xFFE8FDF0);
      } else {
        borderColor = const Color(0xFFEF4444); // Red/Coral
        fillColor = const Color(0xFFFEF2F2);
      }
    } else {
      borderColor = const Color(0xFF38BDF8); // Subtle Cyan/Blue
      fillColor = Colors.white;
    }

    return Container(
      constraints: BoxConstraints(minHeight: 100.h),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: borderColor,
          width: 1.8,
          style: BorderStyle.solid,
        ),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _selectedWords.isEmpty
          ? Center(
              child: Text(
                'Tap words below to build the sentence',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            )
          : Wrap(
              spacing: 8.w,
              runSpacing: 10.h,
              children: List.generate(_selectedWords.length, (index) {
                final word = _selectedWords[index];
                return _buildSelectedWordChip(word, index);
              }),
            ),
    );
  }

  // Placed Word Chip inside Answer Slot
  Widget _buildSelectedWordChip(String word, int index) {
    Color chipColor;
    Color textColor;

    if (_isChecked) {
      if (_isCorrect) {
        chipColor = const Color(0xFF00D46A); // Solid vibrant green
        textColor = Colors.white;
      } else {
        chipColor = const Color(0xFFF87171); // Soft coral red
        textColor = Colors.white;
      }
    } else {
      chipColor = const Color(0xFFF1F5F9); // Crisp grey
      textColor = const Color(0xFF0F172A);
    }

    return GestureDetector(
      onTap: () => _onWordTappedFromAnswer(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: chipColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: _isChecked
                ? chipColor
                : const Color(0xFFCBD5E1),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: chipColor.withValues(alpha: 0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          word,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }

  // Word Bank Chips Wrap
  Widget _buildWordBank() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8.w,
        runSpacing: 10.h,
        children: List.generate(_availableWords.length, (index) {
          final word = _availableWords[index];
          return GestureDetector(
            onTap: () => _onWordTappedFromBank(word),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                word,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Bottom Action Button
  Widget _buildBottomActionButton() {
    final hasWords = _selectedWords.isNotEmpty;

    String label;
    Color buttonColor;
    Gradient? gradient;
    VoidCallback? onTap;

    if (!_isChecked) {
      if (!hasWords) {
        label = 'Check Answer';
        buttonColor = const Color(0xFF64748B); // Disabled grey
        gradient = null;
        onTap = null;
      } else {
        label = 'Check answer';
        buttonColor = const Color(0xFF0066FF);
        gradient = const LinearGradient(
          colors: [Color(0xFF0066FF), Color(0xFF00D46A)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        );
        onTap = _checkAnswer;
      }
    } else {
      if (_isCorrect) {
        label = (_currentIndex < _questions.length - 1) ? 'Next' : 'Finish Mission';
        buttonColor = const Color(0xFF0066FF);
        gradient = const LinearGradient(
          colors: [Color(0xFF0066FF), Color(0xFF00D46A)],
        );
        onTap = _onNextQuestion;
      } else {
        label = 'Try Again';
        buttonColor = const Color(0xFFEF4444);
        gradient = const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
        );
        onTap = () {
          setState(() {
            _isChecked = false;
            // Move words back to bank
            _availableWords.addAll(_selectedWords);
            _selectedWords.clear();
          });
        };
      }
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 52.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: gradient == null ? buttonColor : null,
            gradient: gradient,
            borderRadius: BorderRadius.circular(26.r),
            boxShadow: hasWords || _isChecked
                ? [
                    BoxShadow(
                      color: (_isCorrect
                              ? const Color(0xFF00D46A)
                              : (_isChecked ? const Color(0xFFEF4444) : const Color(0xFF0066FF)))
                          .withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width / 2, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}
