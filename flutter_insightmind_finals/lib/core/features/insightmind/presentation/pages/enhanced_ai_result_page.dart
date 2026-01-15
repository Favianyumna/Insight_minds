// Enhanced AI Result Page dengan multi-factor analysis
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/enhanced_ai_provider.dart';
import '../../data/models/feature_vector.dart';
import '../../../mood/data/local/mood_entry.dart';
import '../../../habit/data/local/habit_entry.dart';

/// Enhanced UI untuk menampilkan hasil prediksi AI dengan analisis multi-factor.
///
/// Menampilkan:
/// - Risk level dengan trend analysis
/// - Weighted score breakdown
/// - Factors analysis
/// - Personalized recommendations
class EnhancedAIResultPage extends ConsumerWidget {
  final FeatureVector featureVector;
  final List<MoodEntry> recentMoods;
  final List<HabitEntry> recentHabits;

  const EnhancedAIResultPage({
    super.key,
    required this.featureVector,
    this.recentMoods = const [],
    this.recentHabits = const [],
  });

  /// Mendapatkan warna berdasarkan risk level
  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'tinggi':
        return Colors.red;
      case 'sedang':
        return Colors.orange;
      case 'rendah':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Mendapatkan icon berdasarkan risk level
  IconData _getRiskIcon(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'tinggi':
        return Icons.warning;
      case 'sedang':
        return Icons.info;
      case 'rendah':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  /// Mendapatkan icon berdasarkan trend
  IconData _getTrendIcon(String trend) {
    switch (trend.toLowerCase()) {
      case 'meningkat':
        return Icons.trending_up;
      case 'menurun':
        return Icons.trending_down;
      case 'stabil':
        return Icons.trending_flat;
      default:
        return Icons.trending_flat;
    }
  }

  /// Mendapatkan warna berdasarkan trend
  Color _getTrendColor(String trend) {
    switch (trend.toLowerCase()) {
      case 'meningkat':
        return Colors.green;
      case 'menurun':
        return Colors.red;
      case 'stabil':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = EnhancedAIInput(
      featureVector: featureVector,
      recentMoods: recentMoods,
      recentHabits: recentHabits,
    );

    final result = ref.watch(enhancedAiResultProvider(input));

    final riskLevel = result['riskLevel'] as String;
    final weightedScore = result['weightedScore'] as double;
    final confidence = result['confidence'] as double;
    final trend = result['trend'] as String;
    final recommendations = result['recommendations'] as List<String>;
    final factors = result['factors'] as Map<String, dynamic>;
    final baseScore = result['baseScore'] as double;
    final moodContribution = result['moodContribution'] as double;
    final habitContribution = result['habitContribution'] as double;

    final riskColor = _getRiskColor(riskLevel);
    final riskIcon = _getRiskIcon(riskLevel);
    final trendIcon = _getTrendIcon(trend);
    final trendColor = _getTrendColor(trend);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Prediksi AI (Enhanced)'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Risk Level Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 8,
              // ignore: deprecated_member_use
              shadowColor: riskColor.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      riskIcon,
                      size: 80,
                      color: riskColor,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Tingkat Risiko',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      riskLevel,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: riskColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Trend Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(trendIcon, color: trendColor, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Trend: $trend',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: trendColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Score Breakdown Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Score Breakdown',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildScoreRow('Base Score', baseScore, Colors.blue),
                    _buildScoreRow('Mood Contribution', moodContribution, Colors.purple),
                    _buildScoreRow('Habit Contribution', habitContribution, Colors.orange),
                    const Divider(height: 32),
                    _buildScoreRow(
                      'Total Weighted Score',
                      weightedScore,
                      riskColor,
                      isBold: true,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Confidence:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${(confidence * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Factors Analysis Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Faktor yang Mempengaruhi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFactorRow('Screening Score', factors['screeningScore'] as double),
                    _buildFactorRow('Activity Variance', factors['activityVariance'] as double),
                    _buildFactorRow('PPG Variance', factors['ppgVariance'] as double),
                    _buildFactorRow('Mood Factor', factors['moodFactor'] as double),
                    _buildFactorRow('Habit Factor', factors['habitFactor'] as double),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Recommendations Card
            if (recommendations.isNotEmpty)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.lightbulb, color: Colors.amber),
                          SizedBox(width: 8),
                          Text(
                            'Rekomendasi',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...recommendations.map((rec) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle,
                                    color: Colors.green, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    rec,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRow(String label, double value, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              fontSize: isBold ? 20 : 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactorRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: _getFactorColor(value).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _getFactorColor(value),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getFactorColor(double value) {
    if (value > 0.7) return Colors.red;
    if (value > 0.4) return Colors.orange;
    return Colors.green;
  }
}
