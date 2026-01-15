# 🤖 Panduan Penggunaan Enhanced AI System

## 📋 Overview

Sistem AI InsightMind telah ditingkatkan dengan **Enhanced PredictRiskAI** yang menggunakan analisis multi-factor untuk prediksi risiko mental health yang lebih akurat.

---

## 🆚 Perbandingan: AI Lama vs AI Baru

### **AI Lama (PredictRiskAI)**
- ✅ Rule-based sederhana
- ✅ Menggunakan FeatureVector saja
- ✅ Output: weightedScore, riskLevel, confidence

### **AI Baru (Enhanced PredictRiskAI)**
- ✅ Multi-factor analysis
- ✅ Menggunakan FeatureVector + Mood + Habit data
- ✅ Output: weightedScore, riskLevel, confidence, **trend**, **recommendations**, **factors**

---

## 🚀 Cara Menggunakan Enhanced AI

### **1. Import Provider**

```dart
import 'package:insightmind_app/core/features/insightmind/presentation/providers/enhanced_ai_provider.dart';
import 'package:insightmind_app/core/features/insightmind/data/models/feature_vector.dart';
import 'package:insightmind_app/core/features/mood/data/local/mood_entry.dart';
import 'package:insightmind_app/core/features/habit/data/local/habit_entry.dart';
```

### **2. Siapkan Data**

```dart
// FeatureVector dari screening
final featureVector = FeatureVector(
  screeningScore: 15.0,
  activityMean: 0.5,
  activityVar: 0.3,
  ppgMean: 0.7,
  ppgVar: 0.2,
);

// Mood entries (30 hari terakhir)
final recentMoods = moodEntries
    .where((m) => m.timestamp.isAfter(DateTime.now().subtract(Duration(days: 30))))
    .toList();

// Habit entries
final recentHabits = habitEntries;
```

### **3. Buat Input**

```dart
final input = EnhancedAIInput(
  featureVector: featureVector,
  recentMoods: recentMoods,
  recentHabits: recentHabits,
);
```

### **4. Gunakan Provider di Widget**

```dart
class MyWidget extends ConsumerWidget {
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

    return Text('Risk Level: $riskLevel, Trend: $trend');
  }
}
```

### **5. Navigasi ke Enhanced AI Result Page**

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => EnhancedAIResultPage(
      featureVector: featureVector,
      recentMoods: recentMoods,
      recentHabits: recentHabits,
    ),
  ),
);
```

---

## 📊 Output Enhanced AI

### **1. Risk Level**
- `'Tinggi'` - Risiko tinggi, perlu perhatian serius
- `'Sedang'` - Risiko sedang, perlu monitoring
- `'Rendah'` - Risiko rendah, kondisi baik

### **2. Trend**
- `'Meningkat'` - Kondisi membaik
- `'Menurun'` - Kondisi memburuk
- `'Stabil'` - Kondisi stabil

### **3. Weighted Score**
Skor tertimbang yang menggabungkan:
- Base Score (60%) - dari FeatureVector
- Mood Contribution (30%) - dari historical mood
- Habit Contribution (10%) - dari habit completion

### **4. Confidence**
Tingkat kepercayaan prediksi (0.3 - 0.95):
- Semakin banyak data → confidence lebih tinggi
- Minimal 14 hari mood data untuk confidence optimal

### **5. Recommendations**
List rekomendasi personal berdasarkan:
- Risk level
- Trend analysis
- Mood patterns
- Habit completion
- Sleep patterns
- Activity levels

### **6. Factors**
Map faktor yang mempengaruhi risiko:
- `screeningScore` - Skor dari kuisioner
- `activityVariance` - Variansi aktivitas
- `ppgVariance` - Variansi PPG
- `moodFactor` - Faktor mood (0.0-1.0)
- `habitFactor` - Faktor habit (0.0-1.0)
- `trend` - Trend kesehatan mental

---

## 🎯 Contoh Penggunaan Lengkap

### **Contoh 1: Basic Usage**

```dart
final featureVector = FeatureVector(
  screeningScore: 18.0,
  activityMean: 0.6,
  activityVar: 0.4,
  ppgMean: 0.8,
  ppgVar: 0.3,
);

final input = EnhancedAIInput(
  featureVector: featureVector,
  recentMoods: [], // Tidak ada mood data
  recentHabits: [], // Tidak ada habit data
);

final result = ref.watch(enhancedAiResultProvider(input));
// Akan menggunakan base score saja
```

### **Contoh 2: Dengan Mood Data**

```dart
final recentMoods = [
  MoodEntry(
    id: '1',
    timestamp: DateTime.now().subtract(Duration(days: 1)),
    mood: 3,
    moodRating: 6,
  ),
  MoodEntry(
    id: '2',
    timestamp: DateTime.now().subtract(Duration(days: 2)),
    mood: 2,
    moodRating: 4,
  ),
  // ... lebih banyak mood entries
];

final input = EnhancedAIInput(
  featureVector: featureVector,
  recentMoods: recentMoods,
  recentHabits: [],
);

final result = ref.watch(enhancedAiResultProvider(input));
// Akan menggunakan base score + mood analysis
```

### **Contoh 3: Full Data**

```dart
final input = EnhancedAIInput(
  featureVector: featureVector,
  recentMoods: recentMoods, // 30 hari terakhir
  recentHabits: recentHabits, // Semua habits
);

final result = ref.watch(enhancedAiResultProvider(input));
// Akan menggunakan semua faktor untuk prediksi yang lebih akurat
```

---

## 🔄 Backward Compatibility

AI lama (`PredictRiskAI`) masih tersedia untuk backward compatibility:

```dart
// Menggunakan AI lama
final result = ref.watch(aiResultProvider(featureVector));
// Output: weightedScore, riskLevel, confidence (tanpa trend & recommendations)
```

---

## 📈 Tips Penggunaan

### **1. Kumpulkan Data Sebanyak Mungkin**
- Minimal 14 hari mood data untuk hasil optimal
- Semakin banyak data → semakin akurat prediksi

### **2. Update Data Secara Rutin**
- Update mood entries setiap hari
- Update habit completion setiap hari
- Data terbaru lebih penting dari data lama

### **3. Gunakan Recommendations**
- Recommendations dibuat berdasarkan analisis personal
- Ikuti recommendations untuk meningkatkan kesehatan mental

### **4. Monitor Trend**
- Trend "Menurun" → perlu perhatian lebih
- Trend "Meningkat" → pertahankan aktivitas positif
- Trend "Stabil" → kondisi baik, tetap monitor

---

## 🎨 UI Components

### **EnhancedAIResultPage**
Halaman lengkap untuk menampilkan hasil prediksi dengan:
- Risk level card dengan trend indicator
- Score breakdown (base, mood, habit)
- Factors analysis
- Personalized recommendations

**Penggunaan:**
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => EnhancedAIResultPage(
      featureVector: featureVector,
      recentMoods: recentMoods,
      recentHabits: recentHabits,
    ),
  ),
);
```

---

## 🔧 Advanced Usage

### **Custom Analysis**

```dart
final enhancedAI = EnhancedPredictRiskAI();

final result = enhancedAI.predict(
  featureVector: featureVector,
  recentMoods: recentMoods,
  recentHabits: recentHabits,
);

// Akses semua data
final factors = result['factors'] as Map<String, dynamic>;
final moodFactor = factors['moodFactor'] as double;
final habitFactor = factors['habitFactor'] as double;
```

---

## 📝 Notes

1. **Data Privacy**: Semua data diproses lokal, tidak dikirim ke server
2. **Performance**: Enhanced AI lebih lambat dari AI sederhana karena analisis lebih kompleks
3. **Accuracy**: Enhanced AI lebih akurat dengan lebih banyak data
4. **Fallback**: Jika tidak ada mood/habit data, akan menggunakan base score saja

---

## 🎉 Kesimpulan

Enhanced AI System memberikan:
- ✅ Prediksi yang lebih akurat
- ✅ Analisis multi-factor
- ✅ Trend analysis
- ✅ Personalized recommendations
- ✅ Factors breakdown

**Gunakan Enhanced AI untuk hasil yang lebih baik!** 🚀
