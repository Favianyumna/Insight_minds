import 'package:camera/camera.dart';

class EmotionInferenceResult {
  final String label; // e.g., happy, neutral, sad, angry, surprised
  final double confidence; // 0.0 - 1.0
  final XFile? imageFile; // Gambar yang dianalisis
  const EmotionInferenceResult({
    required this.label,
    required this.confidence,
    this.imageFile,
  });
}

abstract class EmotionModelService {
  Future<EmotionInferenceResult> inferFromFacePreview(
    CameraController cameraController,
    XFile imageFile,
  );
}


