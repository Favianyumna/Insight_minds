/// Entity untuk Wellness Challenge
class WellnessChallenge {
  final String id;
  final String title;
  final String description;
  final int durationDays;
  final List<String> dailyTasks;
  final String category; // 'mindfulness', 'physical', 'social', 'self-care'
  final String difficulty; // 'easy', 'medium', 'hard'
  final String? icon;
  final String color;

  WellnessChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.durationDays,
    required this.dailyTasks,
    required this.category,
    required this.difficulty,
    this.icon,
    required this.color,
  });
}

/// Entity untuk Challenge Progress
class ChallengeProgress {
  final String challengeId;
  final DateTime startDate;
  final DateTime? endDate;
  final Map<int, bool> completedDays; // day number -> completed
  final bool isCompleted;
  final int currentDay;

  ChallengeProgress({
    required this.challengeId,
    required this.startDate,
    this.endDate,
    required this.completedDays,
    required this.isCompleted,
    required this.currentDay,
  });

  double get completionPercentage {
    if (completedDays.isEmpty) return 0.0;
    final completedCount = completedDays.values.where((v) => v).length;
    return completedCount / completedDays.length;
  }

  int get streak {
    int streak = 0;
    for (int i = 1; i <= currentDay; i++) {
      if (completedDays[i] == true) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
}
