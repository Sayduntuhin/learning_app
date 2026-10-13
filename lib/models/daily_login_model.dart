class DailyLoginDay {
  final int dayNumber;
  final String title;
  final int xpReward;
  bool isClaimed;

  DailyLoginDay({
    required this.dayNumber,
    required this.title,
    this.xpReward = 20,
    this.isClaimed = false,
  });
}
