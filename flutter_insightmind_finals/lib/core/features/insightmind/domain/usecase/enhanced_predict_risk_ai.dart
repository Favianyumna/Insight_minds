// Enhanced PredictRiskAI dengan multi-factor analysis
import '../../data/models/feature_vector.dart';
import '../../../mood/data/local/mood_entry.dart';
import '../../../habit/data/local/habit_entry.dart';

/// Enhanced AI untuk prediksi risiko mental health dengan analisis multi-factor.
///
/// Menggunakan data dari:
/// - FeatureVector (screening, activity, PPG)
/// - Mood entries (historical mood data)
/// - Habit entries (habit completion patterns)
///
/// Menghasilkan prediksi yang lebih akurat dengan context yang lebih lengkap.
class EnhancedPredictRiskAI {
  /// Melakukan prediksi risiko dengan analisis multi-factor.
  ///
  /// [featureVector] - Data dari screening dan sensor
  /// [recentMoods] - Data mood terakhir (30 hari)
  /// [recentHabits] - Data habit terakhir (30 hari)
  ///
  /// Returns Map dengan keys:
  /// - 'weightedScore': Skor tertimbang hasil perhitungan
  /// - 'riskLevel': Level risiko ('Tinggi', 'Sedang', atau 'Rendah')
  /// - 'confidence': Tingkat kepercayaan prediksi (0.3 - 0.95)
  /// - 'trend': Trend kesehatan mental ('Meningkat', 'Menurun', 'Stabil')
  /// - 'recommendations': List rekomendasi berdasarkan analisis
  /// - 'factors': Map faktor yang mempengaruhi risiko
  Map<String, dynamic> predict({
    required FeatureVector featureVector,
    List<MoodEntry> recentMoods = const [],
    List<HabitEntry> recentHabits = const [],
  }) {
    // 1. Base Score dari FeatureVector (sama seperti PredictRiskAI)
    double baseScore = featureVector.screeningScore * 0.6 +
        (featureVector.activityVar * 10) * 0.2 +
        (featureVector.ppgVar * 1000) * 0.2;

    // 2. Mood Factor (30% dari total score)
    double moodFactor = _calculateMoodFactor(recentMoods);
    double moodContribution = moodFactor * 0.3;

    // 3. Habit Factor (10% dari total score)
    double habitFactor = _calculateHabitFactor(recentHabits);
    double habitContribution = habitFactor * 0.1;

    // 4. Combined Weighted Score
    double weightedScore =
        baseScore * 0.6 + moodContribution + habitContribution;

    // 5. Trend Analysis
    String trend = _analyzeTrend(recentMoods, baseScore);

    // 6. Risk Level
    String riskLevel = _determineRiskLevel(weightedScore, trend);

    // 7. Confidence Score (lebih tinggi jika ada lebih banyak data)
    double confidence = _calculateConfidence(
      recentMoods.length,
      recentHabits.length,
      weightedScore,
    );

    // 8. Recommendations
    List<String> recommendations = _generateRecommendations(
      riskLevel,
      trend,
      moodFactor,
      habitFactor,
      recentMoods,
      recentHabits,
    );

    // 9. Factors Analysis
    Map<String, dynamic> factors = {
      'screeningScore': featureVector.screeningScore,
      'activityVariance': featureVector.activityVar,
      'ppgVariance': featureVector.ppgVar,
      'moodFactor': moodFactor,
      'habitFactor': habitFactor,
      'trend': trend,
    };

    return {
      'weightedScore': weightedScore,
      'riskLevel': riskLevel,
      'confidence': confidence.clamp(0.3, 0.95),
      'trend': trend,
      'recommendations': recommendations,
      'factors': factors,
      'baseScore': baseScore,
      'moodContribution': moodContribution,
      'habitContribution': habitContribution,
    };
  }

  /// Menghitung faktor mood berdasarkan historical data.
  ///
  /// Returns: 0.0 (sangat buruk) - 1.0 (sangat baik)
  double _calculateMoodFactor(List<MoodEntry> moods) {
    if (moods.isEmpty) return 0.5; // Neutral jika tidak ada data

    // Rata-rata mood rating (1-10 scale)
    double avgMood = moods
            .map((m) => m.effectiveMoodRating.toDouble())
            .reduce((a, b) => a + b) /
        moods.length;

    // Normalisasi ke 0.0-1.0 (1 = sangat baik, 0 = sangat buruk)
    // Mood 10 = 1.0, Mood 1 = 0.0
    double normalizedMood = (avgMood - 1) / 9;

    // Analisis trend mood (mood terakhir lebih penting)
    if (moods.length >= 7) {
      final recent7Days = moods.sublist(moods.length - 7);
      final olderMoods = moods.sublist(0, moods.length - 7);

      double recentAvg = recent7Days
              .map((m) => m.effectiveMoodRating.toDouble())
              .reduce((a, b) => a + b) /
          recent7Days.length;

      double olderAvg = olderMoods
              .map((m) => m.effectiveMoodRating.toDouble())
              .reduce((a, b) => a + b) /
          olderMoods.length;

      // Jika mood menurun, kurangi faktor
      if (recentAvg < olderAvg - 1) {
        normalizedMood *= 0.8; // Penalty untuk trend menurun
      } else if (recentAvg > olderAvg + 1) {
        normalizedMood *= 1.1; // Bonus untuk trend meningkat
      }
    }

    // Invert: mood tinggi = risiko rendah
    return (1.0 - normalizedMood).clamp(0.0, 1.0);
  }

  /// Menghitung faktor habit berdasarkan completion rate.
  ///
  /// Returns: 0.0 (tidak ada habit) - 1.0 (habit sangat baik)
  double _calculateHabitFactor(List<HabitEntry> habits) {
    if (habits.isEmpty) return 0.5; // Neutral jika tidak ada habit

    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    double totalCompletionRate = 0.0;
    int validHabits = 0;

    for (final habit in habits) {
      final recentCompletions =
          habit.completedDates.where((d) => d.isAfter(thirtyDaysAgo)).length;

      // Completion rate untuk 30 hari terakhir
      double completionRate = recentCompletions / 30.0;

      // Hanya hitung habit yang sudah ada minimal 7 hari
      if (habit.createdAt
          .isBefore(thirtyDaysAgo.add(const Duration(days: 7)))) {
        totalCompletionRate += completionRate;
        validHabits++;
      }
    }

    if (validHabits == 0) return 0.5;

    double avgCompletionRate = totalCompletionRate / validHabits;

    // Invert: completion rate tinggi = risiko rendah
    return (1.0 - avgCompletionRate).clamp(0.0, 1.0);
  }

  /// Menganalisis trend kesehatan mental.
  String _analyzeTrend(List<MoodEntry> moods, double currentScore) {
    if (moods.length < 7) return 'Stabil'; // Tidak cukup data

    // Analisis mood trend
    final recent7Days = moods.sublist(moods.length - 7);
    final previous7Days = moods.length >= 14
        ? moods.sublist(moods.length - 14, moods.length - 7)
        : [];

    if (previous7Days.isEmpty) return 'Stabil';

    double recentAvg = recent7Days
            .map((m) => m.effectiveMoodRating.toDouble())
            .reduce((a, b) => a + b) /
        recent7Days.length;

    double previousAvg = previous7Days
            .map((m) => m.effectiveMoodRating.toDouble())
            .reduce((a, b) => a + b) /
        previous7Days.length;

    double moodDifference = recentAvg - previousAvg;

    // Kombinasi dengan current score
    if (currentScore > 20 && moodDifference < -1) {
      return 'Menurun'; // Score tinggi + mood menurun = risiko meningkat
    } else if (currentScore < 15 && moodDifference > 1) {
      return 'Meningkat'; // Score rendah + mood meningkat = risiko menurun
    } else if (moodDifference.abs() < 0.5) {
      return 'Stabil';
    } else {
      return moodDifference > 0 ? 'Meningkat' : 'Menurun';
    }
  }

  /// Menentukan level risiko berdasarkan score dan trend.
  String _determineRiskLevel(double weightedScore, String trend) {
    // Adjust threshold berdasarkan trend
    double thresholdHigh = 25.0;
    double thresholdMedium = 12.0;

    if (trend == 'Menurun') {
      thresholdHigh -= 2.0; // Lebih sensitif jika trend menurun
      thresholdMedium -= 1.0;
    } else if (trend == 'Meningkat') {
      thresholdHigh += 2.0; // Lebih toleran jika trend meningkat
      thresholdMedium += 1.0;
    }

    if (weightedScore > thresholdHigh) {
      return 'Tinggi';
    } else if (weightedScore > thresholdMedium) {
      return 'Sedang';
    } else {
      return 'Rendah';
    }
  }

  /// Menghitung confidence score berdasarkan jumlah data.
  double _calculateConfidence(
    int moodDataCount,
    int habitDataCount,
    double weightedScore,
  ) {
    // Base confidence dari score consistency
    double baseConfidence = (weightedScore / 30).clamp(0.3, 0.95);

    // Bonus untuk data yang cukup
    double dataBonus = 0.0;
    if (moodDataCount >= 14) dataBonus += 0.1;
    if (moodDataCount >= 30) dataBonus += 0.05;
    if (habitDataCount >= 3) dataBonus += 0.05;

    return (baseConfidence + dataBonus).clamp(0.3, 0.95);
  }

  /// Generate rekomendasi berdasarkan analisis.
  List<String> _generateRecommendations(
    String riskLevel,
    String trend,
    double moodFactor,
    double habitFactor,
    List<MoodEntry> moods,
    List<HabitEntry> habits,
  ) {
    final recommendations = <String>[];

    // Risk level based recommendations
    if (riskLevel == 'Tinggi') {
      recommendations.add(
          'Pertimbangkan untuk berkonsultasi dengan profesional kesehatan mental');
      recommendations
          .add('Coba teknik relaksasi seperti meditasi atau deep breathing');
    } else if (riskLevel == 'Sedang') {
      recommendations.add('Pantau kondisi Anda secara rutin');
      recommendations.add('Jaga pola tidur dan aktivitas fisik yang teratur');
    }

    // Trend based recommendations
    if (trend == 'Menurun') {
      recommendations.add('Perhatikan pola yang menyebabkan penurunan mood');
      recommendations.add('Coba identifikasi dan hindari trigger yang negatif');
    } else if (trend == 'Meningkat') {
      recommendations
          .add('Pertahankan aktivitas yang membuat mood Anda membaik');
    }

    // Mood factor based recommendations
    if (moodFactor > 0.7) {
      recommendations
          .add('Mood Anda cenderung rendah, coba aktivitas yang menyenangkan');
    }

    // Habit factor based recommendations
    if (habitFactor > 0.6 && habits.isNotEmpty) {
      recommendations
          .add('Tingkatkan konsistensi dalam menyelesaikan habit positif');
    } else if (habits.isEmpty) {
      recommendations.add('Pertimbangkan untuk membuat habit positif baru');
    }

    // Sleep analysis
    if (moods.isNotEmpty) {
      final avgSleep = moods
              .where((m) => m.sleepHours != null)
              .map((m) => m.sleepHours!)
              .fold(0.0, (a, b) => a + b) /
          moods.where((m) => m.sleepHours != null).length;

      if (avgSleep < 6.0) {
        recommendations
            .add('Tidur kurang dari 6 jam dapat mempengaruhi kesehatan mental');
      } else if (avgSleep > 9.0) {
        recommendations
            .add('Tidur lebih dari 9 jam mungkin perlu diperhatikan');
      }
    }

    // Activity analysis
    if (moods.isNotEmpty) {
      final avgActivity = moods
              .where((m) => m.physicalActivityMinutes != null)
              .map((m) => m.physicalActivityMinutes!.toDouble())
              .fold(0.0, (a, b) => a + b) /
          moods.where((m) => m.physicalActivityMinutes != null).length;

      if (avgActivity < 30) {
        recommendations
            .add('Coba tingkatkan aktivitas fisik minimal 30 menit per hari');
      }
    }

    return recommendations.take(5).toList(); // Maksimal 5 rekomendasi
  }
}
