class RoadmapNode {
  final int level;
  final String title;
  final bool isCompleted;
  final bool isLocked;
  final bool isGoal;
  final int stars; // 0 to 3 stars
  final double xPercent; // 0.0 to 1.0 relative to screen width
  final double yOffset; // y position in roadmap canvas

  const RoadmapNode({
    required this.level,
    required this.title,
    this.isCompleted = false,
    this.isLocked = false,
    this.isGoal = false,
    this.stars = 0,
    required this.xPercent,
    required this.yOffset,
  });
}
