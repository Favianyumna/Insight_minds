import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/wellness_challenge.dart';
import '../../data/local/challenge_repository.dart';
import '../../data/local/challenge_data.dart';

final challengeRepositoryProvider = Provider<ChallengeRepository>((ref) {
  return ChallengeRepository();
});

final predefinedChallengesProvider = Provider<List<WellnessChallenge>>((ref) {
  return ChallengeData.getPredefinedChallenges();
});

final activeChallengesProvider = FutureProvider<List<ChallengeProgress>>((ref) async {
  final repository = ref.read(challengeRepositoryProvider);
  return await repository.getActiveChallenges();
});

final selectedChallengeProvider = StateProvider<WellnessChallenge?>((ref) => null);

final challengeProgressProvider = FutureProvider.family<ChallengeProgress?, String>((ref, challengeId) async {
  final repository = ref.read(challengeRepositoryProvider);
  return await repository.getProgress(challengeId);
});
