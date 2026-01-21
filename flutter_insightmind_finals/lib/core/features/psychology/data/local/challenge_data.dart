import '../../domain/entities/wellness_challenge.dart';

/// Data untuk predefined challenges
class ChallengeData {
  static List<WellnessChallenge> getPredefinedChallenges() {
    return [
      WellnessChallenge(
        id: 'gratitude_7',
        title: '7 Hari Gratitude Challenge',
        description: 'Tuliskan 3 hal yang Anda syukuri setiap hari selama 7 hari',
        durationDays: 7,
        dailyTasks: [
          'Tuliskan 3 hal yang Anda syukuri hari ini',
          'Refleksikan momen positif hari ini',
          'Bagikan rasa syukur dengan seseorang',
        ],
        category: 'mindfulness',
        difficulty: 'easy',
        color: 'amber',
      ),
      WellnessChallenge(
        id: 'meditation_7',
        title: '7 Hari Meditasi Challenge',
        description: 'Meditasi 10 menit setiap hari selama 7 hari',
        durationDays: 7,
        dailyTasks: [
          'Meditasi 10 menit di pagi hari',
          'Fokus pada pernapasan',
          'Refleksikan perasaan setelah meditasi',
        ],
        category: 'mindfulness',
        difficulty: 'medium',
        color: 'purple',
      ),
      WellnessChallenge(
        id: 'exercise_7',
        title: '7 Hari Olahraga Challenge',
        description: 'Olahraga 30 menit setiap hari selama 7 hari',
        durationDays: 7,
        dailyTasks: [
          'Olahraga 30 menit (jalan, lari, atau aktivitas lainnya)',
          'Minum air yang cukup',
          'Catat perasaan setelah olahraga',
        ],
        category: 'physical',
        difficulty: 'medium',
        color: 'green',
      ),
      WellnessChallenge(
        id: 'social_7',
        title: '7 Hari Koneksi Sosial Challenge',
        description: 'Hubungi atau bertemu dengan seseorang setiap hari',
        durationDays: 7,
        dailyTasks: [
          'Hubungi teman atau keluarga',
          'Tanyakan kabar mereka',
          'Bagikan sesuatu yang positif',
        ],
        category: 'social',
        difficulty: 'easy',
        color: 'blue',
      ),
      WellnessChallenge(
        id: 'selfcare_7',
        title: '7 Hari Self-Care Challenge',
        description: 'Lakukan satu aktivitas self-care setiap hari',
        durationDays: 7,
        dailyTasks: [
          'Lakukan aktivitas yang membuat Anda bahagia',
          'Istirahat yang cukup',
          'Lakukan sesuatu yang menenangkan',
        ],
        category: 'self-care',
        difficulty: 'easy',
        color: 'pink',
      ),
      WellnessChallenge(
        id: 'mindfulness_14',
        title: '14 Hari Mindfulness Challenge',
        description: 'Praktik mindfulness setiap hari selama 14 hari',
        durationDays: 14,
        dailyTasks: [
          'Praktik mindfulness 15 menit',
          'Fokus pada momen saat ini',
          'Catat pengalaman mindfulness Anda',
        ],
        category: 'mindfulness',
        difficulty: 'hard',
        color: 'teal',
      ),
    ];
  }
}
