// Enhanced AI Provider dengan multi-factor analysis
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecase/enhanced_predict_risk_ai.dart';
import '../../domain/usecase/predict_risk_ai.dart';
import '../../data/models/feature_vector.dart';
import '../../../mood/data/local/mood_entry.dart';
import '../../../habit/data/local/habit_entry.dart';

/// Provider untuk instance EnhancedPredictRiskAI (Dependency Injection).
final enhancedAiPredictorProvider = Provider<EnhancedPredictRiskAI>((ref) {
  return EnhancedPredictRiskAI();
});

/// Provider untuk instance PredictRiskAI (backward compatibility).
final aiPredictorProvider = Provider<PredictRiskAI>((ref) {
  return PredictRiskAI();
});

/// Input data untuk enhanced AI prediction.
class EnhancedAIInput {
  final FeatureVector featureVector;
  final List<MoodEntry> recentMoods;
  final List<HabitEntry> recentHabits;

  const EnhancedAIInput({
    required this.featureVector,
    this.recentMoods = const [],
    this.recentHabits = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnhancedAIInput &&
          runtimeType == other.runtimeType &&
          featureVector == other.featureVector &&
          recentMoods == other.recentMoods &&
          recentHabits == other.recentHabits;

  @override
  int get hashCode =>
      featureVector.hashCode ^
      recentMoods.hashCode ^
      recentHabits.hashCode;
}

/// Provider family untuk hasil prediksi enhanced AI.
///
/// Menggunakan Provider.family untuk menerima EnhancedAIInput sebagai parameter.
/// Ketika dipanggil dengan ref.watch(enhancedAiResultProvider(input)), akan:
/// - Mengambil instance EnhancedPredictRiskAI dari enhancedAiPredictorProvider
/// - Menjalankan prediksi dengan input yang diberikan
/// - Mengembalikan Map berisi weightedScore, riskLevel, confidence, trend, recommendations, dan factors
final enhancedAiResultProvider =
    Provider.family<Map<String, dynamic>, EnhancedAIInput>((ref, input) {
  final model = ref.watch(enhancedAiPredictorProvider);
  return model.predict(
    featureVector: input.featureVector,
    recentMoods: input.recentMoods,
    recentHabits: input.recentHabits,
  );
});

/// Provider untuk backward compatibility dengan PredictRiskAI.
final aiResultProvider =
    Provider.family<Map<String, dynamic>, FeatureVector>((ref, fv) {
  final model = ref.watch(aiPredictorProvider);
  return model.predict(fv);
});
