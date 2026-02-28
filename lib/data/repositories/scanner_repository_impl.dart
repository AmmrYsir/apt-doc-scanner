import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import '../../domain/repositories/scanner_repository.dart';

class ScannerRepositoryImpl implements ScannerRepository {
  final FlutterDocScanner _scanner = FlutterDocScanner();

  @override
  Future<List<String>?> scan() async {
    try {
      final List<dynamic>? result = await _scanner.getScanDocuments();
      if (result != null && result.isNotEmpty) {
        return result.cast<String>();
      }
      return null;
    } catch (e) {
      // Log error or rethrow
      return null;
    }
  }
}
