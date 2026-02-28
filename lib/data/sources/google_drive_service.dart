import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'google_drive_client.dart';

class GoogleDriveService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<void> initialize() async {
    await _googleSignIn.initialize();
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    try {
      final account = await _googleSignIn.authenticate(
        scopeHint: [drive.DriveApi.driveAppdataScope],
      );
      
      final authHeaders = await account.authorizationClient.authorizationHeaders(
        [drive.DriveApi.driveAppdataScope],
        promptIfNecessary: true,
      );

      if (authHeaders == null) return null;

      final client = GoogleAuthClient(authHeaders);
      return drive.DriveApi(client);
    } catch (e) {
      return null;
    }
  }

  Future<String?> uploadFile(File file, String name) async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) return null;

    final driveFile = drive.File();
    driveFile.name = name;
    driveFile.parents = ["appDataFolder"];

    final response = await driveApi.files.create(
      driveFile,
      uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
    );
    return response.id;
  }
}
