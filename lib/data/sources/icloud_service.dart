import 'dart:io';
import 'package:icloud_storage/icloud_storage.dart';

class ICloudService {
  final String _containerId = 'iCloud.com.example.aptDocScanner';

  Future<void> uploadFile(File file, String name) async {
    if (!Platform.isIOS) return;

    try {
      await ICloudStorage.upload(
        containerId: _containerId,
        filePath: file.path,
        destinationRelativePath: name,
        onProgress: (stream) {
          stream.listen((progress) {
            // Log progress
          });
        },
      );
    } catch (e) {
      // Handle error
    }
  }
}
