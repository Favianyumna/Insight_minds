import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/challenge_providers.dart';
import '../../domain/entities/wellness_challenge.dart';

/// Halaman Wellness Challenges
class WellnessChallengesPage extends ConsumerWidget {
  const WellnessChallengesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenges = ref.watch(predefinedChallengesProvider);
    final activeChallengesAsync = ref.watch(activeChallengesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness Challenges'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Colors.orange.shade400, Colors.orange.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Wellness Challenges',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tantangan untuk meningkatkan kesehatan mental Anda',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Active Challenges
          activeChallengesAsync.when(
            data: (activeChallenges) {
              if (activeChallenges.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Challenge Aktif',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...activeChallenges.map((progress) {
                      final challenge = challenges.firstWhere(
                        (c) => c.id == progress.challengeId,
                        orElse: () => challenges.first,
                      );
                      return _buildActiveChallengeCard(
                        context,
                        ref,
                        challenge,
                        progress,
                      );
                    }),
                    const SizedBox(height: 24),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Available Challenges
          const Text(
            'Challenge Tersedia',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...challenges.map((challenge) {
            return _buildChallengeCard(context, ref, challenge);
          }),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(
    BuildContext context,
    WidgetRef ref,
    WellnessChallenge challenge,
  ) {
    final color = _getColorFromString(challenge.color);
    final difficultyColor = _getDifficultyColor(challenge.difficulty);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showChallengeDetail(context, ref, challenge),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(challenge.category),
                      color: color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          challenge.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Chip(
                    label: Text('${challenge.durationDays} hari'),
                    backgroundColor: Colors.blue.shade50,
                    labelStyle: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(challenge.difficulty.toUpperCase()),
                    backgroundColor: difficultyColor.withValues(alpha: 0.2),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: difficultyColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(challenge.category),
                    backgroundColor: Colors.grey.shade100,
                    labelStyle: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveChallengeCard(
    BuildContext context,
    WidgetRef ref,
    WellnessChallenge challenge,
    progress,
  ) {
    final color = _getColorFromString(challenge.color);
    final percentage = progress.completionPercentage;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: 2),
      ),
      child: InkWell(
        onTap: () => _showChallengeProgress(context, ref, challenge, progress),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(challenge.category),
                      color: color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Hari ${progress.currentDay} dari ${challenge.durationDays}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${(percentage * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Streak: ${progress.streak} hari',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _markDayComplete(context, ref, challenge, progress),
                    child: const Text('Tandai Selesai Hari Ini'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChallengeDetail(
    BuildContext context,
    WidgetRef ref,
    WellnessChallenge challenge,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(challenge.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                challenge.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tugas Harian:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...challenge.dailyTasks.map((task) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_outline, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(task)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _startChallenge(context, ref, challenge);
            },
            child: const Text('Mulai Challenge'),
          ),
        ],
      ),
    );
  }

  void _startChallenge(
    BuildContext context,
    WidgetRef ref,
    WellnessChallenge challenge,
  ) async {
    final repository = ref.read(challengeRepositoryProvider);
    final progress = ChallengeProgress(
      challengeId: challenge.id,
      startDate: DateTime.now(),
      completedDays: {},
      isCompleted: false,
      currentDay: 1,
    );

    await repository.saveProgress(progress);
    ref.invalidate(activeChallengesProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${challenge.title} dimulai!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showChallengeProgress(
    BuildContext context,
    WidgetRef ref,
    WellnessChallenge challenge,
    progress,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(challenge.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Progress: ${(progress.completionPercentage * 100).toInt()}%'),
              const SizedBox(height: 8),
              Text('Streak: ${progress.streak} hari'),
              const SizedBox(height: 8),
              Text('Hari ${progress.currentDay} dari ${challenge.durationDays}'),
              const SizedBox(height: 16),
              const Text(
                'Tugas Hari Ini:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...challenge.dailyTasks.map((task) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          progress.completedDays[progress.currentDay] == true
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(task)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _markDayComplete(
    BuildContext context,
    WidgetRef ref,
    WellnessChallenge challenge,
    progress,
  ) async {
    final repository = ref.read(challengeRepositoryProvider);
    final updatedProgress = ChallengeProgress(
      challengeId: progress.challengeId,
      startDate: progress.startDate,
      endDate: progress.endDate,
      completedDays: {
        ...progress.completedDays,
        progress.currentDay: true,
      },
      isCompleted: progress.currentDay >= challenge.durationDays &&
          progress.completedDays[progress.currentDay] == true,
      currentDay: progress.currentDay,
    );

    await repository.saveProgress(updatedProgress);
    ref.invalidate(activeChallengesProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hari ini ditandai selesai! 🎉'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Color _getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'amber':
        return Colors.amber;
      case 'purple':
        return Colors.purple;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'pink':
        return Colors.pink;
      case 'teal':
        return Colors.teal;
      default:
        return Colors.indigo;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'mindfulness':
        return Icons.self_improvement;
      case 'physical':
        return Icons.fitness_center;
      case 'social':
        return Icons.people;
      case 'self-care':
        return Icons.spa;
      default:
        return Icons.star;
    }
  }
}
