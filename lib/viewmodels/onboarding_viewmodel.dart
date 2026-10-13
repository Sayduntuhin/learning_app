import 'package:flutter/material.dart';
import '../models/user_profile_model.dart';

class OnboardingViewModel extends ChangeNotifier {
  final UserProfile _profile = UserProfile();
  UserProfile get profile => _profile;

  void setName(String name) {
    _profile.name = name;
    notifyListeners();
  }

  void setAvatar({int avatarIndex = 0, String? avatarPath}) {
    _profile.avatarIndex = avatarIndex;
    _profile.avatarPath = avatarPath;
    notifyListeners();
  }

  void setLanguage(String language) {
    _profile.targetLanguage = language;
    notifyListeners();
  }

  void setGoal(String goal) {
    _profile.learningGoal = goal;
    notifyListeners();
  }

  void setLevel(String level) {
    _profile.currentLevel = level;
    notifyListeners();
  }

  void setPracticeTime(String time) {
    _profile.dailyPracticeTime = time;
    notifyListeners();
  }
}
