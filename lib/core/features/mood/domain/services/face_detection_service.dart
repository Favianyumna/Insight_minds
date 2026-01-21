import 'package:camera/camera.dart';

class FaceDetectionResult {
  final bool faceFound;
  final XFile? imageFile; // Gambar yang diambil dari kamera
  const FaceDetectionResult({
    required this.faceFound,
    this.imageFile,
  });
}

abstract class FaceDetectionService {
  Future<FaceDetectionResult> detectFaceFromPreviewFrame(CameraController cameraController);
}


