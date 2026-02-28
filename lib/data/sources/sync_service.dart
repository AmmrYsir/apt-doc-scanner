import 'dart:io';
import '../../domain/models/document.dart';
import 'google_drive_service.dart';
import 'icloud_service.dart';

enum SyncProvider { googleDrive, iCloud }

class SyncService {
  final GoogleDriveService _googleDrive = GoogleDriveService();
  final ICloudService _iCloud = ICloudService();

  Future<Document?> syncDocument(
    Document document,
    SyncProvider provider,
  ) async {
    if (document.imagePaths.isEmpty) return null;

    final file = File(document.imagePaths.first);
    if (!file.existsSync()) return null;

    if (provider == SyncProvider.googleDrive) {
      final driveId = await _googleDrive.uploadFile(
        file,
        '${document.name}.jpg',
      );
      if (driveId != null) {
        return Document(
          id: document.id,
          name: document.name,
          imagePaths: document.imagePaths,
          createdAt: document.createdAt,
          isSynced: true,
          googleDriveId: driveId,
          iCloudId: document.iCloudId,
        );
      }
    } else if (provider == SyncProvider.iCloud && Platform.isIOS) {
      await _iCloud.uploadFile(file, '${document.name}.jpg');
      return Document(
        id: document.id,
        name: document.name,
        imagePaths: document.imagePaths,
        createdAt: document.createdAt,
        isSynced: true,
        googleDriveId: document.googleDriveId,
        iCloudId: 'synced', // Placeholder
      );
    }
    return null;
  }
}
