import '../../domain/entities/wellness_challenge.dart';
import 'package:hive/hive.dart';

/// Repository untuk menyimpan challenge progress
class ChallengeRepository {
  static const String _boxName = 'challenge_progress';

  Future<Box<Map>> _getBox() async {
    return await Hive.openBox<Map>(_boxName);
  }

  /// Save challenge progress
  Future<void> saveProgress(ChallengeProgress progress) async {
    final box = await _getBox();
    await box.put(progress.challengeId, {
      'challengeId': progress.challengeId,
      'startDate': progress.startDate.toIso8601String(),
      'endDate': progress.endDate?.toIso8601String(),
      'completedDays': progress.completedDays,
      'isCompleted': progress.isCompleted,
      'currentDay': progress.currentDay,
    });
  }

  /// Get challenge progress
  Future<ChallengeProgress?> getProgress(String challengeId) async {
    final box = await _getBox();
    final data = box.get(challengeId);
    if (data == null) return null;

    return ChallengeProgress(
      challengeId: data['challengeId'] as String,
      startDate: DateTime.parse(data['startDate'] as String),
      endDate: data['endDate'] != null
          ? DateTime.parse(data['endDate'] as String)
          : null,
      completedDays: Map<int, bool>.from(data['completedDays'] as Map),
      isCompleted: data['isCompleted'] as bool,
      currentDay: data['currentDay'] as int,
    );
  }

  /// Get all active challenges
  Future<List<ChallengeProgress>> getActiveChallenges() async {
    final box = await _getBox();
    final allProgress = <ChallengeProgress>[];

    for (var key in box.keys) {
      final data = box.get(key);
      if (data != null) {
        final progress = ChallengeProgress(
          challengeId: data['challengeId'] as String,
          startDate: DateTime.parse(data['startDate'] as String),
          endDate: data['endDate'] != null
              ? DateTime.parse(data['endDate'] as String)
              : null,
          completedDays: Map<int, bool>.from(data['completedDays'] as Map),
          isCompleted: data['isCompleted'] as bool,
          currentDay: data['currentDay'] as int,
        );
        if (!progress.isCompleted) {
          allProgress.add(progress);
        }
      }
    }

    return allProgress;
  }

  /// Delete challenge progress
  Future<void> deleteProgress(String challengeId) async {
    final box = await _getBox();
    await box.delete(challengeId);
  }
}
