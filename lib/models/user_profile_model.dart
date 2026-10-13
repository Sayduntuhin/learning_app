class UserProfile {
  String? name;
  String? avatarPath;
  int avatarIndex;
  String? targetLanguage;
  String? learningGoal;
  String? currentLevel;
  String? dailyPracticeTime;

  UserProfile({
    this.name,
    this.avatarPath,
    this.avatarIndex = 0,
    this.targetLanguage,
    this.learningGoal,
    this.currentLevel,
    this.dailyPracticeTime,
  });

  UserProfile copyWith({
    String? name,
    String? avatarPath,
    int? avatarIndex,
    String? targetLanguage,
    String? learningGoal,
    String? currentLevel,
    String? dailyPracticeTime,
  }) {
    return UserProfile(
      name: name ?? this.name,
      avatarPath: avatarPath ?? this.avatarPath,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      learningGoal: learningGoal ?? this.learningGoal,
      currentLevel: currentLevel ?? this.currentLevel,
      dailyPracticeTime: dailyPracticeTime ?? this.dailyPracticeTime,
    );
  }
}
