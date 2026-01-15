import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../providers/mood_scan_providers.dart';
import '../providers/mood_providers.dart';

class MoodScanPage extends ConsumerStatefulWidget {
  const MoodScanPage({super.key});

  @override
  ConsumerState<MoodScanPage> createState() => _MoodScanPageState();
}

class _MoodScanPageState extends ConsumerState<MoodScanPage> {
  CameraController? _cameraController;
  Future<void>? _initCameraFuture;

  @override
  void initState() {
    super.initState();
    _initCameraFuture = _initCamera();
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      throw Exception('Izin kamera ditolak');
    }
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    _cameraController = CameraController(front, ResolutionPreset.medium, enableAudio: false);
    await _cameraController!.initialize();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final isScanning = ref.watch(isScanningProvider);
    final result = ref.watch(lastInferenceProvider);

    Future<void> doScan() async {
      if (isScanning || _cameraController == null || !_cameraController!.value.isInitialized) {
        if (context.mounted && (_cameraController == null || !_cameraController!.value.isInitialized)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kamera belum siap. Tunggu sebentar...')),
          );
        }
        return;
      }

      ref.read(isScanningProvider.notifier).state = true;
      
      try {
        // Step 1: Deteksi wajah dari kamera
        final face = await ref.read(faceDetectionServiceProvider).detectFaceFromPreviewFrame(_cameraController!);
        
        if (!face.faceFound || face.imageFile == null) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Wajah tidak terdeteksi. Pastikan wajah terlihat jelas dan pencahayaan cukup.'),
                duration: Duration(seconds: 3),
              ),
            );
          }
          return;
        }

        // Step 2: Analisis emosi dari gambar wajah
        final inference = await ref.read(emotionModelServiceProvider).inferFromFacePreview(
          _cameraController!,
          face.imageFile!,
        );
        
        // Step 3: Simpan hasil inference
        ref.read(lastInferenceProvider.notifier).state = inference;

        // Tampilkan feedback sukses
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Mood terdeteksi: ${inference.label} (${(inference.confidence * 100).toStringAsFixed(0)}%)'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        // Handle error
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saat memindai: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } finally {
        ref.read(isScanningProvider.notifier).state = false;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Pindai Mood (Eksperimental)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Privasi'),
            const SizedBox(height: 4),
            const Text(
              'Fitur ini memproses gambar wajah secara lokal untuk memperkirakan mood. '
              'Kami tidak menyimpan foto. Anda dapat menyimpan hanya label dan tingkat keyakinan.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    FutureBuilder(
                      future: _initCameraFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError || _cameraController == null || !_cameraController!.value.isInitialized) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.camera_alt, size: 48, color: Colors.grey),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Kamera tidak tersedia: ${snapshot.error ?? 'Unknown error'}'.trim(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return CameraPreview(_cameraController!);
                      },
                    ),
                    // Overlay saat scanning
                    if (isScanning)
                      Container(
                        color: Colors.black54,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: Colors.white),
                              SizedBox(height: 16),
                              Text(
                                'Memindai wajah...',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: isScanning ? null : doScan,
                  icon: const Icon(Icons.center_focus_strong),
                  label: Text(isScanning ? 'Memindai...' : 'Pindai Sekarang'),
                ),
                const SizedBox(width: 12),
                if (result != null)
                  OutlinedButton.icon(
                    onPressed: () async {
                      final moodValue = _mapLabelToMood(result.label);
                      ref.read(isSavingMoodProvider.notifier).state = true;
                      try {
                        await ref.read(moodRepositoryProvider).add(
                              mood: moodValue,
                              note: 'auto:${result.label} (${(result.confidence * 100).toStringAsFixed(0)}%)',
                            );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Tersimpan sebagai mood $moodValue (${result.label}).')),
                          );
                          Navigator.of(context).pop();
                        }
                      } finally {
                        ref.read(isSavingMoodProvider.notifier).state = false;
                      }
                    },
                    icon: const Icon(Icons.save_alt),
                    label: const Text('Simpan Hasil'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (result != null)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.fact_check),
                  title: Text('Deteksi: ${result.label}'),
                  subtitle: Text('Keyakinan: ${(result.confidence * 100).toStringAsFixed(0)}%'),
                ),
              ),
            const Spacer(),
            const Text(
              'Catatan: Ini fitur eksperimental. Silakan konfirmasi sebelum menyimpan.',
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  int _mapLabelToMood(String label) {
    switch (label.toLowerCase()) {
      case 'happy':
        return 5;
      case 'neutral':
        return 3;
      case 'sad':
        return 1;
      case 'angry':
        return 2;
      case 'surprised':
        return 4;
      default:
        return 3;
    }
  }
}


