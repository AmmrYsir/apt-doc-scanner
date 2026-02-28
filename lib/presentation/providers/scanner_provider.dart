import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/scanner_repository.dart';
import '../../data/repositories/scanner_repository_impl.dart';

final scannerRepositoryProvider = Provider<ScannerRepository>((ref) {
  return ScannerRepositoryImpl();
});

class ScannerState {
  final bool isScanning;
  final String? error;

  ScannerState({this.isScanning = false, this.error});

  ScannerState copyWith({bool? isScanning, String? error}) {
    return ScannerState(
      isScanning: isScanning ?? this.isScanning,
      error: error,
    );
  }
}

class ScannerNotifier extends Notifier<ScannerState> {
  @override
  ScannerState build() {
    return ScannerState();
  }

  Future<List<String>?> scanDocument() async {
    state = state.copyWith(isScanning: true);
    try {
      final repository = ref.read(scannerRepositoryProvider);
      final images = await repository.scan();
      state = state.copyWith(isScanning: false);
      return images;
    } catch (e) {
      state = state.copyWith(isScanning: false, error: e.toString());
      return null;
    }
  }
}

final scannerProvider = NotifierProvider<ScannerNotifier, ScannerState>(() {
  return ScannerNotifier();
});
