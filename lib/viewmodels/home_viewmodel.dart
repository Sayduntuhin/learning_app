import 'package:flutter/material.dart';
import '../models/language_model.dart';
import '../models/roadmap_node_model.dart';
import '../widgets/flag_icon_widget.dart';

class HomeViewModel extends ChangeNotifier {
  int _activeNavIndex = 0;
  int get activeNavIndex => _activeNavIndex;

  late String _currentLanguage;
  String get currentLanguage => _currentLanguage;

  late CountryFlag _currentFlag;
  CountryFlag get currentFlag => _currentFlag;

  final List<RoadmapNode> nodes = const [
    RoadmapNode(
      level: 8,
      title: 'GOAL',
      isGoal: true,
      xPercent: 0.39,
      yOffset: 75,
    ),
    RoadmapNode(
      level: 7,
      title: 'Level 7',
      isLocked: true,
      xPercent: 0.86,
      yOffset: 250,
    ),
    RoadmapNode(
      level: 6,
      title: 'Level 6',
      isLocked: true,
      xPercent: 0.52,
      yOffset: 310,
    ),
    RoadmapNode(
      level: 5,
      title: 'Level 5',
      isLocked: true,
      xPercent: 0.16,
      yOffset: 410,
    ),
    RoadmapNode(
      level: 4,
      title: 'Level 4',
      isLocked: true,
      xPercent: 0.48,
      yOffset: 500,
    ),
    RoadmapNode(
      level: 3,
      title: 'Level 3',
      isLocked: true,
      xPercent: 0.85,
      yOffset: 570,
    ),
    RoadmapNode(
      level: 2,
      title: 'Level 2',
      isCompleted: true,
      stars: 2,
      xPercent: 0.56,
      yOffset: 720,
    ),
    RoadmapNode(
      level: 1,
      title: 'Level 1',
      isCompleted: true,
      stars: 3,
      xPercent: 0.24,
      yOffset: 835,
    ),
  ];

  HomeViewModel({String? initialLanguage}) {
    _currentLanguage = initialLanguage ?? 'English';
    _currentFlag = LanguageOption.flagForLanguage(_currentLanguage);
  }

  void setActiveNavIndex(int index) {
    _activeNavIndex = index;
    notifyListeners();
  }

  void setLanguage(String language, CountryFlag flag) {
    _currentLanguage = language;
    _currentFlag = flag;
    notifyListeners();
  }
}
